using UnityEngine;

public class SpaceshipMotor2 : MonoBehaviour
{
	public LaserBullet Bullet;
	public GameObject GunMuzzle;

	private int bulletCapacity = 5;

	private int bulletsLeft = 5;
	private float health = 100f;

	private float lastFireTime = float.NegativeInfinity;
	private float normalSpeed = 15f;
	private float shootRate = 0.5f;
	private float woundedSpeed = 3f;

	private void FixedUpdate ()
	{
		if (Input.GetButton ("Horizontal")) 
			MoveHorizontaly (Input.GetAxis ("Horizontal"));
		if (Input.GetButton ("Vertical")) 
			MoveVerticaly (Input.GetAxis ("Vertical"));
		if (Input.GetButton ("Fire1")) 
			Fire ();
		if (Input.GetButton ("Fire2")) 
			Reload ();
	}

	private void MoveHorizontaly (float value)
	{
		float deltaX = Time.fixedDeltaTime * value 
			* (health >= 50 ? normalSpeed : woundedSpeed);
		TransformPosition (deltaX, 0f);
	}

	private void MoveVerticaly ( float value )
	{
		float deltaY = Time.fixedDeltaTime * value 
			* (health >= 50 ? normalSpeed : woundedSpeed);
		TransformPosition (0f, deltaY);
	}

	private void TransformPosition ( float deltaX, float deltaY )
	{
		transform.Translate (deltaX, deltaY, 0);
	}

	private void Fire ()
	{
		if (bulletsLeft > 0 && CanFire ())
		{
			lastFireTime = Time.time;
			bulletsLeft--;
			InstanciateBullet ();
		}
	}

	private bool CanFire ()
	{
		return (lastFireTime + shootRate) < Time.time;
	}

	private void InstanciateBullet ()
	{
		var bullet = Instantiate (Bullet, GunMuzzle.transform.position, 
			Quaternion.identity) as LaserBullet;
		bullet.transform.parent = this.transform.parent;
	}

	private void Reload ()
	{
		bulletsLeft = bulletCapacity;
	}
}
