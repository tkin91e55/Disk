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

	//temporary
	DiskSegment[] mSegments;
	const int thetaModolus = 8; //this is not flexible
	const int radiusModolus = 3; //this is not flexible

	public Disk (Transform[] segments){//

		for (int i = 0; i < segments.Length; i++) {

			for (int r = 1 ; r <= radiusModolus; r++){

				for (int theta = 1; theta <= thetaModolus; theta++)
				mSegments[i] = new DiskSegment(segments[i],new Vector2(r,theta));

			}

				}

		}

}

public class DiskSegment {

	Transform mTransform;
	Vector2 mCoordinate; //(r,theta)

	public DiskSegment (Transform aTrans, Vector2 aCoor){

		if (aTrans != null)
			mTransform = aTrans;
		else
			Debug.Log ("null diskSegment Trans init");

		if (aCoor != null)
			mCoordinate = aCoor;
		else
			Debug.Log ("null diskSegment Coor init");
	}
}
