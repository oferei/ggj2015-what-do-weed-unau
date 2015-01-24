import UnityEngine

class RewindCamAnimation (MonoBehaviour): 

	def Start ():
		animation.Play()
		animation.Rewind()
		animation.Sample()
		animation.Stop()