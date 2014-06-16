using UnityEngine;
using System.Collections;

public class testSounds : MonoBehaviour {


	//(1)do itween synchroization with sound play

	//(2)may need to device state machine

	//(Everything is public and serialized for convenience of debugging

	// Use this for initialization

	public soundContainer mContainer;
	void Start () {

		mContainer = new soundContainer ();
		Debug.Log ("the length is: "+audio.clip.length);
		audio.Play ();

	}

	float fraction = 0;
	void Update () {
		}

	bool moved = false;
	void OnGUI () {

			fraction = GUI.HorizontalSlider(new Rect(25, 25, 100, 30), fraction, 0.0F, 1.0F);
			if (audio.time > 0)
			{
				fraction = audio.time/audio.clip.length;
			Debug.Log("Time: " + Time.time);
			}

#if true 
		//it seems iTween has its own way to speed?
		if (!moved) {
						//iTween.MoveAdd (transform.gameObject, Vector3.forward, audio.clip.length);
			iTween.MoveAdd (transform.gameObject,iTween.Hash("time",audio.clip.length,"amount",Vector3.forward,"easetype",iTween.EaseType.linear));
			moved = true;
				}
#endif

		}

	public class soundContainer {

		public AudioClip Origin;

		public soundContainer () {

			Origin = (AudioClip) Resources.LoadAssetAtPath("Assets/Resources/Sounds/grinder.mp3",typeof(AudioClip));
		}

		public void stateIndicator () {

			//AudioSource.PlayClipAtPoint(Origin,Vector3.zero);

		}
	}

}
