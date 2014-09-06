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
}

public abstract class DiskMacroCmd : ICommand {

	protected ArrayList mReceivers;
	protected List<DiskCmd> cmdGroup = new List<DiskCmd>();

	public DiskMacroCmd (ArrayList receivers)  {
		
		mReceivers = receivers;
	}

	public virtual void Execute () {

		if (cmdGroup != null){
			foreach ( DiskCmd cmd in cmdGroup){
				if(cmd.CanExecute())
					cmd.Execute();
			}
		}
	}

	public bool CanExecute(){
		bool isAllIdle = true;

		foreach(object receiver in mReceivers){
			string tempName = typeof(IDiskSegment).ToString();
			if(receiver.GetType().GetInterface(tempName) != null){
				IDiskSegment tempSeg = (IDiskSegment) receiver;
				if(tempSeg.IsBusy)
					isAllIdle = false;
			}
		}

		return isAllIdle;
	}

	public virtual void Undo(){
	}
}

public class DiskRotateCmd : DiskCmd
{

		float rotateAngle = 45.0f;
		float rotateTime = 1.3f;

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
}

public class MacroDiskRotateCmd : DiskMacroCmd {

	AudioClip sound;
	Transform trans;

	public MacroDiskRotateCmd (ArrayList receivers, AudioClip aSound, Transform atrans) : base(receivers) {

		sound = aSound;
		trans = atrans;

		foreach (object obj in receivers){
			string temp = typeof(IDiskSegment).ToString();
			if(obj.GetType().GetInterface(temp) != null){
				cmdGroup.Add(new DiskRotateCmd((IDiskSegment)obj));
			}
		}
	}

	public override void Execute ()
	{
		base.Execute();
		if (sound != null)
			AudioSource.PlayClipAtPoint (sound, trans.position);

	}

}
