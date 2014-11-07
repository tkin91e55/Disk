using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;

public interface ICommand
{
		void Execute ();

		bool CanExecute ();
}

public interface IObserver
{
		void OnUpdate (IObservable sender, object eventArg);
}

public interface IObservable
{
		void Subscribe (IObserver obsvr);

		void Unsubscribe (IObserver obsvr);

		void Notify ();
}

public abstract class DiskCmd : ICommand
{
	
		protected IDiskSegment receiver;
	
		public DiskCmd (IDiskSegment aDiskSeg)
		{
				receiver = aDiskSeg;
		}

		public virtual void Execute ()
		{
		}

		public bool CanExecute ()
		{
				return !receiver.IsBusy;
		}

		public virtual void Undo ()
		{
		}

		public virtual void SetVerificationCondition (int condition)
		{
				Debug.Log ("diskcmd base SetVerify() called");
		}

		public virtual bool Verify ()
		{
				Debug.Log ("diskcmd base Verify() called");
				return false;
		}
}

public abstract class DiskMacroCmd : ICommand
{
		protected ArrayList mReceivers;
		protected List<DiskCmd> cmdGroup = new List<DiskCmd> ();

		public DiskMacroCmd (ArrayList receivers)
		{
				mReceivers = receivers;
		}

		public virtual void Execute ()
		{

				if (cmdGroup != null) {
						foreach (DiskCmd cmd in cmdGroup) {
								if (cmd.CanExecute ())
										cmd.Execute ();
						}
				}
		}

		public bool CanExecute ()
		{
				bool isAllIdle = true;

				foreach (object receiver in mReceivers) {
						string tempName = typeof(IDiskSegment).ToString ();
						if (receiver.GetType ().GetInterface (tempName) != null) {
								IDiskSegment tempSeg = (IDiskSegment)receiver;
								if (tempSeg.IsBusy)
										isAllIdle = false;
						}
				}
				return isAllIdle;
		}

		public virtual void Undo ()
		{
				if (cmdGroup != null) {
						foreach (DiskCmd cmd in cmdGroup) {
								if (cmd.CanExecute ())
										cmd.Undo ();
						}
				}
		}

		public virtual void SetVerificationCondition (int cond)
		{
				foreach (DiskCmd cmd in cmdGroup) {
						cmd.SetVerificationCondition (cond);
				}
		}

		public virtual bool Verify ()
		{
				bool verified = true;

				foreach (DiskCmd cmd in cmdGroup) {
						if (!cmd.Verify ()) {
								Debug.Log ("fail to verify");
								verified = false;
						}
				}

				return verified;
		}
}

public class DiskRotateCmd : DiskCmd
{
		float rotateAngle = 45.0f;
		float rotateTime = 1.3f;
		int securityR = -1;

		public DiskRotateCmd (IDiskSegment aDiskSeg) : base(aDiskSeg)
		{
		}

		public DiskRotateCmd (IDiskSegment aDiskSeg, float angle, float rotateTime):base(aDiskSeg)
		{
				rotateAngle = angle;
				rotateTime = rotateTime;
		}

		public override void Execute ()
		{
				if (receiver != null && CanExecute ()) {
						receiver.Rotate (rotateAngle, rotateTime);
				}
		}

		public override void Undo ()
		{
				if (receiver != null && CanExecute ()) {
						receiver.Rotate (-1.0f * rotateAngle, rotateTime);
				}
		}

		public override void SetVerificationCondition (int condition)
		{
				Debug.Log ("diskcmd high SetVerify() called");
				securityR = condition;
		}

		public override bool Verify ()
		{
				return (securityR == receiver.r);
		}
}

public class DiskReflectCmd : DiskCmd
{
	
		float reflectTime = 2.0f;
		int isConjugate = -1;
		int securityTheta = -1; //suppose securityTheta already considered conjugate theta

		public DiskReflectCmd (IDiskSegment aDiskSeg) : base(aDiskSeg)
		{
		}

		public DiskReflectCmd (IDiskSegment aDiskSeg, float arotateTime):base(aDiskSeg)
		{
				reflectTime = arotateTime;
		}

		public DiskReflectCmd (IDiskSegment aDiskSeg, int isconjugate):base(aDiskSeg)
		{
				isConjugate = isconjugate;
		}

		public override void Execute ()
		{
				if (receiver != null && CanExecute ()) {
						receiver.Reflect (0.0f, reflectTime, isConjugate);
				}
		}

		public override void Undo ()
		{
				if (receiver != null && CanExecute ()) {
						receiver.Reflect (0.0f, reflectTime, -1 * isConjugate);
				}
		}

		public override void SetVerificationCondition (int condition)
		{
				Debug.Log ("diskcmd high SetVerify() called");
				securityTheta = condition;
		}

		public override bool Verify ()
		{
				if (securityTheta != receiver.theta)
						Debug.LogError ("Verification failed");

				return (securityTheta == receiver.theta);
		}

}

public class MacroDiskRotateCmd : DiskMacroCmd
{

		AudioClip sound;
		Transform trans;

		public MacroDiskRotateCmd (ArrayList receivers, AudioClip aSound, Transform atrans) : base(receivers)
		{

				sound = aSound;
				trans = atrans;

				foreach (object obj in receivers) {
						string temp = typeof(IDiskSegment).ToString ();
						if (obj.GetType ().GetInterface (temp) != null) {
								cmdGroup.Add (new DiskRotateCmd ((IDiskSegment)obj));
						}
				}
		}

		public override void Execute ()
		{
				base.Execute ();
				if (sound != null)
						AudioSource.PlayClipAtPoint (sound, trans.position);
		}

		public override void Undo ()
		{
				base.Undo ();
				if (sound != null)
						AudioSource.PlayClipAtPoint (sound, trans.position);
		}

}

public class MacroDiskReflectCmd : DiskMacroCmd
{
	
		public MacroDiskReflectCmd (ArrayList receivers) : base(receivers)
		{	
				foreach (object obj in receivers) {
						string temp = typeof(IDiskSegment).ToString ();
						if (obj.GetType ().GetInterface (temp) != null) {
								cmdGroup.Add (new DiskReflectCmd ((IDiskSegment)obj));
						}
				}
		}

		public void AddConjugate (ArrayList receivers)
		{
				foreach (object obj in receivers) {
						string temp = typeof(IDiskSegment).ToString ();
						if (obj.GetType ().GetInterface (temp) != null) {
								DiskReflectCmd reflectCmd = new DiskReflectCmd ((IDiskSegment)obj, 1);
								cmdGroup.Add (reflectCmd);
						}
				}
		}

		public void AddConjugate (ArrayList receivers, int conjugateIndex)
		{
				foreach (object obj in receivers) {
						string temp = typeof(IDiskSegment).ToString ();
						if (obj.GetType ().GetInterface (temp) != null) {
								DiskReflectCmd reflectCmd = new DiskReflectCmd ((IDiskSegment)obj, 1);
								reflectCmd.SetVerificationCondition (conjugateIndex);
								cmdGroup.Add (reflectCmd);
						}
				}
		}

		public override void Execute ()
		{
				base.Execute ();
		}
	
		public override void Undo ()
		{
				base.Undo ();
		}
}
