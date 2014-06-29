using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class DiskController : MonoBehaviour
{

		//transform of a segment
		public Transform[] mSegments;
		public Disk mDisk;

		// Use this for initialization
		void Start ()
		{
				mDisk = new Disk (mSegments);
		}
	
		// Update is called once per frame
		void Update ()
		{
		mDisk.mode.Proc();
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

[System.Serializable]
public class Disk:IDisk
{

		class SegmentInfo:IDiskSegment
		{
		
				IDiskSegment mSeg;
				int relativeTheta;
				static int thetaMod = 8;
				public int test;

				/// <summary>
				/// Initializes a new instance of the <see cref="Disk+SegmentInfo"/> struct.
				/// </summary>
				/// <param name="aTrans">A transformaton of disk segment in scene</param>
				/// <param name="aCoor">The absolute(correct, original) coordinate for the true picture of puzzle.</param>
				public SegmentInfo (Transform aTrans, Vector2 aCoor)
				{
			
						//Assign mSeg as a instance of DiskSegment
						mSeg = new DiskSegment (aTrans, aCoor);
						relativeTheta = mSeg.theta;
						test = 1;
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

				/// <summary>
				/// operator the increase the relative angle coordiante by 1, auto handle recycling
				/// </summary>
				/// <param name="aSeg">A SegmentInfo.</param>
				public static SegmentInfo operator ++ (SegmentInfo aSeg)
				{
						//Debug.Log("segmentInfo operator ++ called and original aSeg.relativeTheta is: " + aSeg.relativeTheta);
						aSeg.relativeTheta ++;
						if (aSeg.relativeTheta > thetaMod)
								aSeg.relativeTheta = 1;
						//Debug.Log("the after relativeTheta is : " + aSeg.relativeTheta);
						return aSeg;
				}
		}

		SegmentInfo[] mSegments;

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

		public Disk (Transform[] segments)
		{
				mSegments = new SegmentInfo[thetaDivision * radiusDivision];
				mode = new Util.Mode<Disk, DiskState> (this);

				mode.Set (DiskState.isBusy);
					
				int i = 0;

				for (int r = 1; r <= radiusDivision; r++) {
						for (int theta = 1; theta <= thetaDivision; theta++) {
								mSegments [i] = new SegmentInfo (segments [i], new Vector2 (r, theta));
								
								//Debug.Log (System.String.Format ("initialization: r: {0}, theta: {1}", mSegments [i].r, mSegments [i].theta));
								i++;
						}
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

		SegmentInfo[] GetSegmentTheta (int theta){

		return null;


	}
}

public class DiskSegment:IDiskSegment
{

		public Transform mTransform;
		Vector2 mCoordinate; //(r,theta), the coordinate has no zero offset

		public int r {
				get{ return (int)mCoordinate.x;}
		}

		public int theta {
				get{ return (int)mCoordinate.y;}
		}

		public DiskSegment (Transform aTrans, Vector2 aCoor)
		{
				if (aTrans != null)
						mTransform = aTrans;
				else
						Debug.Log ("null diskSegment Trans init");

				if (aCoor != null)
						mCoordinate = aCoor;
				else
						Debug.Log ("null diskSegment Coor init");

		}

		public void Rotate (float angle, float time)
		{
				//mTransform.Rotate (new Vector3 (0, 45, 0));
				iTween.RotateAdd (this.mTransform.gameObject, iTween.Hash ("time", time, "amount", 45 * Vector3.up, "easetype", iTween.EaseType.easeInQuad));
				//iTween.MoveAdd (transform.gameObject,iTween.Hash("time",audio.clip.length,"amount",Vector3.forward,"easetype",iTween.EaseType.linear));
		}

		public void Reflect () {
	}
}
