// Startup wrapper only. The consultation interface and inference remain Java/Prolog.
using System;
using System.Diagnostics;
using System.IO;
using System.Windows.Forms;
[assembly: System.Reflection.AssemblyVersion("1.3.0.0")]
[assembly: System.Reflection.AssemblyFileVersion("1.3.0.0")]
class WindowsLauncher {
    [STAThread] static int Main(string[] args) {
        string root=AppDomain.CurrentDomain.BaseDirectory;
        string script=Path.Combine(root,"launch.ps1");
        if(!File.Exists(script)){MessageBox.Show("Run Install-Application-Windows.cmd before opening DentalExplain.","DentalExplain");return 1;}
        // Pass arguments as JSON in a process-local environment variable, not shell code.
        var settings=new ProcessStartInfo("powershell.exe","-NoProfile -ExecutionPolicy Bypass -Command \"& $env:DENTAL_LAUNCH_SCRIPT -Action Launch -AppArguments (ConvertFrom-Json $env:DENTAL_LAUNCH_ARGS)\"");
        settings.UseShellExecute=false; settings.CreateNoWindow=args.Length==0;
        settings.EnvironmentVariables["DENTAL_LAUNCH_SCRIPT"]=script;
        settings.EnvironmentVariables["DENTAL_LAUNCH_ARGS"]=new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(args);
        using(var child=Process.Start(settings)){child.WaitForExit();if(child.ExitCode!=0 && args.Length==0)MessageBox.Show("DentalExplain could not start. Run Install-Dependencies-Windows.cmd again, then Install-Application-Windows.cmd.","DentalExplain");return child.ExitCode;}
    }
}
