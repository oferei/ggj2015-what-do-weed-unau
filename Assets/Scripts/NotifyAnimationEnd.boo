import UnityEngine

class NotifyAnimationEnd(MonoBehaviour):

	public gameloop as Loop

	playing = false

	def Update():
		for state as AnimationState in animation:
			pos = state.normalizedTime
			if pos > 0:
				# Debug.Log("*** animation pos: $(pos)")
				playing = true
			else:
				if playing:
					playing = false
					gameloop.onAnimationEnd(animation)
