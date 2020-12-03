namespace Activité_04

import System
import System.Text.RegularExpressions

static class StringServices:
	
	
	#S0	
	def FindLongestSequenceIndex(arg as string, length as int):
		
		reg = /(\w)\1+/
		matches = reg.Matches(arg)			
		
		for matching as Match in matches:
			if length == matching.Length :
				return matching.Index	

		return -1
		
	#S1
	def FindFirstLongestSequenceInterval(arg as string):
				
		reg = /(\w)\1+/
		matches = reg.Matches(arg)		
		longestSequence = 0
		indiceFin = 0
		position = 0
		
		for matching as Match in matches:
			if longestSequence < matching.Length:
				longestSequence = matching.Length
				position = matching.Index
		
		indiceFin = longestSequence + position
		return "[$position, $indiceFin)"
	
	#S2
	def ReverseWordOrder(arg as string):
		
		# TODO: Convertir les blancs en espaces
		stringArray = arg.Split(char(' '))
		Array.Reverse(stringArray)
		
		return string.Join(" ", *stringArray)
	
	#S3
	def ReverseCharacterOrder(arg as string):
		
		charArray = arg.ToCharArray()
		Array.Reverse(charArray)
		
		return charArray.ToString()
		
	
	#S4
	def RemoveCharacterBeginning(arg as string, character as char):
	
		result = arg
		result = result.Trim()
		
		if result[0] == character:
			result = result[1:]
			
		return result
		
	#S5
	def RemoveCharacterEnd(arg as string, character as char):
		
		result = arg
		
		if result[result.Length - 1] == character:
			result = result[:result.Length - 1]
			
		return result
	
	#S6
	def ReplaceCharacterBeginningEnd(arg as string, character as char):
		
		str = RemoveCharacterBeginning(arg, character)
		str = RemoveCharacterEnd(str, character)
	
		return str
	
	#7
	def RemoveExtraBlanks(arg as string) as string:
		pass
	
		
	