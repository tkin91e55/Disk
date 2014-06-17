using UnityEngine;

public class SpaceshipMotor1 : MonoBehaviour
{
	public LaserBullet Bullet;
	public GameObject GunMuzzle;

	private const int bulletCapacity = 5;
	private const float normalSpeed = 15f;
	private const float shootRate = 0.5f;
	private const float woundedSpeed = 3f;

	private int bulletsLeft = 5;
	private float health = 100f;

	private float lastFireTime = float.NegativeInfinity;

	private void FixedUpdate ()
	{
		if (Input.GetButton ("Horizontal"))
		{
			float deltaX = Time.fixedDeltaTime * Input.GetAxis ("Horizontal") 
				* (health >= 50 ? normalSpeed : woundedSpeed);
			transform.Translate (deltaX, 0, 0);
		}
		if (Input.GetButton ("Vertical"))
		{
			float deltaY = Time.fixedDeltaTime * Input.GetAxis ("Vertical") 
				* (health >= 50 ? normalSpeed : woundedSpeed);
			transform.Translate (0, deltaY, 0);
		}
		if (Input.GetButton ("Fire1"))
		{
			if (bulletsLeft > 0 && (lastFireTime + shootRate) < Time.time)
			{
				lastFireTime = Time.time;
				bulletsLeft--;

				var bullet = Instantiate (Bullet, GunMuzzle.transform.position, 
					Quaternion.identity) as LaserBullet;
				bullet.transform.parent = this.transform.parent;
			}
		}
		if (Input.GetButton ("Fire2"))
		{
			bulletsLeft = bulletCapacity;
		}
	}
}
