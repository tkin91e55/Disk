using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Disk : MonoBehaviour
{
	
		public GameObject theDiskPrefab;
		AbsDiskSegment[] mSegments;
		RelativeDiskSegment[] mRelativeSegments;
		DiskController diskController = new DiskController ();
		//MacroDiskRotateCmd mRcmd;
		public AudioClip rotateSound;
	
		void Start ()
		{
				diskController.Start ();
				GameObject theGO = (GameObject)Instantiate (theDiskPrefab, Vector3.zero, Quaternion.identity);
				Utility.SetAsChild (gameObject, theGO);

				mSegments = theGO.GetComponentsInChildren<AbsDiskSegment> ();
				mRelativeSegments = new RelativeDiskSegment[mSegments.Length];
				for (int i = 0; i < mRelativeSegments.Length; i++) {
						mRelativeSegments [i] = new RelativeDiskSegment (mSegments [i]);
				}
		}

		void Update ()
		{
				diskController.Update ();
		}

		void OnGUI ()
		{
				if (GUI.Button (new Rect (0, 0, Screen.width / 8, Screen.height / 15), "Rotate inner")) {
						RotateInnerSeg ();
				}
				if (GUI.Button (new Rect (0, Screen.height / 15, Screen.width / 8, Screen.height / 15), "Rotate Middle")) {
						RotateMiddleSeg ();
				}
				if (GUI.Button (new Rect (0, 2 * Screen.height / 15, Screen.width / 8, Screen.height / 15), "Rotate outer")) {
						RotateOuterSeg ();
				}
				if (GUI.Button (new Rect (0, 3 * Screen.height / 15, Screen.width / 8, Screen.height / 15), "Undo")) {
						Undo ();
				}
				if (GUI.Button (new Rect (0, 4 * Screen.height / 15, Screen.width / 8, Screen.height / 15), "Redo")) {
						Redo ();
				}

		}

		void RotateInnerSeg ()
		{
				SetRotation (1);
		}

		void RotateMiddleSeg ()
		{
				SetRotation (2);
		}

		void RotateOuterSeg ()
		{
				SetRotation (3);
		}

		void Undo ()
		{
				Debug.Log ("Disk.Undo()");
				diskController.UndoHistory ();
		}

		void Redo ()
		{

				diskController.RedoHistory ();
		}

		/// <summary>
		/// This is very private function
		/// </summary>
		/// <param name="i">The index.</param>
		void SetRotation (int i)
		{
				ArrayList dsList = new ArrayList ();
				foreach (RelativeDiskSegment DS in mRelativeSegments) {
						if (DS.r == i) {
								dsList.Add (DS);
						}
				}
				diskController.AddCmd (new MacroDiskRotateCmd (dsList, rotateSound, transform));
		}



}

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
		if(mHistoryEnum.Index > mHistoryEnum.Count - 1)
			mHistoryEnum.MoveToTail();

				Debug.Log ("controller.UndoHistory() and mHisotryEnum.Index: " + mHistoryEnum.Index);
				ICommand history = mHistoryEnum.Current;
				if (mHistoryEnum.MoveBack ()) {
						Debug.Log ("moveBack()");
						//it is kind of ugly you really need this non-null check here, since get current is not non null proof
						if (history != null)
								CreateWaitCmd (history, CmdOpType.TYPE_UNDO);
				}
		}

		public void RedoHistory ()
		{
				//ugly point due to index handling:
				if(mHistoryEnum.Index < 0)
			mHistoryEnum.MoveToHead();

				Debug.Log ("controller.RedoHistory() and mHisotryEnum.Index: " + mHistoryEnum.Index);

				if (mHistoryEnum.MoveNext ()) {
						Debug.Log ("moveNext()");
						ICommand history = mHistoryEnum.Current;
						if (history != null)
								CreateWaitCmd (history, CmdOpType.TYPE_REDO);
				}
		}

		void CreateWaitCmd (ICommand aDiskCmd, CmdOpType atype)
		{

				if (aDiskCmd.GetType ().BaseType != typeof(DiskMacroCmd)) {
						Debug.Log ("not a disk command");
						return;
				}
				if (cmdWait.Count <= maxCmdWait) {
						cmdWait.Enqueue (new WaitCommand (aDiskCmd, atype));
						Debug.Log ("a cmd added");
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
										macroCmd.Undo ();	 
										break;
								case CmdOpType.TYPE_REDO:
										DiskMacroCmd Cmd = (DiskMacroCmd)cmdWait.Dequeue ().cmd;
										Cmd.Execute ();	
										break;
								default:
										Debug.Log ("unknown type");
										break;
								}
								
								mMode.Set (State.Operating);
						}
				}
		}

		void Idle_Term ()
		{

				DiskHistoryEnum iterator = mHistory.GetEnumerator ();

				while (iterator.MoveNext())
						Debug.Log (iterator.Current.ToString ());
		}

		void Operating_Proc ()
		{
				if (curCmd != null)
				if (curCmd.CanExecute ()) {
						mMode.Set (State.Idle);
						Debug.Log ("return back to idle state");
				}
		}

		void Operating_Term ()
		{
				curCmd = null;
				Debug.Log ("set curCmd to null");
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
				Debug.Log ("a history item added");
				enumerator.MoveToTail ();
		}

		public void RewriteHistory (DiskHistoryEnum enumerator, ICommand aHistory)
		{
				//suppose enumerator.Index at max is mHistory.Count
				if (enumerator.Index > mHistory.Count - 1)
						enumerator.MoveBack ();

				while (enumerator.Index + 1< mHistory.Count) {
						Debug.Log (string.Format ("enumerator.index: {0}, mHistory.Count: {1}", enumerator.Index, mHistory.Count));
						mHistory.RemoveAt (mHistory.Count - 1);
				}

				AddHistory (enumerator, aHistory);

		}
}

public class DiskHistoryEnum : IEnumerator, IBackwardEnumerator
{
		List<ICommand> mCollections = new List<ICommand> ();
	//note in this iterator, index is ranged from -1 to mCollections.Count
		int index = -1;

		public int Index {
				get {
						return index;
				}
		}

		public int Count {
				get{
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

		public void MoveToTail ()
		{
				index = mCollections.Count - 1;
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

