namespace Activité_04

import System

struct CharacterSequence:

	private startPosition as int
	private count as int
	private character as char
	private endPosition as int

	StartPosition:
		
		get:
			return startPosition			
	
	EndPosition:
		
		get:
			return endPosition	
	
	Count:
		
		get:
			return count
			
	
	Character:
		
		get:
			return character	
			
			
 	
	
 	
	


	public def constructor(startPosition as int, count as int, character as char, endPosition as int):
		
		self.startPosition = startPosition
		self.count = count
		self.character = character 
		self.endPosition = endPosition
