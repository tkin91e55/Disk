using UnityEngine;
using System.Collections;

public class FGTest : MonoBehaviour {

	public GameObject theDisk;
	private GameObject[] theSegments;
	FingerUpDetector FUD;
	TapRecognizer TRZ;

	void Start() {

		Transform[] tempSegs = theDisk.GetComponent<DiskController> ().mSegments;
		theSegments = new GameObject[tempSegs.Length];
		for (int i = 0; i< tempSegs.Length; i++) {
			theSegments[i] = tempSegs[i].gameObject;
			//Debug.Log(theSegments[i].name);
				}

		FUD = GetComponent<FingerUpDetector> ();

		TRZ = GetComponent<TapRecognizer> ();

		TRZ.OnGesture += SayHello;
		}

	void OnTap () {

#if false
		GameObject hitObject = gesture.Selection;
		
		if( hitObject )
		{
			Vector3 hitPos3d = gesture.Raycast.Hit3D.point;
			Vector3 hitNormal = gesture.Raycast.Hit3D.normal;
			Debug.Log( "Tapped on " + hitObject + " @ " + hitPos3d );
		}
#endif
	}

	void OnFingerUpUp( FingerUpEvent e )
	{
		// time the finger has been held down before being released
		float elapsedTime = e.TimeHeldDown;
		Debug.Log ("elapsedTime: " + elapsedTime);
	}

	void SayHello (TapGesture  gesture) {
		//Debug.Log ("HelloWorld");
	}
}
