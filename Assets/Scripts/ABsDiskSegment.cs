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

	enum SegState {
		idle=0,
		busy=1
	} 

	SegState mState = SegState.idle;

	public bool IsBusy{
		get{
			switch (mState){
			case AbsDiskSegment.SegState.idle:
				return false;
				break;
			case AbsDiskSegment.SegState.busy:
				return true;
				break;
			default:
				Debug.LogError("strange case for absSeg state");
				return true;
				break;
			}
		}
	}

	public void Rotate (float angle, float time)
	{
		mState = SegState.busy;
		iTween.RotateAdd (gameObject, iTween.Hash ("time", time, "amount", angle * Vector3.up, "easetype", iTween.EaseType.easeInQuad,"oncomplete","OnCompleteOperation"));
	}
	
	public void Reflect () {
	}
	
	void OnCompleteOperation () {

		//PublishRotateComplete ();
		mState = SegState.idle;
	}


	//rotation is a command, should not be delcared like this, it is going to be parallet to reflection
	/*event EventHandler PostRotateEvent;

	System.Object objectLock = new System.Object();

	event EventHandler IRotatableSegment.OnRotateFinish{

		add
		{
			lock (objectLock)
			{
				PostRotateEvent += value;
			}
		}
		remove
		{
			lock (objectLock)
			{
				PostRotateEvent -= value;
			}
		}

	}

	void PublishRotateComplete () {

		EventHandler handler = PostRotateEvent;
		Debug.Log("PublishRotateComplete() called");

		if (handler != null)
		{
			Debug.Log("has some event published");
			handler(this, new EventArgs());
		}

	}*/

}

public class RelativeDiskSegment : IDiskSegment {

	AbsDiskSegment mSegment;

	int relativeR;
	int relativeTheta;
	static int Rmod=3;
	static int ThetaMod=8;

	public int r {
		get{
			return relativeR;
		}
	}

	public int theta {
		get{
			return relativeTheta;
		}
	}

	public bool IsBusy {

		get{
			return mSegment.IsBusy;
		}
	}

	public RelativeDiskSegment (AbsDiskSegment adaptee) {
		mSegment = adaptee;
		relativeR = mSegment.r;
		relativeTheta = mSegment.theta;
	}

	public void Rotate (float angle, float time){

		//a temporary approach
		if (angle > 0)
			relativeR ++;
		else if (angle < 0)
			relativeR --;
		else
			Debug.LogError("zero angle!!?");

		if(relativeR > Rmod)
			relativeR = 1;
		else if (relativeR < 1)
			relativeR = Rmod;

		Debug.Log("relativeR: " + relativeR);
		mSegment.Rotate(angle,time);
	}

}

