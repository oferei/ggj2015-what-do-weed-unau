import UnityEngine

class Mic(MonoBehaviour):

	public bufSize as int = 1
	public sampleRate as int = 44100
	public maxInputAmp as single = 1.0

	public averagingSampleSize as single = 0.3

	public debugScreen as DebugScreen
	public volumeBar as UI.Image

	clip as AudioClip

	def Start():
		clip = Microphone.Start(null, true, bufSize, sampleRate)

	def Update():
		pos = Microphone.GetPosition(null)
		# debugScreen.logRow("mic.pos=$(pos)")
		if pos > 0:
			samples = array[of single]((clip.samples * clip.channels))
			clip.GetData(samples, 0)
			sum as single = 0.0
			srcIndex = pos
			numSamples = len(samples)
			for i in range(averagingSampleSize * sampleRate):
				sum += Mathf.Abs(samples[(srcIndex + numSamples) % numSamples])
				--srcIndex
			avg as single = sum / (averagingSampleSize * sampleRate)
			# debugScreen.logRow("mic.avg=$(avg)")

			vol as single = Mathf.Clamp01(avg / maxInputAmp)
			# debugScreen.logRow("mic.vol1=$(vol)")
			vol = Mathf.Max(Mathf.Log(vol * 8, 2) / 3, 0)
			# debugScreen.logRow("mic.vol=$(vol)")
			volumeBar.transform.localScale.y = vol
