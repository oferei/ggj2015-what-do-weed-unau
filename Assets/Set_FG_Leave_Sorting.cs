using UnityEngine;
using System.Collections;

public class Set_FG_Leave_Sorting : MonoBehaviour {
		void Start ()
		{
			// Set the sorting layer of the particle system.
			particleSystem.renderer.sortingLayerName = "FG_Leaves";
			//particleSystem.renderer.sortingOrder = 0;
	
	}
}
