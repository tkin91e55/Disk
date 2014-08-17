using UnityEngine;
using System.Collections;
using System;

//this class need to inherit from monobehaviour and becomes an individual script to make itween callbacks work
public class AbsDiskSegment: MonoBehaviour, IDiskSegment, IRotatableSegment
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

	public void Rotate (float angle, float time)
	{
		//mTransform.Rotate (new Vector3 (0, 45, 0));
		//iTween.RotateAdd (this.mTransform.gameObject, iTween.Hash ("time", time, "amount", 45 * Vector3.up, "easetype", iTween.EaseType.easeInQuad,"oncomplete","OnCompleteOperation","oncompletetarget",gameObject));
		//this doesn't work for the callback
		iTween.RotateAdd (gameObject, iTween.Hash ("time", time, "amount", 45 * Vector3.up, "easetype", iTween.EaseType.easeInQuad,"oncomplete","OnCompleteOperation"));
		//iTween.MoveAdd (transform.gameObject,iTween.Hash("time",audio.clip.length,"amount",Vector3.forward,"easetype",iTween.EaseType.linear));
	}
	
	public void Reflect () {
	}
	
	void OnCompleteOperation () {
		
		//Debug.Log("itween callback");
		PublishRotateComplete ();
		Debug.Log("onCompleteOperation() called");
		
	}


	//rotation is a command, should not be delcared like this, it is going to be parallet to reflection
	event EventHandler PostRotateEvent;

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

	}

}

