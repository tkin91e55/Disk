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
						Assert.IsNotNull(testObj.SegmentCount);

						//theSub.RotateAtR(1,null);
				}

		[Test]
		public void DiskGetSegmentAt_R_Theta () {

			Disk testObj = new Disk (GetMockSegments ());
			DiskSegment temp = testObj.GetASegment(1,8);
			Assert.AreEqual(temp.r,1);
			Assert.AreEqual(temp.theta,8);
		}
#endif

				//how to make this work?
				IEnumerator SimpleTest ()
				{
						Debug.Log ("hIHIHI");
						yield return 40;

				}

				Transform[] GetMockSegments ()
				{

						GameObject goPrefab = (GameObject)Resources.LoadAssetAtPath ("Assets/Tests/Editor/DiskMock.prefab", typeof(GameObject));
						Transform[] mockSegments = goPrefab.GetComponent<DiskController> ().mSegments;

						return mockSegments;
				}
		}
}