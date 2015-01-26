import UnityEngine

class HideInRelease(MonoBehaviour):

	def Awake():
		isDebug = Application.platform == RuntimePlatform.WindowsEditor or Application.platform == RuntimePlatform.OSXEditor
		gameObject.SetActive(isDebug)
