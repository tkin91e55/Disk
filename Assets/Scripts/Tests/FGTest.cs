using UnityEngine;
using System.Collections;

public class FGTest : MonoBehaviour {

	public GameObject theDisk;
	private GameObject[] theSegments;

	void Start() {

		Transform[] tempSegs = theDisk.GetComponent<operation> ().mSegments;
		theSegments = new GameObject[tempSegs.Length];
		for (int i = 0; i< tempSegs.Length; i++) {
			theSegments[i] = tempSegs[i].gameObject;
			//Debug.Log(theSegments[i].name);
				}
		}

	void OnTap () {

		Debug.Log ("OnTap() is called");
	}
}
