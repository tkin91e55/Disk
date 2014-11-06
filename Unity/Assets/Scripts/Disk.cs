using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Disk : MonoBehaviour
{
	
		public GameObject theDiskPrefab;
		AbsDiskSegment[] mSegments;
		RelativeDiskSegment[] mRelativeSegments;
		DiskController diskController = new DiskController ();
		//MacroDiskRotateCmd mRcmd;
		public AudioClip rotateSound;
	
		void Start ()
		{
				diskController.Start ();
				GameObject theGO = (GameObject)Instantiate (theDiskPrefab, Vector3.zero, Quaternion.identity);
				Utility.SetAsChild (gameObject, theGO);

				mSegments = theGO.GetComponentsInChildren<AbsDiskSegment> ();
				mRelativeSegments = new RelativeDiskSegment[mSegments.Length];
				for (int i = 0; i < mRelativeSegments.Length; i++) {
						mRelativeSegments [i] = new RelativeDiskSegment (mSegments [i]);
				}
		}

		void Update ()
		{
				diskController.Update ();
		}

		void OnGUI ()
		{
				if (GUI.Button (new Rect (0, 0, Screen.width / 8, Screen.height / 15), "Rotate inner")) {
						RotateInnerSeg ();
				}
				if (GUI.Button (new Rect (0, Screen.height / 15, Screen.width / 8, Screen.height / 15), "Rotate Middle")) {
						RotateMiddleSeg ();
				}
				if (GUI.Button (new Rect (0, 2 * Screen.height / 15, Screen.width / 8, Screen.height / 15), "Rotate outer")) {
						RotateOuterSeg ();
				}
				if (GUI.Button (new Rect (0, 3 * Screen.height / 15, Screen.width / 8, Screen.height / 15), "Undo")) {
						Undo ();
				}
				if (GUI.Button (new Rect (0, 4 * Screen.height / 15, Screen.width / 8, Screen.height / 15), "Redo")) {
						Redo ();
				}
				if (GUI.Button (new Rect (0, 8 * Screen.height / 15, Screen.width / 8, Screen.height / 15), "Clear")) {
						diskController.CancelBufferCmd ();
				}
				if (GUI.Button (new Rect (Screen.width - Screen.width / 8, 0, Screen.width / 8, Screen.height / 15), "Reflect 1")) {
						SetReflection (1);
				}
				if (GUI.Button (new Rect (Screen.width - Screen.width / 8, Screen.height / 15, Screen.width / 8, Screen.height / 15), "Reflect 2")) {
						SetReflection (2);
				}
				if (GUI.Button (new Rect (Screen.width - Screen.width / 8, 2 * Screen.height / 15, Screen.width / 8, Screen.height / 15), "Reflect 3")) {
						SetReflection (3);
				}
				if (GUI.Button (new Rect (Screen.width - Screen.width / 8, 3 * Screen.height / 15, Screen.width / 8, Screen.height / 15), "Reflect 4")) {
						SetReflection (4);
				}
				if (GUI.Button (new Rect (Screen.width - Screen.width / 8, 4 * Screen.height / 15, Screen.width / 8, Screen.height / 15), "Reflect 5")) {
						SetReflection (5);
				}
				if (GUI.Button (new Rect (Screen.width - Screen.width / 8, 5 * Screen.height / 15, Screen.width / 8, Screen.height / 15), "Reflect 6")) {
						SetReflection (6);
				}
				if (GUI.Button (new Rect (Screen.width - Screen.width / 8, 6 * Screen.height / 15, Screen.width / 8, Screen.height / 15), "Reflect 7")) {
						SetReflection (7);
				}
				if (GUI.Button (new Rect (Screen.width - Screen.width / 8, 7 * Screen.height / 15, Screen.width / 8, Screen.height / 15), "Reflect 8")) {
						SetReflection (8);
				}
		}
	
		void RotateInnerSeg ()
		{
				SetRotation (1);
		}

		void RotateMiddleSeg ()
		{
				SetRotation (2);
		}

		void RotateOuterSeg ()
		{
				SetRotation (3);
		}

		void Undo ()
		{
				Debug.Log ("Disk.Undo()");
				diskController.UndoHistory ();
		}

		void Redo ()
		{
				diskController.RedoHistory ();
		}

		/// <summary>
		/// This is very private function
		/// </summary>
		/// <param name="i">The index.</param>
		void SetRotation (int i)
		{
				ArrayList dsList = new ArrayList ();
				foreach (RelativeDiskSegment DS in mRelativeSegments) {
						if (DS.r == i) {
								dsList.Add (DS);
						}
				}
				diskController.AddCmd (new MacroDiskRotateCmd (dsList, rotateSound, transform));
		}

		void SetReflection (int i)
		{
				int conjugateI = DiskUtility.GetConjugateTheta (i, mRelativeSegments [0].ThetaMod);
				MacroDiskReflectCmd macroCMD;

				ArrayList dsList = new ArrayList ();
				ArrayList conDsList = new ArrayList ();
				foreach (RelativeDiskSegment DS in mRelativeSegments) {
						if (DS.theta == i) {
								dsList.Add (DS);
						}
						if (DS.theta == conjugateI)
								conDsList.Add (DS);
				}

				macroCMD = new MacroDiskReflectCmd (dsList);
				macroCMD.AddConjugate (conDsList);

				diskController.AddCmd (macroCMD);
		}

}

