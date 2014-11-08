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
				if (GUI.Button (new Rect (0, 0, Screen.width / 8, Screen.height / 15), "Rotate inner aniti-clockwise")) {
						SetAntiRot (1);
				}
				if (GUI.Button (new Rect (0, Screen.height / 15, Screen.width / 8, Screen.height / 15), "Rotate Middle aniti-clockwise")) {
						SetAntiRot (2);
				}
				if (GUI.Button (new Rect (0, 2 * Screen.height / 15, Screen.width / 8, Screen.height / 15), "Rotate outer aniti-clockwise")) {
						SetAntiRot (3);
				}
				if (GUI.Button (new Rect (Screen.width / 8, 0, Screen.width / 8, Screen.height / 15), "Rotate inner clockwise")) {
						SetClockwiseRotation (1);
				}
				if (GUI.Button (new Rect (Screen.width / 8, Screen.height / 15, Screen.width / 8, Screen.height / 15), "Rotate Middle clockwise")) {
						SetClockwiseRotation (2);
				}
				if (GUI.Button (new Rect (Screen.width / 8, 2 * Screen.height / 15, Screen.width / 8, Screen.height / 15), "Rotate outer clockwise")) {
						SetClockwiseRotation (3);
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
		void SetClockwiseRotation (int i)
		{
				ArrayList dsList = new ArrayList ();
				foreach (RelativeDiskSegment DS in mRelativeSegments) {
						if (DS.r == i) {
								if (!DS.IsBusy)
										dsList.Add (DS);
								else 
										return;
						}
				}
				//macroCMD.SetVerificationCondition (i);
				//macroCMD.Verify ();
				diskController.AddCmd (new MacroDiskRotateCmd (dsList, rotateSound, transform));
		}

		void SetAntiRot (int i)
		{
				ArrayList dsList = new ArrayList ();
				foreach (RelativeDiskSegment DS in mRelativeSegments) {
						if (DS.r == i) {
								if (!DS.IsBusy)
										dsList.Add (DS);
								else 
										return;
						}
				}
				diskController.AddCmd (new MacroDiskRotateCmd (dsList, rotateSound, transform, -45.0f));
		}

		void SetReflection (int i)
		{
				int conjugateI = DiskUtility.GetConjugateTheta (i, mRelativeSegments [0].ThetaMod);
				MacroDiskReflectCmd macroCMD;

				ArrayList dsList = new ArrayList ();
				ArrayList conDsList = new ArrayList ();
				foreach (RelativeDiskSegment DS in mRelativeSegments) {
						if (DS.theta == i) {
								if (!DS.IsBusy)
										dsList.Add (DS);
								else 										
										return;								
						}
						if (DS.theta == conjugateI)
						if (!DS.IsBusy)
								conDsList.Add (DS);
						else 
								return;
				}

				macroCMD = new MacroDiskReflectCmd (dsList);
				//macroCMD.SetVerificationCondition (i);
				//macroCMD.Verify ();
				//macroCMD.AddConjugate (conDsList, conjugateI);
				macroCMD.AddConjugate (conDsList);
				diskController.AddCmd (macroCMD);
		}

}

