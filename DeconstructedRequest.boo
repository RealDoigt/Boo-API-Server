namespace Activité_04

import System
import System.Net
import System.Collections.Generic

class DeconstructedRequest:
	
	private serviceURL as string
	private serviceVersion as string
	
	# Dictionary[of clef, contenu]
	private params = Dictionary[of string, string]()
	
	ServiceURL:
		get:
			return serviceURL
			
	ServiceVersion:
		get:
			return serviceVersion
			
	self[key as string]:
		get:
			if params.ContainsKey(key):
				return params[key]
			else:
				return "key not found"
	
	def constructor(context as HttpListenerContext):
		
		URIDelimiters = "/?".ToCharArray()
		parametersDelimiter = "&".ToCharArray()
		singleParameterDelimiter = "=".ToCharArray()
		
		# Pour une raison obscure, les gens qui ont fait Boo voulait un Split() qui prend un pointeur!
		# L'ironie est que Boo est codé... en C#. Ce qui veut dire que quelque part dans le code, il y a un bloc unsafe {}
		# avec toute la patente de Split() dedans. C'est vraiment fort lol
		deconstructedURI = context.Request.RawUrl.Split(*URIDelimiters)
		
//		for n in range(deconstructedURI.Length):
//			print "$n $(deconstructedURI[n])"
		
		# Il va créer des cases vides, on ignore donc les index 0 & 3
		serviceURL = deconstructedURI[1] # stringservice dans stringservice/v1/?<params>
		serviceVersion = deconstructedURI[2] # v1 dans stringservice/v1/?params
		serviceParameters = deconstructedURI[4].Split(*parametersDelimiter) # params dans stringservice/v1/?<params>
		
		for param in serviceParameters:
			
			tempParams = param.Split(*singleParameterDelimiter)
			params[tempParams[0]] = tempParams[1]
		
	override def ToString():
		
		result = "URL: $serviceURL Version: $serviceVersion"
		
		for param in params:
			# En Boo, les concatenations avec $ et $() utilisent StringBuilder. Ce qui est beaucoup plus efficace qu'un += 
			result = "$result $(param.Key): $(param.Value)"
			
		return result
