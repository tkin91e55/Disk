using UnityEngine;

namespace UnityTest
{
	public class SpaceshipMotor : MonoBehaviour, IMovementController, IGunController
	{
		public LaserBullet Bullet;
		public GameObject GunMuzzle;
		public SpaceshipController controller;

		private void OnEnable ()
		{
			controller.SetMovementController (this);
			controller.SetGunController (this);
		}

		private void FixedUpdate ()
		{
			if (Input.GetButton ("Horizontal")) 
				controller.MoveHorizontaly (Input.GetAxis ("Horizontal"));
			if (Input.GetButton ("Vertical")) 
				controller.MoveVerticaly (Input.GetAxis ("Vertical"));
			if (Input.GetButton ("Fire1")) 
				controller.ApplyFire ();
			if (Input.GetButton ("Fire2")) 
				controller.ApplyReload ();
		}

		#region IMovementController implementation

		public void MoveHorizontaly (float value)
		{
			float deltaX = Time.fixedDeltaTime * value;
			this.transform.Translate (deltaX, 0, 0);
		}

		public void MoveVerticaly (float value)
		{
			float deltaY = Time.fixedDeltaTime * value;
			this.transform.Translate (0, deltaY, 0);
		}

		#endregion

		#region IGunController implementation

		public void Fire ()
		{
			var bullet = Instantiate (Bullet, GunMuzzle.transform.position, 
				Quaternion.identity) as LaserBullet;
			bullet.transform.parent = this.transform.parent;
		}

		#endregion

		#region GUI visualizer

		public void OnGUI ()
		{
			controller.health = GUI.HorizontalSlider (new Rect (80, 5, 100, 10), controller.health, 0, 100);
			var text = "HEALTH: " + (int) controller.health + "\n";
			text += "BULLETS LEFT: " + (controller.bulletsLeft > 0 ? "" + controller.bulletsLeft : "RELOAD! (right mouse btn)");
			GUILayout.Label (text);
		}

		#endregion
	}
}
