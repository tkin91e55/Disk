using NSubstitute;
using NUnit.Framework;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

//test files need to be placed in Editor folder

namespace DiskTests
{
		public class DiskTestCases
		{

#if true //Disk basic test

				[Test]
				public void DiskInitalizeTest ()
				{
						Disk testObj = new Disk (GetMockSegments ());
						Assert.IsNotNull (testObj);
				}

				[Test]
				public void DiskGetSegmentAt_R_Theta ()
				{

						Disk testObj = new Disk (GetMockSegments ());
						DiskSegment temp = testObj.GetASegment (1, 8);
						Assert.AreEqual (temp.r, 1);
						Assert.AreEqual (temp.theta, 8);
				}

				[Test]
				public void DiskSegmentInfoCyclicTheta ()
				{

						//TODO: Test whether the cyclic relative theta coor work
						Disk mockDisk = new Disk (GetMockSegments ());

						Assert.AreEqual (8, mockDisk.GetASegment (3, 8).theta);
						mockDisk.RotateAtR (3, null);
						Assert.AreEqual (7, mockDisk.GetASegment (3, 8).theta);

				}

				[Test]
				//Test the Disk RotateAtR function
				public void DiskRotateAtR ()
				{
						Disk mockDisk = new Disk (GetMockSegments ());

						int r = 3, absR, relativeR;
						int theta = 4, absTheta, relativeTheta;

						//getting a segment in relative coor
						DiskSegment traceSeg = mockDisk.GetASegment (r, theta);

						absR = traceSeg.r;
						relativeR = r;
						absTheta = traceSeg.theta;
						relativeTheta = theta;

						Assert.AreEqual (r, traceSeg.r);
						Assert.AreEqual (theta, traceSeg.theta);

						mockDisk.RotateAtR (r, null);
						//after rotation, the trace segment absolute coor should keep the same, but not relative coor.
						relativeTheta ++;

						//Result: the traceSeg abs coor should not change:
						Assert.AreEqual (absR, traceSeg.r);
						Assert.AreEqual (absTheta, traceSeg.theta);

						//Result: getting the Disk's segment with same relative coor should not be traceSeg anymore:
						Assert.AreNotEqual (traceSeg, mockDisk.GetASegment (r, theta));
						Assert.AreEqual (traceSeg, mockDisk.GetASegment (r, theta + 1));
				}

				[Test]
				public void DiskModeFunctionality ()
				{
				}
#endif

#if true //Disk Segment basic tests

		[Test]
		public void TestAsPublisher () {

			DiskSegment aSegTrans = (DiskSegment)GetMockSegments().GetValue(0);

			var testDS = Substitute.For<DiskSegment>();

			Debug.Log(System.String.Format("testDS : {0}, {1}",testDS.r,testDS.theta));
			//This is the limitation of NSub...you can't call base
			//testDS.Rotate(45f,1f);

		}
#endif

				//how to make this work?
				IEnumerator SimpleTest ()
				{
						Debug.Log ("hIHIHI");
						yield return 40;

				}

				//this function was tested valid
				/*Transform[] GetMockSegments ()
				{

						//DiskMock.prefab is under Editor folder because this script is needed under Editor folder
						GameObject goPrefab = (GameObject)Resources.LoadAssetAtPath ("Assets/Tests/Editor/DiskMock.prefab", typeof(GameObject)); 
						Transform[] mockSegments = goPrefab.GetComponent<DiskController> ().mSegments;

						return mockSegments;
				}*/

		DiskSegment[] GetMockSegments () {

			GameObject goPrefab = (GameObject)Resources.LoadAssetAtPath ("Assets/Scenes/CircularDisk3r8.prefab", typeof(GameObject)); 

			List<Transform> childtrasforms = new List<Transform> ();
			
			Utility.RecursiveGetChildren (goPrefab.transform, childtrasforms);

			List<DiskSegment> mockSegments = new List<DiskSegment>();

			foreach (Transform trans in childtrasforms){

				if (trans.GetComponent<DiskSegment>() != null)
					mockSegments.Add(trans.GetComponent<DiskSegment>());
			}

			return mockSegments.ToArray();

		}

		}
}