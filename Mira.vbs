 ''' sCRIPT THAT EXECUTE CIA.BAT in unhide mode

 '''  1. Create a new VBScript file and paste the following code into it:

Set objShell = CreateObject("WScript.Shell")
objShell.Run "cmd /c cia.bat", 0, True

