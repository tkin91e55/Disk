using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public static class Utility  {

	/// <summary>
	/// useful for assets prefab's operation, since prefab is not identical to gameobject in scene
	/// </summary>
	/// <param name="aParent">A parent.</param>
	/// <param name="aList">A list.</param>
	public static void RecursiveGetChildren (Transform aParent, List<Transform> aList)
	{ //including add the transform itself
		
		aList.Add (aParent);
		if (aParent.childCount == 0) {
			return;
		}		
		for (int i=0; i<aParent.childCount; i++) {
			RecursiveGetChildren (aParent.GetChild (i), aList);
		}
	}

	public static void SetAsChild (GameObject parent, GameObject go) {

		go.transform.parent = parent.transform;
	}
}
