import UnityEngine

class Utils (MonoBehaviour): 

	static def pickSprite(sprites as (Sprite), choice as single) as Sprite:
		index = Mathf.FloorToInt(Mathf.Clamp01(choice) * sprites.Length)
		if index == sprites.Length:
			--index
		return sprites[index]
