namespace Activité_04

import System
import System.Text

struct EncodedText:
	
	text as string
	encoding as Encoding
	
	def constructor(text as string,  encoding as Encoding):
		self.text = text
		self.encoding = encoding

