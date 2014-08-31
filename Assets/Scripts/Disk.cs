using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Disk : MonoBehaviour
{
	
		public GameObject theDiskPrefab;
		AbsDiskSegment[] mSegments;
		DiskController diskController = new DiskController ();
		List<DiskCmd> macroRotateCmd = new List<DiskCmd> ();
		MacroDiskRotateCmd mRcmd;
	
		void Start ()
		{
				diskController.Start ();
				GameObject theGO = (GameObject)Instantiate (theDiskPrefab, Vector3.zero, Quaternion.identity);
				Utility.SetAsChild (gameObject, theGO);

				mSegments = theGO.GetComponentsInChildren<AbsDiskSegment> ();

				ArrayList dsList = new ArrayList ();
				foreach (AbsDiskSegment DS in mSegments) {
						if (DS.r == 3) {
								//Debug.Log ("DS.r = 3");
								dsList.Add (DS);
								macroRotateCmd.Add (new DiskRotateCmd (DS));
						}

				}
				mRcmd = new MacroDiskRotateCmd (dsList);
		}

		void Update ()
		{
				diskController.Update ();
		}

		void OnGUI ()
		{
				if (GUI.Button (new Rect (0, 0, Screen.width / 8, Screen.height / 15), "Rotate inner")) {

						mRcmd.Execute ();
				}
				if (GUI.Button (new Rect (0, Screen.height / 15, Screen.width / 8, Screen.height / 15), "Rotate inner revert")) {

				}
				if (GUI.Button (new Rect (0, 2 * Screen.height / 15, Screen.width / 8, Screen.height / 15), "Rotate outer")) {
						//mDisk.RotateAtR (3, transform);
				}
				//if (GUI.Button (new Rect (0, 3 * Screen.height / 15, Screen.width / 8, Screen.height / 15), "PlaySound")) {
				//audio.Play();
				//}
		}

		void RotateInnerSeg () {
	}

}

/// <summary>
/// Disk, show how to order commands
/// </summary>
//public class Disk
//{
//public Disk (AbsDiskSegment[] segments)
//{
//}
	
/*
	 * 
		/// <summary>
		/// Rotates diskSegments at r ,from 1 to 3.
		/// </summary>
		/// <param name="r">The r coordinate, input from 1 to 3.</param>
		/// <param name="soundSource">Where Sound source should play.</param>
		public void RotateAtR (int r, Transform soundSource)
		{

				SegmentInfo[] temp = GetSegmentsR (r);
				for (int i=0; i<temp.Length; i++) {
						temp [i].Rotate (45.0f, mRotateSound.length);
				}
			
				if (soundSource != null)
						AudioSource.PlayClipAtPoint (mRotateSound, soundSource.transform.position);

		}

		public void ReflectAtTheta (int theta, Transform soundSource)
		{
			
		}

		/// <summary>
		/// Get the disk's segment by relative coordinate
		/// </summary>
		/// <returns>the segment with r, theta coor.</returns>
		/// <param name="r">r in relative coor, but suppose to be same as absolute.</param>
		/// <param name="theta">theta in relative coor.</param>
		public DiskSegment GetASegment (int r, int theta)
		{
		
				SegmentInfo temp;
		
				foreach (SegmentInfo seg in mSegments) {
						if (seg.r == r && seg.theta == theta) {
								temp = seg;
								return temp.mDiskSegment;
						}
				}
				Debug.LogError ("cannot find the segment");
				return null;
		}


		SegmentInfo[] GetSegmentsR (int r)
		{
				List<SegmentInfo> temp = new List<SegmentInfo> ();


				foreach (SegmentInfo seg in mSegments) {
						if (seg.r == r) {
								temp.Add (seg);
						}
				}
				return temp.ToArray ();
		}

		SegmentInfo[] GetSegmentTheta (int theta)
		{
				return null;
		}*/
//}

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
		DiskCmd curCmd;

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
				if (cmdWait.Count <= 5){
			cmdWait.Enqueue (aDiskCmd);
			Debug.Log("a cmd added");
		}
		}

		void Idle_Init ()
		{
		}

		void Idle_Proc ()
		{
		}

		void Idle_Term ()
		{
		}

		void Operating_Init ()
		{
		}

		void Operating_Proc ()
		{
		}

		void Operating_Term ()
		{
		}
}

