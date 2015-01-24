import UnityEngine

class LighterMove(MonoBehaviour):

	public handController as Animation
	public hand as Animation

	public maxY as single = 1
	public minY as single = 0.7
	public speed as single = 3

	_shown as bool = false
	shown:
		get:
			return _shown
		set:
			if _shown != value:
				_shown = value
				onShownChanged()

	handControllerAnimPos as single = 0.0
	handAnimPos as single = 0.0

	# def Awake():
	# 	handController.Play()

	def Update():
		if shown:
			if Input.GetMouseButton(0):
				pos = Input.mousePosition.y / Screen.height
				DebugScreen.logRow("pos=$(pos)")
				t = Mathf.InverseLerp(maxY, minY, pos)
				DebugScreen.logRow("t=$(t)")
				desiredhandAnimPos = t
			else:
				desiredhandAnimPos = 0
		else:
			desiredhandAnimPos = 0
		handAnimPos = Mathf.Lerp(handAnimPos, desiredhandAnimPos, speed * Time.deltaTime)

	def onShownChanged():
		Debug.Log("*** shown=" + shown)
		if shown:
			handController.Play()
