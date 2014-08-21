using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class main : MonoBehaviour
{
	
		public GameObject theDiskPrefab;
		Disk mDisk;
		AbsDiskSegment[] mSegments;
	DiskController diskController = new DiskController();

		// Use this for initialization
		void Start ()
		{
		diskController.Start();
				GameObject theGO = (GameObject)Instantiate (theDiskPrefab, Vector3.zero, Quaternion.identity);
				Utility.SetAsChild (gameObject, theGO);

				mSegments = theGO.GetComponentsInChildren<AbsDiskSegment> ();
				
				mDisk = new Disk (mSegments);
		}
	
		// Update is called once per frame
		void Update ()
		{
		diskController.Update();
		}

		void OnGUI ()
		{
				if (GUI.Button (new Rect (0, 0, Screen.width / 8, Screen.height / 15), "Rotate inner")) {
						foreach (AbsDiskSegment DS in mSegments) {
								if (DS.r == 3) {
										//Debug.Log ("DS.r = 3");
										DiskCmd rotateCmd = new DiskRotateCmd (DS);
										rotateCmd.Execute ();
								}
						}
						//mDisk.RotateAtR (1, transform);
				}
				if (GUI.Button (new Rect (0, Screen.height / 15, Screen.width / 8, Screen.height / 15), "Rotate middle")) {
						//mDisk.RotateAtR (2, transform);
				}
				if (GUI.Button (new Rect (0, 2 * Screen.height / 15, Screen.width / 8, Screen.height / 15), "Rotate outer")) {
						//mDisk.RotateAtR (3, transform);
				}
				//if (GUI.Button (new Rect (0, 3 * Screen.height / 15, Screen.width / 8, Screen.height / 15), "PlaySound")) {
				//audio.Play();
				//}
		}
}

public class Disk
{
		public Disk (AbsDiskSegment[] segments)
		{
		}
	
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
}

public class DiskController {

	public enum State {
		idle,
		operating
	}

	Util.Mode<DiskController,State> mMode;

	int maxHistory = 5;
	List<DiskCmd> history = new List<DiskCmd>();
	Queue<DiskCmd> cmdWait = new Queue<DiskCmd>();
	DiskCmd curCmd;

	/// <summary>
	/// must be hooked outside since Diskcontroller is not a monobehavior
	/// </summary>
	public void Start () {
		mMode = new Util.Mode<DiskController, State>(this);
		mMode.Set (State.idle);
	}

	/// <summary>
	/// must be hooked outside since Diskcontroller is not a monobehavior
	/// </summary>
	public void Update()
	{
		mMode.Proc();
	}
}

