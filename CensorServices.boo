namespace Activité_04

import System
import System.IO
import System.Collections.Generic

static class CensorServices:
	
	# NSV -> Newline Separated Values
	BANNED_LIST_PATH = "banned words.nsv"
	
	def ReplaceBadWords(arg as string):
		
		words = arg.Split(char(' '))
		bannedWords = File.ReadAllLines(BANNED_LIST_PATH)
		
		for index in range(words.Length):
			for banned in bannedWords:
				if words[index].ToLower().Contains(banned.ToLower()):
					words[index] = "*" * words[index].Length
					
		return string.Join(" ", *words)
	
	def AddWordsToList(arg as (string)):
		
		bannedWords = List[of string]()
		bannedWords.AddRange(File.ReadAllLines(BANNED_LIST_PATH))
		
		for index in range(arg.Length):
			
			for banned in bannedWords:
				if arg[index].ToLower() == banned.ToLower():
					break
			
			bannedWords.Add(arg[index])
			
		File.WriteAllLines(BANNED_LIST_PATH, bannedWords.ToArray())
		
	def RemoveWordFromList(arg as string):
		
		bannedWords = List[of string]()
		bannedWords.AddRange(File.ReadAllLines(BANNED_LIST_PATH))
		
		for banned in bannedWords:
			
			if arg.ToLower() == banned.ToLower():
				
				bannedWords.Remove(arg)
				break
					
		File.WriteAllLines(BANNED_LIST_PATH, bannedWords.ToArray())
	
	def GetWordList():
		return string.Join(", ", File.ReadAllLines(BANNED_LIST_PATH))
		
	def GetAlphabeticalWordList():
		
		bannedWords = List[of string]()
		bannedWords.AddRange(File.ReadAllLines(BANNED_LIST_PATH))
		bannedWords.Sort() # Comportement par défaut est l'ordre alphabétique
		return string.Join(", ", bannedWords)
		
	def GetWordListBySize():
		
		def CompareStrings(str1 as string, str2 as string):
			
			if str1.Length > str2.Length:
				return 1
				
			elif str1.Length < str2.Length:
				return -1
				
			return 0
			
		
		bannedWords = List[of string]()
		bannedWords.AddRange(File.ReadAllLines(BANNED_LIST_PATH))
		bannedWords.Sort(CompareStrings)
		return string.Join(", ", bannedWords)
			
		
		