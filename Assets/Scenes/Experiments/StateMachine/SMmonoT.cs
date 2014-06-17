using UnityEngine;
using System.Collections;

public class SMmonoT : MonoBehaviour {

	//state machine monobehavior test

	public enum State {
		MoveUp,
		MoveDown,
		MoveLeft,
		MoveRight
	}

	Util.Mode<SMmonoT,State> mMode; //this state machine has a limitation that callback fucntion limited to void()

	void Start () {

		mMode = new Util.Mode<SMmonoT, State>(this);
		mMode.Set (State.MoveUp);
	}

	void Update()
	{
		mMode.Proc();
	}

	float Move_counter;
	void MoveUp_Init () {
		Move_counter = 0f;
	}

	void MoveUp_Proc () {

		Move_counter += Time.deltaTime;
		transform.Translate (Vector3.up*Time.deltaTime * 10.0f);

		//by switch to see the usage:
#if true 
		if (Move_counter > 1){
			mMode.Term(); //it will call mMode.mCurr 's Term() and then call mMode.mCurr's init() to start over
		}
#endif

		if (Move_counter > 2)
						mMode.Set (State.MoveDown);
	}

	void MoveUp_Term () {

		Debug.Log ("MoveUp_Term() is called");
		mMode.Set (State.MoveDown);
		}

	void MoveDown_Proc () {

		Move_counter += Time.deltaTime;
		transform.Translate (Vector3.down*Time.deltaTime * 10.0f);
		if (Move_counter > 4)
			mMode.Set (State.MoveUp);
	}

	void MoveDown_Term () {
		
		Debug.Log ("MoveDown_Term() is called");
	}
}
