using UnityEngine;
using System.Collections;

public class Pipe_Smoke_Sorting_Layer : MonoBehaviour {
		void Start ()
		{
			// Set the sorting layer of the particle system.
			particleSystem.renderer.sortingLayerName = "Pipe_Smoke";
			//particleSystem.renderer.sortingOrder = 0;
	
	}
}
