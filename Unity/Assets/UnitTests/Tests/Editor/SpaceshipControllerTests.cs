using NSubstitute;
using NUnit.Framework;

namespace UnityTest
{
	public class SpaceshipControllerTests
	{
		[Test]
		public void SingleFireWorks ()
		{
			var gunController = GetGunMock ();
			var motor = GetControllerMock (gunController);

			motor.ApplyFire ();

			gunController.Received (1).Fire ();
		}

		[Test]
		public void MultipleFireWorks ()
		{
			var gunController = GetGunMock ();
			var motor = GetControllerMock (gunController);

			motor.ApplyFire ();
			motor.ApplyFire ();
			motor.ApplyFire ();

			gunController.Received (3).Fire ();
		}

		[Test]
		public void CanNotFireWithNotBullets ()
		{
			var gunController = GetGunMock ();
			var motor = GetControllerMock (gunController);
			motor.bulletsLeft = 0;

			gunController.ClearReceivedCalls ();
			motor.ApplyFire ();

			gunController.DidNotReceive ().Fire ();
		}

		[Test]
		public void ReloadWorks ()
		{
			var gunController = GetGunMock ();
			var motor = GetControllerMock (gunController);
			motor.bulletsLeft = 0;

			motor.ApplyReload ();
			Assert.That (motor.bulletsLeft, Is.Not.EqualTo (0));
		}

		[Test]
		public void CanShootAfterReload ()
		{
			var gunController = GetGunMock ();
			var motor = GetControllerMock (gunController);
			gunController.ClearReceivedCalls ();

			motor.ApplyReload ();
			Assert.That (motor.bulletsLeft, Is.Not.EqualTo (0));
			motor.ApplyFire ();

			gunController.Received (1).Fire ();
		}

		[Test]
		public void SpeedAtFullHealth ()
		{
			var mov = GetMovementMock ();
			var motor = GetControllerMock (mov);

			motor.MoveHorizontaly (1f);

			mov.Received (1).MoveHorizontaly (motor.normalSpeed);
		}

		[Test]
		public void SpeedAtLowHealth ()
		{
			var mov = GetMovementMock ();
			var motor = GetControllerMock (mov);
			motor.health = 10;

			motor.MoveHorizontaly(1f);

			mov.Received (1).MoveHorizontaly (motor.woundedSpeed);
		}

		private IMovementController GetMovementMock ()
		{
			return Substitute.For<IMovementController> ();
		}

		private SpaceshipController GetControllerMock ( IMovementController movController )
		{
			var motor = Substitute.For<SpaceshipController> ();
			motor.SetMovementController (movController);
			return motor;
		}

		private IGunController GetGunMock ()
		{
			return Substitute.For<IGunController> ();
		}

		private SpaceshipController GetControllerMock ( IGunController gunController )
		{
			var motor = Substitute.For<SpaceshipController> ();
			motor.CanFire ().Returns (true);
			motor.SetGunController (gunController);
			return motor;
		}
	}
}
