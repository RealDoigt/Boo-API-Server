namespace Activité_04

import System
import System.IO
import System.Text
import System.Net
import System.Threading

static class Server:
	
	# En BOO, les membres sont public par défaut
	private PORT = 5000
	private URL_CENSURE = "censorservices"
	private URL_CHAINE = "stringservices"
	
	private def StartServer():
		
		listener = HttpListener()
		listener.Prefixes.Add("http://*:$PORT/")
		listener.Start()
		
		print "En attente sur le port $PORT"
		
		return listener
		
	private def SendText(response as HttpListenerResponse, text as string, encoding as Encoding):
		
		buffer = Encoding.GetEncoding(encoding.CodePage).GetBytes(text)
		response.ContentLength64 = buffer.Length
		
		using os = response.OutputStream:
			os.Write(buffer, 0, buffer.Length)
			
	private def SendIcon(response as HttpListenerResponse):
		
		icon = Drawing.Icon("favicon.ico")
		response.ContentLength64 = FileInfo("favicon.ico").Length
		icon.Save(response.OutputStream)
		#using os = response.OutputStream:
		#	os.Write(buffer, 0, buffer.Length)
			
	private def GetText(request as HttpListenerRequest):
		
		using body = request.InputStream:
			
			encoding = request.ContentEncoding
			
			using reader = StreamReader(body, encoding):
				
				if not request.ContentType == null:
					return EncodedText(reader.ReadToEnd(), encoding)
					
				else:
					return EncodedText("", encoding)
					
	# TODO RETOURNE STRING				
	private def ExecuteGETService(request as DeconstructedRequest):
		
		if request.ServiceURL == URL_CENSURE:
			
			if request["service"] == "rbw": # Replace Bad Words
				if request.Contains("s"):
					return CensorServices.ReplaceBadWords(request["s"])
				
			if request["service"] == "gbwl": # Get Bad Word List
				
				if request.Contains("o"):
					
					if request["o"] == "alphabetical":
						return CensorServices.GetAlphabeticalWordList(false)
						
					if request["o"] == "invertedalphabetical":
						return CensorServices.GetAlphabeticalWordList(true)
						
					if request["o"] == "ascendingLength":
						return CensorServices.GetWordListBySize(false)
						
					if request["o"] == "decreasingLength":
						return CensorServices.GetWordListBySize(true)	
					
					return "Invalid Option"
						
				return CensorServices.GetWordList()
				
			return "Invalid Request"
			
		if request.ServiceURL == URL_CHAINE:
			
			if request["service"] == "flsi": #Find Longest Sequence Index
				
				if request.Contains("s") and request.Contains("n"):
					
					n as int
					
					if int.TryParse(request["n"], n):
						return StringServices.FindLongestSequenceIndex(request["s"], n).ToString()
						
					return "n is not a number"
				
			if request["service"] == "ffls": #Find First Longest Sequence
				if request.Contains("s"):
					return StringServices.FindFirstLongestSequenceInterval(request["s"])
				
			if request["service"] == "rwo": #Reverse Word Order
				if request.Contains("s"):
					return StringServices.ReverseWordOrder(request["s"])
					
			if request["service"] == "rco": #Reverse Character Order
				if request.Contains("s"):
					return StringServices.ReverseCharacterOrder(request["s"])
					
			if request["service"] == "rcb": #Remove Character Beginning
				if request.Contains("s") and request.Contains("c"):
					return StringServices.RemoveCharacterBeginning(request["s"], request["c"][0])
					
			if request["service"] == "rce": #Remove Character End
				if request.Contains("s") and request.Contains("c"):
					return StringServices.RemoveCharacterEnd(request["s"], request["c"][0])
			
			if request["service"] == "rcbe": #Remove Character at Beginning and End
				if request.Contains("s") and request.Contains("c"):
					return StringServices.ReplaceCharacterBeginningEnd(request["s"], request["c"][0])
					
			if request["service"] == "reb": #Remove Extra Blanks
				if request.Contains("s"):
					return StringServices.RemoveExtraBlanks(request["s"])
			
			return "Service Not Found"
			
		return "Service Type Not Found"
			
	
	# TODO RETOURNE STRING
	private def ExecutePOSTService(context as HttpListenerContext):
		
		if context.Request.RawUrl == "/$URL_CENSURE/v1":
		
			encodedText = GetText(context.Request)
			CensorServices.AddWordsToList(encodedText.text.Split(char(' ')))
			return "Success"
		
		return "Fail"
	
	# TODO RETOURNE STRING
	private def ExecuteDELETEService(context as HttpListenerContext):
		
		if context.Request.RawUrl == "/$URL_CENSURE/v1":
		
			encodedText = GetText(context.Request)
			CensorServices.RemoveWordFromList(encodedText.text)
			return "Success"
		
		return "Fail"
		
	def Start():
		
		fini = false
		listener = StartServer()
		
		def EndServiceOnInput():
			
			Console.ReadKey(true)
			fini = true
		
		fil = Thread(EndServiceOnInput)
		fil.Start()
		
		while not fini:
			
			context = listener.GetContext()
			print "requête à l'uri $(context.Request.RawUrl) avec méthode $(context.Request.HttpMethod) reçue."
			
			if context.Request.RawUrl.Contains("favicon"):
				SendIcon(context.Response)
				
			elif context.Request.HttpMethod == "POST":
				SendText(context.Response, ExecutePOSTService(context), context.Request.ContentEncoding)
							
			elif context.Request.HttpMethod == "DELETE":
				SendText(context.Response, ExecuteDELETEService(context), context.Request.ContentEncoding)
			
			else:
				
				try:
					
					request = DeconstructedRequest(context)
					
					if request.ServiceVersion == "v1":
						
						if context.Request.HttpMethod == "GET":
							SendText(context.Response, ExecuteGETService(request), context.Request.ContentEncoding)
							
						else:
							SendText(context.Response, "Method Not Supported", context.Request.ContentEncoding)
							
					else:
						SendText(context.Response, "Version Mismatch", context.Request.ContentEncoding)
					
				except e:
							
					print "Erreur: $e"
					SendText(context.Response, "Bad Request", context.Request.ContentEncoding)
			
		fil.Join()
		