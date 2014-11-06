using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// Disk controller, command executer
/// </summary>
public class DiskController
{
	public enum State
	{
		Idle,
		Operating
	}
	
	enum CmdOpType
	{
		TYPE_NORMAL,
		TYPE_UNDO,
		TYPE_REDO
	}
	
	class WaitCommand
	{
		
		public ICommand cmd;
		public CmdOpType type;
		
		public WaitCommand (ICommand aCmd, CmdOpType aType)
		{
			cmd = aCmd;
			type = aType;
		}
	}
	
	Util.Mode<DiskController,State> mMode;
	DiskCmdHistory mHistory = new DiskCmdHistory ();
	//History Enumerator
	DiskHistoryEnum mHistoryEnum;
	Queue<WaitCommand> cmdWait = new Queue<WaitCommand> ();
	ICommand curCmd;
	int maxCmdWait = 30;
	
	/// <summary>
	/// must be hooked outside since Diskcontroller is not a monobehavior
	/// </summary>
	public void Start ()
	{
		mMode = new Util.Mode<DiskController, State> (this);
		mMode.Set (State.Idle);
		mHistoryEnum = mHistory.GetEnumerator ();
	}
	
	/// <summary>
	/// must be hooked outside since Diskcontroller is not a monobehavior
	/// </summary>
	public void Update ()
	{
		mMode.Proc ();
	}
	
	public void AddCmd (ICommand aDiskCmd)
	{
		CreateWaitCmd (aDiskCmd, CmdOpType.TYPE_NORMAL);
	}
	
	public void UndoHistory ()
	{
		//ugly point due to index handling:
		if (mHistoryEnum.Index > mHistoryEnum.Count - 1)
			mHistoryEnum.MoveBack ();
		
		ICommand history = mHistoryEnum.Current;

		if (mHistoryEnum.MoveBack ()) {
			//it is kind of ugly you really need this non-null check here, since get current is not non null proof
			if (history != null)
				CreateWaitCmd (history, CmdOpType.TYPE_UNDO);
		}
	}
	
	public void RedoHistory ()
	{
		//to redo, since enumerator is supposed to always point to the cmd that undo will make the disk return to previous state, so need enumerator
		//move to next cmd (if there is) and then execute to redo history
		
		if (mHistoryEnum.MoveNext ()) {
			ICommand history = mHistoryEnum.Current;
			if (history != null)
				CreateWaitCmd (history, CmdOpType.TYPE_REDO);
		}
	}

	public void CancelBufferCmd () {
		cmdWait.Clear();
		mHistoryEnum.OnCancel();
	}
	
	void CreateWaitCmd (ICommand aDiskCmd, CmdOpType atype)
	{ 
		if (aDiskCmd.GetType ().BaseType != typeof(DiskMacroCmd)) {
			Debug.LogError ("not a disk command");
			return;
		}
		if (cmdWait.Count <= maxCmdWait) {
			cmdWait.Enqueue (new WaitCommand (aDiskCmd, atype));
			//Debug.Log("Buffer cmd remained: " + cmdWait.Count);
		}
	}
	
	void Idle_Proc ()
	{
		if (cmdWait.Count > 0) {
			if (cmdWait.Peek ().cmd.CanExecute ()) {
				curCmd = cmdWait.Peek ().cmd;
				
				switch (cmdWait.Peek ().type) {
				case CmdOpType.TYPE_NORMAL:
					mHistory.RewriteHistory (mHistoryEnum, curCmd);
					cmdWait.Dequeue ().cmd.Execute ();
					break;
				case CmdOpType.TYPE_UNDO:
					DiskMacroCmd macroCmd = (DiskMacroCmd)cmdWait.Dequeue ().cmd;
					mHistoryEnum.OnSure();
					macroCmd.Undo ();	 
					break;
				case CmdOpType.TYPE_REDO:
					DiskMacroCmd Cmd = (DiskMacroCmd)cmdWait.Dequeue ().cmd;
					mHistoryEnum.OnSure();
					Cmd.Execute ();	
					break;
				default:
					Debug.LogError ("unknown type");
					break;
				}
				
				mMode.Set (State.Operating);
			}
		}
	}
	
	void Operating_Proc ()
	{
		if (curCmd != null)
		if (curCmd.CanExecute ()) {
			mMode.Set (State.Idle);
		}
	}
	
	void Operating_Term ()
	{
		curCmd = null;
	}
}

public class DiskCmdHistory : IEnumerable
{
	int maxRecord = 15;
	List<ICommand> mHistory = new List<ICommand> ();
	
	IEnumerator IEnumerable.GetEnumerator ()
	{
		return (IEnumerator)GetEnumerator ();
	}
	
	public DiskHistoryEnum GetEnumerator ()
	{
		return new DiskHistoryEnum (mHistory);
	}
	
	public void AddHistory (DiskHistoryEnum enumerator, ICommand aHistory)
	{
		if (mHistory.Count > maxRecord)
			mHistory.RemoveAt (0);
		
		mHistory.Add (aHistory);
		//Debug.Log ("a history item added");
		enumerator.SyncHistoryEnum ();
	}
	
	public void RewriteHistory (DiskHistoryEnum enumerator, ICommand aHistory)
	{
		//suppose enumerator.Index at max is mHistory.Count
		if (enumerator.Index > mHistory.Count - 1)
			enumerator.MoveBack ();
		
		while (enumerator.Index + 1< mHistory.Count) {
			//Debug.Log (string.Format ("enumerator.index: {0}, mHistory.Count: {1}", enumerator.Index, mHistory.Count));
			mHistory.RemoveAt (mHistory.Count - 1);
		}
		
		AddHistory (enumerator, aHistory);
		
	}
}

public class DiskHistoryEnum : IEnumerator, IBackwardEnumerator
{
	//README: enumerator is supposed to always point to the cmd that undo will make the disk return to previous state
	
	List<ICommand> mCollections = new List<ICommand> ();
	//note in this iterator, index is ranged from -1 to mCollections.Count
	int index = -1;
	/// <summary>
	/// A buffer for index
	/// </summary>
	int safeIndex = -1;
	
	public int Index {
		get {
			return index;
		}
	}
	
	public int Count {
		get {
			return mCollections.Count;
		}
	}
	
	public DiskHistoryEnum (List<ICommand> cmdList)
	{
		mCollections = cmdList;
	}
	
	public bool MoveNext ()
	{
		index ++;
		
		if (index > mCollections.Count)
			index = mCollections.Count;
		
		return (index < mCollections.Count);
	}
	
	public bool MoveBack ()
	{
		index --;
		
		if (index < -1)
			index = -1;
		
		return (index >= -1);
	}
	
	public void Reset ()
	{
		index = -1;
	}
	
	public void MoveToHead ()
	{
		index = 0;
	}
	
	public void SyncHistoryEnum ()
	{
		index = mCollections.Count - 1;
		SyncSafeIndex();
	}
	
	public void OnSure ()
	{
		
		if (safeIndex > index) {
			safeIndex--;
		} else if (safeIndex < index) {
			safeIndex ++;
		}
	}
	
	public void OnCancel ()
	{
		index = safeIndex;
	}

	void SyncSafeIndex(){
		safeIndex = index;
	}
	
	public ICommand Current {
		get {
			try {
				if (index > -1 && index < mCollections.Count)
					return mCollections [index];
				else
					return null;
			} catch (System.IndexOutOfRangeException) {
				throw new System.InvalidOperationException ();
			}
		}
	}
	
	object IEnumerator.Current {
		get {
			return Current;
		}
	}
	
}



