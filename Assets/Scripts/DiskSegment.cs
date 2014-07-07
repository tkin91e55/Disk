using UnityEngine;
using System.Collections;

//this class need to inherit from monobehaviour and becomes an individual script to make itween callbacks work
public class DiskSegment: MonoBehaviour, IDiskSegment
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
		
	}
}

