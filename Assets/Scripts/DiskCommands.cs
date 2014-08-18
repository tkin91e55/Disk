﻿using UnityEngine;
using System.Collections;

public abstract class DiskCmd : ICommand {
	
	protected AbsDiskSegment receiver;
	
	public DiskCmd (AbsDiskSegment aDiskSeg) {
		Debug.Log("DiskCmd constructor");
		receiver = aDiskSeg;
	}

	public virtual void Execute () {

		Debug.Log("DiskCmd.Exceture() called");
	}

	public bool CanExecute () {

		return true;
	}
}

public class DiskRotateCmd : DiskCmd {

	public DiskRotateCmd (AbsDiskSegment aDiskSeg) : base(aDiskSeg) {
		Debug.Log("DiskRotateCmd constructor");
	}

	public override void Execute () {

		if (receiver != null){
			Debug.Log("not null");
			receiver.Rotate( 45.0f,1.3f );
		}
	}
}
