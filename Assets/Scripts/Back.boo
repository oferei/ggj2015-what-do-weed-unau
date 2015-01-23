import UnityEngine

class Back(MonoBehaviour):

	def Update ():
		if Input.GetKeyDown(KeyCode.Escape):
			Application.Quit()
