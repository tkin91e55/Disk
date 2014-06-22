using UnityEngine;
using System.Collections;

public interface IDiskController {
}

public interface IDisk {

	void RotateAtR (int r, Transform soundSource);
	void ReflectAtTheta (int theta, Transform soundSource);
}

public interface IDiskSegment {

	int r{get;}
	int theta{get;}
	void Rotate (float angle, float time);
}

