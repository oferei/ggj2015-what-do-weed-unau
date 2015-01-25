# import UnityEngine

class MessageMode(Message):

	mode:
		get:
			return _mode
	_mode as GameMode
 
	def constructor(mode):
 
		_mode = mode
 
		# send the message
		super()
