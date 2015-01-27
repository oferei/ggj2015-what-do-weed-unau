import UnityEngine

class Mic(MonoBehaviour):

	public bufSize as int = 1
	public sampleRate as int = 44100
	public windowSizeInSecs as single = 0.3
	public spectrumSampleSize as int = 1024 # pow of 2, 64 to 8192
	public fftWindow as FFTWindow
	public minAmp as single = 0.02
	public volumeBar as UI.Image

	fSample as single

	visualHeight as single = 20

	_loudnessRms as single = 0
	loudnessRms:
		get:
			return _loudnessRms
		set:
			_loudnessRms = value
			volumeBar.transform.localScale.y = _loudnessRms

	loudnessDb:
		get:
			return 20 * Mathf.Log10(_loudnessRms)

	clip as AudioClip

	spectrum as (single)

	def Awake():
		spectrum = array(single, spectrumSampleSize)

	def Start():
		clip = Microphone.Start(null, true, bufSize, sampleRate)
		audio.clip = clip
		audio.loop = true
		audio.mute = true
		audio.Play()

		fSample = AudioSettings.outputSampleRate
		# Debug.Log("AudioSettings.outputSampleRate=$(AudioSettings.outputSampleRate)")

	def Update():
		calcLoudness()
		# analyzeSpectrum()

	def calcLoudness():
		pos = Microphone.GetPosition(null)
		# DebugScreen.logRow("mic.pos=$(pos)")
		if pos > 0:
			samples = array[of single]((clip.samples * clip.channels))
			clip.GetData(samples, 0)
			sum as single = 0.0
			srcIndex = pos
			numSamples = len(samples)
			numSamplesInWindow = windowSizeInSecs * sampleRate
			for i in range(numSamplesInWindow):
				sum += Mathf.Pow(samples[(srcIndex + numSamples) % numSamples], 2)
				--srcIndex
			loudnessRms = Mathf.Sqrt(sum / numSamplesInWindow)
			DebugScreen.logRow("mic.rms=$(loudnessRms.ToString('0.##'))")
			# DebugScreen.logRow("mic.db=$(loudnessDb.ToString('0.#'))")

	def analyzeSpectrum():
		audio.GetSpectrumData(spectrum, 0, fftWindow)

		xFactor = spectrumSampleSize cast single / Mathf.Log(spectrumSampleSize)
		# Debug.DrawLine(Vector3(0, 0 - (13 * visualHeight), 0), Vector3(spectrumSampleSize, 0 - (13 * visualHeight), 0), Color.yellow)
		for i in range(1, spectrumSampleSize):
			Debug.DrawLine(Vector3((i - 1), (spectrum[i - 1]) * 95 * visualHeight + 231 * 2, 0), Vector3(i, (spectrum[(i)]) * 95 * visualHeight + 231 * 2, 0), Color.red)
			Debug.DrawLine(Vector3((i - 1), (Mathf.Log(spectrum[(i - 1)])) * visualHeight + 231 * 2, 2), Vector3(i, (Mathf.Log(spectrum[i])) * visualHeight + 231 * 2, 2), Color.cyan)
			Debug.DrawLine(Vector3(Mathf.Log((i - 1)) * xFactor, (spectrum[(i - 1)] * 95) * visualHeight - 231, 1), Vector3(Mathf.Log(i) * xFactor, (spectrum[i] * 95) * visualHeight - 231, 1), Color.green)
			Debug.DrawLine(Vector3(Mathf.Log((i - 1)) * xFactor, Mathf.Log(spectrum[(i - 1)]) * visualHeight - 231, 3), Vector3(Mathf.Log(i) * xFactor, Mathf.Log(spectrum[i]) * visualHeight - 231, 3), Color.yellow)

		calcPitch()

	def calcPitch():
		maxI as int = -1
		maxSample as single = -1
		for i in range(spectrumSampleSize):
			if spectrum[i] > minAmp and spectrum[i] > maxSample:
				maxSample = spectrum[i]
				maxI = i

		if maxI > -1:
			# DebugScreen.logRow("maxI=$(maxI)")
			# interpolate index using neighbours
			indexF = maxI cast single
			if maxI > 0 and maxI < spectrumSampleSize - 1:
				dL = spectrum[maxI - 1] / spectrum[maxI]
				dR = spectrum[maxI + 1] / spectrum[maxI]
				indexF += 0.5 * (dR * dR - dL * dL)
			pitch = indexF * (fSample / 2) / spectrumSampleSize
			DebugScreen.logRow("pitch=$(pitch)hz")
		else:
			# DebugScreen.logRow("maxI=")
			DebugScreen.logRow("pitch=")
