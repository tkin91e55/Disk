﻿using UnityEngine;
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

		public void Rotate (float angle, float time)
		{
				mState = SegState.Busy;
				iTween.RotateAdd (gameObject, iTween.Hash ("time", time, "amount", angle * Vector3.up, "easetype", iTween.EaseType.easeInQuad, "oncomplete", "OnCompleteOperation"));
		}
	
		public void Reflect ()
		{
				mState = SegState.Busy;
				GameObject reflectAxes = new GameObject ();
				GOpair pair = new GOpair (reflectAxes, this.gameObject);

				reflectAxes.name = "reflectAxes";
				reflectAxes.transform.RotateAround (transform.position, Vector3.up, 45.0f);

				GameObject theAxes = GameObject.Find ("reflectAxes");

				Utility.SetAsChild (gameObject.transform.parent.gameObject, theAxes);
				Utility.SetAsChild (theAxes, gameObject);

				Vector3 direc = reflectAxes.transform.TransformDirection (reflectAxes.transform.forward);
				Vector3 direc2 = transform.TransformDirection (transform.right);
				iTween.RotateAdd (theAxes, iTween.Hash ("time", 2.0f, "amount", -180.0f * direc, "easetype", iTween.EaseType.linear));
				iTween.RotateAdd (gameObject, iTween.Hash ("time", 2.0f, "amount", 180.0f * direc2, "easetype", iTween.EaseType.linear, "oncomplete", "OnCompleteOperation", "oncompleteparams", pair));

		}

		void OnCompleteOperation (GOpair pair)
		{
				Utility.SetAsChild (pair.axes.transform.parent.gameObject, pair.go);
				Destroy (pair.axes);

				OnCompleteOperation ();
		}

		void OnCompleteOperation ()
		{
				mState = SegState.Idle;
		}

		class GOpair
		{
				public GameObject axes;
				public GameObject go;

				public GOpair (GameObject aAxes, GameObject aGo)
				{
						axes = aAxes;
						go = aGo;
				}
		}

}

public class RelativeDiskSegment : IDiskSegment
{

		AbsDiskSegment mSegment;
		int relativeR;
		int relativeTheta;
		static int Rmod = 3;
		static int ThetaMod = 8;

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

		public void Relfect ()
		{
				//if(relativeTheta == 1 || relativeTheta == 5 )
				//mSegment.Reflect();
		}

}
