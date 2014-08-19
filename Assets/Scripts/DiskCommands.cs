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
}

public class DiskRotateCmd : DiskCmd {

	public DiskRotateCmd (AbsDiskSegment aDiskSeg) : base(aDiskSeg) {
	}

	public override void Execute () {

		if (receiver != null){
			receiver.Rotate( 45.0f,1.3f );
		}
	}
}
