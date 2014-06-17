using UnityEngine;

public class LaserBullet : MonoBehaviour 
{

	float Range = 20;
	float Speed = 10;

	void Update () {
		float deltaY = Speed * Time.deltaTime;
		this.transform.Translate (0, deltaY, 0);
		if (this.transform.position.y > Range) Destroy (this.gameObject);
	}
}
