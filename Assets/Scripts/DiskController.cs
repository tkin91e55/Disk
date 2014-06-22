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

		struct SegmentInfo:IDiskSegment
		{
		
				IDiskSegment mSeg;
				int relativeTheta;
				static int thetaMod = 0;

				/// <summary>
				/// Gets the relative r, i.e. the absolute r
				/// </summary>
				/// <value>The r.</value>
				public int r {
						get { return mSeg.r;}
				}

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
				}

				/// <summary>
				/// operator the increase the relative angle coordiante by 1, auto handle recycling
				/// </summary>
				/// <param name="aSeg">A SegmentInfo.</param>
				public static SegmentInfo operator ++ (SegmentInfo aSeg)
				{
						aSeg.relativeTheta ++;
						if (aSeg.relativeTheta > thetaMod)
								aSeg.relativeTheta = 1;
						return aSeg;
				}
		}

		SegmentInfo[] mSegments;

		//temporary
		DiskSegment[] mSegmentsTemp;
		const int thetaDivision = 8; //this is not flexible
		const int radiusDivision = 3;

		//this is not flexible
		AudioClip mRotateSound;
		Hashtable mRelativeAngle2Disk;
		//RelativeAngle2Disk mTransAngle


		public int SegmentCount {
				get{ return mSegments.Length;}
		}

		enum DiskState
		{
				isIdle,
				isBusy,
				isOperating
		}
		Util.Mode<Disk,DiskState> mode;

		public Disk (Transform[] segments)
		{

				//mSegmentsTemp = new DiskSegment[thetaDivision * radiusDivision];
		mSegments = new SegmentInfo[thetaDivision * radiusDivision];

				mode.Set (DiskState.isBusy);
					
				int i = 0;

				for (int r = 1; r <= radiusDivision; r++) {

						for (int theta = 1; theta <= thetaDivision; theta++) {
								mSegments [i] = new SegmentInfo (segments [i], new Vector2 (r, theta));
								
								//Debug.Log(mRelativeAngle2Disk[mSegments[i]]);
								//Debug.Log (System.String.Format ("initialization: r: {0}, theta: {1}", mSegments [i].r, mSegments [i].theta));
								i++;
						}
				}

				mRotateSound = (AudioClip)Resources.Load ("Sounds/grinderCut", typeof(AudioClip));
				mode.Set (DiskState.isIdle);

		}

		/// <summary>
		/// Rotates diskSegments at r ,from 1 to 8.
		/// </summary>
		/// <param name="r">The r coordinate.</param>
		/// <param name="soundSource">Where Sound source should play.</param>
		public void RotateAtR (int r, Transform soundSource)
		{
				DiskSegment[] temp = GetSegmentsR (r);

				for (int i=0; i<temp.Length; i++) {
						temp [i].Rotate (45.0f, mRotateSound.length);
				}
			
				if (soundSource != null)
						AudioSource.PlayClipAtPoint (mRotateSound, soundSource.transform.position);

		}

		public void ReflectAtTheta (int theta, Transform soundSource)
		{
		}

		DiskSegment[] GetSegmentsR (int r)
		{
		List<SegmentInfo> temp = new List<SegmentInfo> ();

		foreach (SegmentInfo seg in mSegments) {
						if (seg.r == r) {
								temp.Add (seg);
						}
				}
				return temp.ToArray ();
		}

		public DiskSegment GetASegment (int r, int theta)
		{

				DiskSegment temp;

				foreach (DiskSegment seg in mSegmentsTemp) {
						if (seg.r == r && seg.theta == theta) {
								temp = seg;
								return temp;
						}
				}
				Debug.LogError ("cannot find the segment");
				return null;
		}

}

public class DiskSegment:IDiskSegment
{

		Transform mTransform;
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
}
