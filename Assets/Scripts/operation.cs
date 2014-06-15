using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class operation : MonoBehaviour
{

		//transform of a segment
		public Transform[] mSegments;
		Disk mDisk;

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

				if (GUI.Button (new Rect (0, 0, Screen.width / 10, Screen.height / 15), "Rotate")) {
						mDisk.RotateAtR (2);
				}
		}
}

public class Disk
{

		//temporary
		DiskSegment[] mSegments;
		const int thetaModolus = 8; //this is not flexible
		const int radiusModolus = 3; //this is not flexible

		public Disk (Transform[] segments)
		{

				mSegments = new DiskSegment[thetaModolus * radiusModolus];

				int i = 0;

				for (int r = 1; r <= radiusModolus; r++) {

						for (int theta = 1; theta <= thetaModolus; theta++) {
								mSegments [i] = new DiskSegment (segments [i], new Vector2 (r, theta));
				//Debug.Log (System.String.Format ("initialization: r: {0}, theta: {1}", mSegments [i].r, mSegments [i].theta));
								i++;
						}
				}
				Debug.Log ("initialization completed");
		}

		public void RotateAtR (int r)
		{

				//DiskSegment[] temp = new DiskSegment[8];
				DiskSegment[] temp = GetSegmentsR (r);


				Debug.Log ("RotateAtR(), temp.length: " + temp.Length);

				for (int i=0; i<temp.Length; i++) {
						Debug.Log ("Disk:RotateAtR() called");
						temp [i].Rotate (45.0f);
				}

		}

		DiskSegment[] GetSegmentsR (int r)
		{

				//Debug.Log ("Disk:GetSegmentsR() called");
				List<DiskSegment> temp = new List<DiskSegment> ();

				foreach (DiskSegment seg in mSegments) {
						Debug.Log (System.String.Format ("Disk:GetSegmentsR() called 2, seg.r = {0} , input r = {1}", seg.r, r));
						if (seg.r == r) {
								temp.Add (seg);
						}
				}

				Debug.Log ("GetSegmentsR, temp count: " + temp.Count);

				return temp.ToArray ();
		}

}

public class DiskSegment
{

		Transform mTransform;
		Vector2 mCoordinate; //(r,theta)

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

		public void Rotate (float angle)
		{
				Debug.Log ("DiskSegment:Rotate() called");
				mTransform.Rotate (new Vector3 (0, 45, 0));
		}
}
