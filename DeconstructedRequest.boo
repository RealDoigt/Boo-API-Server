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
		deconstructedURI = context.Request.RawUrl.Split(*URIDelimiters)
		
		# Il va créer des cases vides, on ignore donc les index 0 & 3
		serviceURL = deconstructedURI[1] # stringservice dans stringservice/v1/?<params>
		serviceVersion = deconstructedURI[2] # v1 dans stringservice/v1/?params
		serviceParameters = deconstructedURI[4].Split(*parametersDelimiter) # params dans stringservice/v1/?<params>
		
		for param in serviceParameters:
			
			tempParams = param.Split(*singleParameterDelimiter)
			params[tempParams[0]] = StringServices.ReplaceHTMLSpaceCode(tempParams[1])
		
	override def ToString():
		
		result = "URL: $serviceURL Version: $serviceVersion"
		
		for param in params:
			# En Boo, les interpolations avec $ et $() utilisent StringBuilder. Ce qui est beaucoup plus efficace qu'un += 
			result = "$result $(param.Key): $(param.Value)"
			
		return result
		
	def Contains(key as string):
		return params.ContainsKey(key)