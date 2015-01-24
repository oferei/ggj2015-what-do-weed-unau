import UnityEngine

class LighterMove(MonoBehaviour):

	public target as Transform

	public maxY as single = 1
	public minY as single = 0.7
	public speed as single = 3
	public insideAnimPos as single = 0.27

	animPos as single = 0.0

	lighterShow as LighterShow

	def Awake():
		lighterShow = GetComponent[of LighterShow]()

	def Update():
		if lighterShow.shown:
			if Input.GetMouseButton(0):
				pos = Input.mousePosition.y / Screen.height
				DebugScreen.logRow("pos=$(pos)")
				t = Mathf.InverseLerp(maxY, minY, pos)
				DebugScreen.logRow("t=$(t)")
				desiredAnimPos = Mathf.Lerp(insideAnimPos, 1, t)
			else:
				desiredAnimPos = insideAnimPos
		else:
			desiredAnimPos = 0
		animPos = Mathf.Lerp(animPos, desiredAnimPos, speed * Time.deltaTime)
