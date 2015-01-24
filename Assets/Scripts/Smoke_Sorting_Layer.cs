using UnityEngine;
using System.Collections;

public class Smoke_Sorting_Layer : MonoBehaviour {
		void Start ()
		{
			// Set the sorting layer of the particle system.
			particleSystem.renderer.sortingLayerName = "Smoke";
			//particleSystem.renderer.sortingOrder = 0;
	
	}
}
