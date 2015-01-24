import UnityEngine

class Play(MonoBehaviour):

	public speed as single = 1

	def Play ():
		animation.Play()
		for state as AnimationState in animation:
			state.speed = speed
