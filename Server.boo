namespace Activité_04

import System
import System.IO
import System.Text
import System.Net
import System.Threading

static class Server:
	
	# En BOO, les membres sont public par défaut
	private PORT = 5000
	
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
			
			if context.Request.RawUrl.Contains("favicon.ico"):
				SendIcon(context.Response)
			
			elif context.Request.HttpMethod != "GET":
				
				text = GetText(context.Request)
				SendText(context.Response, text.text, text.encoding)
				
			else:
				
				try:
					
					request = DeconstructedRequest(context)
					print request.ToString()
					# TODO: remplacer x par le vrai text
					SendText(context.Response, "x", context.Request.ContentEncoding)
				
				except e:
					
					print "Erreur: $e"
					SendText(context.Response, "Bad Request", context.Request.ContentEncoding)
					
			
		fil.Join()
		