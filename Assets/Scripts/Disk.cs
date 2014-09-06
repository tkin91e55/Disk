using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Disk : MonoBehaviour
{
	
		public GameObject theDiskPrefab;
		AbsDiskSegment[] mSegments;
		DiskController diskController = new DiskController ();
		//MacroDiskRotateCmd mRcmd;
		public AudioClip rotateSound;
	
		void Start ()
		{
				diskController.Start ();
				GameObject theGO = (GameObject)Instantiate (theDiskPrefab, Vector3.zero, Quaternion.identity);
				Utility.SetAsChild (gameObject, theGO);

				mSegments = theGO.GetComponentsInChildren<AbsDiskSegment> ();

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
			RotateMiddleSeg();
				}
				if (GUI.Button (new Rect (0, 2 * Screen.height / 15, Screen.width / 8, Screen.height / 15), "Rotate outer")) {
			RotateOuterSeg();
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
				foreach (AbsDiskSegment DS in mSegments) {
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

		Util.Mode<DiskController,State> mMode;
		int maxHistory = 5;
		List<ICommand> history = new List<ICommand> ();
		Queue<ICommand> cmdWait = new Queue<ICommand> ();
		ICommand curCmd;

		/// <summary>
		/// must be hooked outside since Diskcontroller is not a monobehavior
		/// </summary>
		public void Start ()
		{
				mMode = new Util.Mode<DiskController, State> (this);
				mMode.Set (State.Idle);
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

		void Idle_Proc ()
		{
				if (cmdWait.Count > 0) {
						if (cmdWait.Peek ().CanExecute ()) {
								curCmd = cmdWait.Peek ();
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

