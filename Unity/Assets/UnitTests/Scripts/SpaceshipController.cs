using System;
using UnityEngine;

namespace UnityTest
{
	[Serializable]
	public class SpaceshipController
	{
		public float normalSpeed = 15f;
		public float woundedSpeed = 3f;
		public float shootRate = 0.5f;
		public int bulletCapacity = 5;

		[Range (0, 100)]
		public float health = 100f;
		public int bulletsLeft = 5;

		private IMovementController movementController;
		private IGunController gunController;

		private float lastFireTime = float.NegativeInfinity;

		public void MoveHorizontaly (float value)
		{
			movementController.MoveHorizontaly (value * GetSpeed ());
		}

		public void MoveVerticaly ( float value )
		{
			movementController.MoveVerticaly (value * GetSpeed ());
		}

		float GetSpeed ()
		{
			return health >= 50 ? normalSpeed : woundedSpeed;
		}

		public void ApplyFire ()
		{
			if (bulletsLeft > 0 &&  CanFire ())
			{
				lastFireTime = Time.time;
				bulletsLeft--;
				gunController.Fire ();
			}
		}

		public void ApplyReload ()
		{
			bulletsLeft = bulletCapacity;
		}

		virtual public bool CanFire ()
		{
			return (lastFireTime + shootRate) < Time.time;
		}

		public void SetMovementController ( IMovementController movementController )
		{
			this.movementController = movementController;
		}

		public void SetGunController ( IGunController gunController )
		{
			this.gunController = gunController;
		}
	}
}
