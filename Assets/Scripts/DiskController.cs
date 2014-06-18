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

		//temporary
		DiskSegment[] mSegments;
		const int thetaModolus = 8; //this is not flexible
		const int radiusModolus = 3; //this is not flexible
		AudioClip mRotateSound;

	enum DiskState {}
	Util.Mode<Disk,DiskState> mode;
	public IDisk virDisk;



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

				mRotateSound = (AudioClip)Resources.Load ("Sounds/grinderCut", typeof(AudioClip));

		}

		public void RotateAtR (int r, Transform soundSource)
		{
				DiskSegment[] temp = GetSegmentsR (r);

				for (int i=0; i<temp.Length; i++) {
						temp [i].Rotate (45.0f, mRotateSound.length);
				}

				AudioSource.PlayClipAtPoint (mRotateSound, soundSource.transform.position);

		}

	public void ReflectAtTheta (int theta, Transform soundSource){}



		DiskSegment[] GetSegmentsR (int r)
		{
				List<DiskSegment> temp = new List<DiskSegment> ();

				foreach (DiskSegment seg in mSegments) {
						if (seg.r == r) {
								temp.Add (seg);
						}
				}
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

		public void Rotate (float angle, float time)
		{
				//mTransform.Rotate (new Vector3 (0, 45, 0));
				iTween.RotateAdd (this.mTransform.gameObject, iTween.Hash ("time", time, "amount", 45 * Vector3.up, "easetype", iTween.EaseType.easeInQuad));
				//iTween.MoveAdd (transform.gameObject,iTween.Hash("time",audio.clip.length,"amount",Vector3.forward,"easetype",iTween.EaseType.linear));

		}
}
