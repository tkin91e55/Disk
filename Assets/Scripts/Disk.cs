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
				if (GUI.Button (new Rect (0, Screen.height / 15, Screen.width / 8, Screen.height / 15), "Rotate inner revert")) {
						RotateMiddleSeg ();
				}
				if (GUI.Button (new Rect (0, 2 * Screen.height / 15, Screen.width / 8, Screen.height / 15), "Rotate outer")) {
						RotateOuterSeg ();
				}
				if (GUI.Button (new Rect (0, 3 * Screen.height / 15, Screen.width / 8, Screen.height / 15), "Undo")) {

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

		void Undo ()
		{
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

		Util.Mode<DiskController,State> mMode;
		DiskCmdHistory mHistory = new DiskCmdHistory ();
		//History Enumerator
		DiskHistoryEnum mHistoryEnum;
		Queue<ICommand> cmdWait = new Queue<ICommand> ();
		ICommand curCmd;

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
				if (aDiskCmd.GetType ().BaseType != typeof(DiskCmd))
				if (aDiskCmd.GetType ().BaseType != typeof(DiskMacroCmd)) {
						Debug.Log ("not a disk command");
						return;
				}
				if (cmdWait.Count <= 5) {
						cmdWait.Enqueue (aDiskCmd);
						Debug.Log ("a cmd added");
				}
		}

		public void UndoHistory ()
		{
		}

		public void RedoHistory ()
		{
		}

		void Idle_Proc ()
		{
				if (cmdWait.Count > 0) {
						if (cmdWait.Peek ().CanExecute ()) {
								curCmd = cmdWait.Peek ();
				mHistory.AddHistory(curCmd);
				mHistoryEnum.MoveNext();
								cmdWait.Dequeue ().Execute ();
								mMode.Set (State.Operating);
						}
				}
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

		public void AddHistory (ICommand aHistory)
		{
				if (mHistory.Count > maxRecord)
						mHistory.RemoveAt (0);

				mHistory.Add (aHistory);
		}

	public void RewriteHistory (DiskHistoryEnum enumerator){

		while (enumerator.Index + 1< mHistory.Count)
			mHistory.RemoveAt(mHistory.Count-1);

		//doing something to make outer enumerator sync at tip and mHistory will then record the new cmd
	}
}

public class DiskHistoryEnum : IEnumerator, IBackwardEnumerator
{
		List<ICommand> mCollections = new List<ICommand> ();
		int index = -1;

	public int Index {
		get {
			return index;
		}
	}

		public DiskHistoryEnum (List<ICommand> cmdList)
		{
				mCollections = cmdList;
		}

		public bool MoveNext ()
		{
				index ++;
				return (index < mCollections.Count);
		}

		public bool MoveBack ()
		{
				if (index > -2)
						index --;
				return (index > -1);
		}

		public void Reset ()
		{
				index = -1;
		}

		public ICommand Current {
				get {
						try {
								return mCollections [index];
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

