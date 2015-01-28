import UnityEngine

class BreathDetect(MonoBehaviour):

	public inhaleMinFrequency as single = 2000
	public inhaleMaxFrequency as single = 12000
	public inhaleGain as int = 1000
	public exhaleMinFrequency as single = 0000
	public exhaleMaxFrequency as single = 5000
	public exhaleGain as int = 1000

	public mic as Mic

	_inhaleStrength as single
	inhaleStrength:
		get:
			return _inhaleStrength

	_exhaleStrength as single
	exhaleStrength:
		get:
			return _exhaleStrength

	pitch as single

	def Awake():
		InvokeRepeating("updatePitch", 0, 1)

	def Update ():
		_inhaleStrength = mic.loudnessBetween(inhaleMinFrequency, inhaleMaxFrequency) * inhaleGain
		DebugScreen.logRow("inhale=$(inhaleStrength.ToString('0.##'))")
		_inhaleStrength = Mathf.Clamp01(_inhaleStrength)

		_exhaleStrength = mic.loudnessBetween(exhaleMinFrequency, exhaleMaxFrequency) * exhaleGain
		DebugScreen.logRow("exhale=$(exhaleStrength.ToString('0.##'))")
		_exhaleStrength = Mathf.Clamp01(_exhaleStrength)

		# debugTests()

	def debugTests():
		DebugScreen.logRow("<300=$((mic.loudnessBelow(300) * 100).ToString('0.##'))")
		DebugScreen.logRow("300-1k=$((mic.loudnessBetween(300, 1000) * 100).ToString('0.##'))")
		DebugScreen.logRow("1k-2k=$((mic.loudnessBetween(1000, 2000) * 100).ToString('0.##'))")
		DebugScreen.logRow("2k-5k=$((mic.loudnessBetween(2000, 5000) * 100).ToString('0.##'))")
		DebugScreen.logRow("5k-10k=$((mic.loudnessBetween(5000, 10000) * 100).ToString('0.##'))")
		DebugScreen.logRow("10k-12=$((mic.loudnessBetween(10000, 12000) * 100).ToString('0.##'))")
		# DebugScreen.logRow("12-15k=$((mic.loudnessBetween(12000, 15000) * 100).ToString('0.##'))")
		# DebugScreen.logRow(">15k=$((mic.loudnessAbove(15000) * 100).ToString('0.##'))")
		# DebugScreen.logRow("0-5K=$((mic.loudnessBetween(0, 5000) * 100).ToString('0.##'))")
		# DebugScreen.logRow("1k-5K=$((mic.loudnessBetween(1000, 5000) * 100).ToString('0.##'))")
		DebugScreen.logRow("2k-3K=$((mic.loudnessBetween(2000, 3000) * 100).ToString('0.##'))")
		DebugScreen.logRow("2k-4K=$((mic.loudnessBetween(2000, 4000) * 100).ToString('0.##'))")
		DebugScreen.logRow("2k-5K=$((mic.loudnessBetween(2000, 5000) * 100).ToString('0.##'))")
		# DebugScreen.logRow("1k-12=$((mic.loudnessBetween(1000, 12000) * 100).ToString('0.##'))")
		DebugScreen.logRow("2k-12=$((mic.loudnessBetween(2000, 12000) * 100).ToString('0.##'))")
		DebugScreen.logRow("3k-12=$((mic.loudnessBetween(3000, 12000) * 100).ToString('0.##'))")
		DebugScreen.logRow("pitch>1k=$(pitch.ToString('0.#'))hz")

	def updatePitch():
		pitch = mic.pitchAbove(1000)
