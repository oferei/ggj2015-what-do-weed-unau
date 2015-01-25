import UnityEngine

class FPS(MonoBehaviour):

	fps as int = 0
	count as int = 0

	def Start():
		StartCoroutine(monitor())

	def Update():
		++count

	def LateUpdate():
		DebugScreen.logRow("FPS=$(fps)")

	def monitor() as IEnumerator:
		while true:
			yield WaitForSeconds(1)
			fps = count
			count = 0
