using UnityEngine;
using System.Collections;

public class Flame_Sorting : MonoBehaviour {

	void Start () {
		renderer.sortingLayerName = "Flame";
		Debug.Log ("Sorting layer is:" + renderer.sortingLayerName);
	}
}