using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class operation : MonoBehaviour
{

		//transform of a segment
		public Transform[] mSegments;
		AudioClip cutClip;
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
						mDisk.RotateAtR (1);
				}
				if (GUI.Button (new Rect (0, Screen.height / 15, Screen.width / 8, Screen.height / 15), "Rotate middle")) {
						mDisk.RotateAtR (2);
				}
				if (GUI.Button (new Rect (0, 2 * Screen.height / 15, Screen.width / 8, Screen.height / 15), "Rotate outer")) {
						mDisk.RotateAtR (3);
				}
				//if (GUI.Button (new Rect (0, 3 * Screen.height / 15, Screen.width / 8, Screen.height / 15), "PlaySound")) {
				//audio.Play();
				//}
		}
}

[System.Serializable]
public class Disk
{

		//temporary
		public DiskSegment[] mSegments;
		const int thetaModolus = 8; //this is not flexible
		const int radiusModolus = 3; //this is not flexible
		public AudioClip mRotateSound;
	public Texture2D mTexture;

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

		mRotateSound = (AudioClip) Resources.Load ("Sounds/grinderCut",typeof(AudioClip));



		}

		public void RotateAtR (int r)
		{
				DiskSegment[] temp = GetSegmentsR (r);

				for (int i=0; i<temp.Length; i++) {
						temp [i].Rotate (45.0f,mRotateSound.length);
				}

		AudioSource.PlayClipAtPoint (mRotateSound, new Vector3 (0, 12, 0));

		}

		DiskSegment[] GetSegmentsR (int r)
		{

				//Debug.Log ("Disk:GetSegmentsR() called");
				List<DiskSegment> temp = new List<DiskSegment> ();

				foreach (DiskSegment seg in mSegments) {
						//Debug.Log (System.String.Format ("Disk:GetSegmentsR() called 2, seg.r = {0} , input r = {1}", seg.r, r));
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
		iTween.RotateAdd (this.mTransform.gameObject,iTween.Hash("time",time,"amount",45*Vector3.up,"easetype",iTween.EaseType.linear));
		//iTween.MoveAdd (transform.gameObject,iTween.Hash("time",audio.clip.length,"amount",Vector3.forward,"easetype",iTween.EaseType.linear));

		}
}
