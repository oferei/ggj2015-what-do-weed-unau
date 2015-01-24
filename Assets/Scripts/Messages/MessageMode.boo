# import UnityEngine

class MessageMode(Message):

	mode:
		get:
			return _mode
	_mode as GameMode.Mode
 
	def constructor(mode):
 
		_mode = mode
 
		# send the message
		super()
