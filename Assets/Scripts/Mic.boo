import UnityEngine

class Mic(MonoBehaviour):

	public bufSize as int = 1
	public sampleRate as int = 44100
	public maxInputAmp as single = 5000

	public averagingSampleSize as single = 0.3

	public debugScreen as DebugScreen
	public volumeBar as UI.Image

	clip as AudioClip

	def Start():
		Debug.Log("Microphone.Start")
		clip = Microphone.Start(null, true, bufSize, sampleRate)

	def Update():
		pos = Microphone.GetPosition(null)
		if pos > 0:
			samples = array[of single]((clip.samples * clip.channels))
			clip.GetData(samples, 0)
			sum as single = 0.0
			srcIndex = pos
			numSamples = len(samples)
			for i in range(averagingSampleSize * sampleRate):
				sum += Mathf.Abs(samples[(srcIndex + numSamples) % numSamples])
				--srcIndex

			vol = Mathf.Clamp01(sum / maxInputAmp)
			vol = Mathf.Max(Mathf.Log(vol * 8, 2) / 3, 0)
			volumeBar.transform.localScale.y = vol
			debugScreen.logRow("pos=$(pos)")
			debugScreen.logRow("sum=$(sum)")
			debugScreen.logRow("vol=$(vol)")
