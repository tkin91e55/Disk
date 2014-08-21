using UnityEngine;
using System.Collections;

public interface ICommand {
	void Execute ();
	bool CanExecute ();
}

public abstract class DiskCmd : ICommand {
	
	protected IDiskSegment receiver;
	
	public DiskCmd (IDiskSegment aDiskSeg) {
		receiver = aDiskSeg;
	}

	public virtual void Execute () {
	}

	public bool CanExecute () {
		return true;
	}

	public virtual void Undo() {
	}
}

public class DiskRotateCmd : DiskCmd {

	float rotateAngle = 45.0f;
	float rotateTime = 1.3f;

	public DiskRotateCmd (AbsDiskSegment aDiskSeg) : base(aDiskSeg) {
	}

	public DiskRotateCmd (AbsDiskSegment aDiskSeg, float angle, float rotateTime):base(aDiskSeg) {
		rotateAngle = angle;
		rotateTime = rotateTime;
	}

	public override void Execute () {
		if (receiver != null){
			receiver.Rotate( rotateAngle,rotateTime );
		}
	}

	public override void Undo () {
		if ( receiver != null) {
			receiver.Rotate( -rotateAngle,rotateTime );
		}
	}
}
