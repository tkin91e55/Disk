using UnityEngine;
using System.Collections;

public class DiskUtility {

	public static int GetConjugateTheta (int i, int ThetaMod)
	{
		i += ThetaMod / 2;
		if (i > ThetaMod)
			i -= ThetaMod;
		return i;
	}

	public static int GetDegreeTheta (int i, int ThetaMod)
	{
		int degree = 0;
		degree = i * 360 / ThetaMod;
		if (i == ThetaMod)
						degree = 0;
		return degree;
		}

}
