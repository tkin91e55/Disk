using UnityEngine;
using System.Collections;

public class operation : MonoBehaviour {

	//transform of a segment
	public Transform[] mSegments;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}

public class Disk{


}

public class DiskSegment {

	Transform mTransform;
	Vector2 mCoordinate; //(r,theta)

	public DiskSegment (Transform aTrans, Vector2 aCoor){

		if (aTrans != null)
			mTransform = aTrans;
		else
			Debug.LogException(
	}
}
