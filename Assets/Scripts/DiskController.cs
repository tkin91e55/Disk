using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class DiskController : MonoBehaviour
{
	
		public GameObject theDiskPrefab;
		Disk mDisk;

		// Use this for initialization
		void Start ()
		{
				GameObject theGO = (GameObject)Instantiate (theDiskPrefab, Vector3.zero, Quaternion.identity);
				Utility.SetAsChild (gameObject, theGO);
				DiskSegment[] mSegments;

				mSegments = theGO.GetComponentsInChildren<DiskSegment> ();
				
				mDisk = new Disk (mSegments);
		}
	
		// Update is called once per frame
		void Update ()
		{
				mDisk.mode.Proc ();
		}

		void OnGUI ()
		{

				if (GUI.Button (new Rect (0, 0, Screen.width / 8, Screen.height / 15), "Rotate inner")) {
						mDisk.RotateAtR (1, transform);
				}
				if (GUI.Button (new Rect (0, Screen.height / 15, Screen.width / 8, Screen.height / 15), "Rotate middle")) {
						mDisk.RotateAtR (2, transform);
				}
				if (GUI.Button (new Rect (0, 2 * Screen.height / 15, Screen.width / 8, Screen.height / 15), "Rotate outer")) {
						mDisk.RotateAtR (3, transform);
				}
				//if (GUI.Button (new Rect (0, 3 * Screen.height / 15, Screen.width / 8, Screen.height / 15), "PlaySound")) {
				//audio.Play();
				//}
		}
}

public class Disk:IDisk
{

		public class SegmentInfo:IDiskSegment
		{
		
				IDiskSegment mSeg;
				int relativeTheta;
				static int thetaMod = 8;

				/// <summary>
				/// Initializes a new instance of the <see cref="Disk+SegmentInfo"/> struct.
				/// </summary>
				/// <param name="aTrans">A transformaton of disk segment in scene</param>
				/// <param name="aCoor">The absolute(correct, original) coordinate for the true picture of puzzle.</param>
				public SegmentInfo (DiskSegment aSeg)
				{
			
						//Assign mSeg as a instance of DiskSegment
						mSeg = aSeg;
						relativeTheta = mSeg.theta;
						

				}

				/// <summary>
				/// Gets the relative r, i.e. the absolute r
				/// </summary>
				/// <value>The r.</value>
				public int r {
						get { return mSeg.r;}
				}
	
				/// <summary>
				/// The relative theta to the disk
				/// </summary>
				/// <value>The theta angle with offset is 1</value>
				public int theta {
						get { return relativeTheta;}
				}

				public void Rotate (float angle, float time)
				{
						mSeg.Rotate (angle, time);

						//this++;
						PlusRelativeTheta ();
				}

				public DiskSegment mDiskSegment {

						get { return (DiskSegment)mSeg;}
				}

				/// <summary>
				///  Increase the relative angle coordiante by 1, auto handle recycling
				/// </summary>
				void PlusRelativeTheta ()
				{

						relativeTheta ++;
						if (relativeTheta > thetaMod)
								relativeTheta = 1;
				}

		}

		public SegmentInfo[] mSegments;

		//temporary
		const int thetaDivision = 8; //this is not flexible
		const int radiusDivision = 3;

		//this is not flexible
		AudioClip mRotateSound;

		/// <summary>
		/// The number of segment of this Disk contains
		/// </summary>
		/// <value>The segment count.</value>
		public int SegmentCount {
				get{ return mSegments.Length;}
		}

		public enum DiskState
		{
				isIdle,
				isBusy,
				isOperating
		}

		public Util.Mode<Disk,DiskState> mode;

		public Disk (DiskSegment[] segments)
		{
				int totSegments = segments.Length;
				mSegments = new SegmentInfo[totSegments];
				mode = new Util.Mode<Disk, DiskState> (this);

				mode.Set (DiskState.isBusy);
					
				for (int i = 0; i< totSegments; i++) {
						mSegments [i] = new SegmentInfo (segments [i]);
				}

				mRotateSound = (AudioClip)Resources.Load ("Sounds/grinderCut", typeof(AudioClip));
				mode.Set (DiskState.isIdle);

		}

	#region Disk's public function
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
	

	#endregion


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
		}
}

