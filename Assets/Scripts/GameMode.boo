import UnityEngine

class GameMode(MonoBehaviour):

	enum Mode:
		Dialogue
		Inhale
		Hold
		Exhale

	public/**/ _current = Mode.Inhale
	current:
		get:
			return _current

	def Start():
		MessageMode(current)
