using UnityEngine;
using System.Collections;
using System;

//this class need to inherit from monobehaviour and becomes an individual script to make itween callbacks work
public class AbsDiskSegment: MonoBehaviour, IDiskSegment
{
		/// <summary>
		/// x is r, y is theta 	
		/// </summary>
		public Vector2 mCoordinate; //(r,theta), the coordinate has no zero offset
	
		public int r {
				get{ return (int)mCoordinate.x;}
		}
	
		public int theta {
				get{ return (int)mCoordinate.y;}
		}

		enum SegState
		{
				Idle=0,
				Busy=1
		} 

		SegState mState = SegState.Idle;

		public bool IsBusy {
				get {
						switch (mState) {
						case AbsDiskSegment.SegState.Idle:
								return false;
						case AbsDiskSegment.SegState.Busy:
								return true;
						default:
								Debug.LogError ("strange case for absSeg state");
								return true;
						}
				}
		}
	
		void Awake ()
		{
				Normalize (-1);
		}

		public void Rotate (float angle, float time)
		{
				mState = SegState.Busy;
				iTween.RotateAdd (gameObject, iTween.Hash ("time", time, "amount", angle * Vector3.up, "easetype", iTween.EaseType.easeInQuad, "oncomplete", "OnCompleteOperation"));
		}

	public void Reflect (float AxesAngle, float time, int isConjugate = -1)
		{
		}
	
		public void DoReflect (float AxesAngle, float time, int relativeTheta,int isConjugate = -1 )
		{
				mState = SegState.Busy;
				GameObject reflectAxes = new GameObject ();
				OnReflectParam param = new OnReflectParam (reflectAxes, this.gameObject, relativeTheta);

				reflectAxes.name = "reflectAxes" + AxesAngle.ToString () + "_" + r.ToString ();
				reflectAxes.transform.RotateAround (transform.position, Vector3.up, (float)AxesAngle);

				GameObject theAxes = GameObject.Find ("reflectAxes" + AxesAngle.ToString () + "_" + r.ToString ());

				Utility.SetAsChild (gameObject.transform.parent.gameObject, theAxes);
				Utility.SetAsChild (theAxes, gameObject);

				iTween.RotateAdd (theAxes, iTween.Hash ("time", time, "amount", isConjugate*180.0f * Vector3.right, "easetype", iTween.EaseType.linear));
				iTween.RotateAdd (gameObject, iTween.Hash ("time", time, "amount", 180.0f * Vector3.forward, "easetype", iTween.EaseType.linear, "oncomplete", "OnCompleteReflect", "oncompleteparams", param));

		}

		void OnCompleteReflect (OnReflectParam param)
		{
				if (param != null) {
						Utility.SetAsChild (param.axes.transform.parent.gameObject, param.go);
						Destroy (param.axes);
				}
				Normalize (param.theta);
				OnCompleteOperation ();
		}

		void OnCompleteOperation ()
		{
				mState = SegState.Idle;
		}

		void Normalize (int angle = -1)
		{
				transform.position = Vector3.zero;
				transform.localScale = Vector3.one;
				int targetY = -1;

				if (angle == -1)
						targetY = DiskUtility.GetDegreeTheta (theta, 8); //8 here should be temporary
				else
						targetY = DiskUtility.GetDegreeTheta (angle, 8);

				Quaternion target = Quaternion.Euler (0, targetY, 0);
				transform.rotation = Quaternion.Slerp (transform.rotation, target, 1);
		}

		class OnReflectParam
		{
				public GameObject axes;
				public GameObject go;
				public int theta;

				public OnReflectParam (GameObject aAxes, GameObject aGo, int angle)
				{
						axes = aAxes;
						go = aGo;
						theta = angle;
				}
		}

}

public class RelativeDiskSegment : IDiskSegment
{
		AbsDiskSegment mSegment;
		int relativeR;
		int relativeTheta;
		public int Rmod = 3;
		public int ThetaMod = 8;

		public int r {
				get {
						return relativeR;
				}
		}

		public int theta {
				get {
						return relativeTheta;
				}
		}

		public bool IsBusy {
				get {
						return mSegment.IsBusy;
				}
		}

		public RelativeDiskSegment (AbsDiskSegment adaptee)
		{
				mSegment = adaptee;
				relativeR = mSegment.r;
				relativeTheta = mSegment.theta;
		}

		public void Rotate (float angle, float time)
		{
				//a temporary approach
				if (angle > 0)
						relativeTheta ++;
				else if (angle < 0)
						relativeTheta --;
				else
						Debug.LogError ("zero angle!!?");

				if (relativeTheta > ThetaMod)
						relativeTheta = 1;
				else if (relativeR < 1)
						relativeTheta = ThetaMod;
		 
				//Debug.Log("relativeTheta: " + relativeTheta);
				mSegment.Rotate (angle, time);
		}

		public void Reflect (float AxesAngle, float time, int isConjugate)
		{
				float axesAngle = 360.0f / (float)ThetaMod;

				axesAngle *= (float)relativeTheta;
				relativeTheta = DiskUtility.GetConjugateTheta (relativeTheta, ThetaMod);
				mSegment.DoReflect (axesAngle, time, relativeTheta,isConjugate);
		}
	
}

