namespace Activité_04

import System
import System.Collections.Generic

static class StringServices:
	
	#S1
	def FindFirstLongestSequence(arg as string):
		
		
		startPosition = 0 # maybe ?
		count = 0 # nombre de séquence
		character = arg[0]
		index = 1
		sequences = List[of CharacterSequence]()
		
		while index < arg.Length:
		
			if character == arg[index]:
				++count

			else: 
				sequences.Add(CharacterSequence(startPosition, count, character, index)) 
				count = 0
				startPosition = index		
				character = arg[index]					
			
			++index
		
		sequences.Add(CharacterSequence(startPosition, count, character, index)) 
		longuestSequence = sequences[sequences.Count - 1]
		
		for indice in range(sequences.Count - 2):
			print sequences[indice].Count
			print longuestSequence.Count
			if sequences[indice].Count > longuestSequence.Count:
				longuestSequence = sequences[indice]
			
		return "[$(longuestSequence.StartPosition), $(longuestSequence.EndPosition))"
	
	#S2
	def ReverseWordOrder(arg as string):
		pass
	
	#S3
	def ReverseCharacterOrder(arg as string):
		pass
	
	#S4
	def RemoveCharacter(arg as string):
		pass
		
	#S5
	def RemoveCharacterBeginningEnd(arg as string):
		pass
	
	#S6
	def ReplaceBadWords(arg as string):
		pass
	
	#TODO: renommer de façon à réfléter le fonctionnement réel.
	#S0	
	def FindNumberIndex(arg as string):
		pass