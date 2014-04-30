using System;
using System.Diagnostics;
using System.IO;

namespace Packaging.Lua
{
    public class LuaCompiler
    {
        private readonly string compilerPath;

        public LuaCompiler(string compilerPath)
        {
            this.compilerPath = compilerPath;
        }

        public void Compile(string sourceDirectoryPath, string outputDirectoryPath = null)
        {
            var sourceDir = new DirectoryInfo(sourceDirectoryPath);

            if (!sourceDir.Exists)
            {
                return;
            }

            var outputDir = outputDirectoryPath != null ? new DirectoryInfo(outputDirectoryPath) : sourceDir.Parent;
            var files = sourceDir.EnumerateFiles("*.lua");

            ProcessStartInfo startInfo = new ProcessStartInfo();
            startInfo.CreateNoWindow = false;
            startInfo.UseShellExecute = false;
            startInfo.FileName = this.compilerPath;
            startInfo.WindowStyle = ProcessWindowStyle.Hidden;

            foreach (var file in files)
            {
                var source = string.Format(@"{0}\{1}", sourceDir.FullName, file.Name);
                var output = string.Format(@"{0}\{1}", outputDir.FullName, file.Name.Replace(file.Extension, ".xpl"));
                startInfo.Arguments = string.Format("-bg \"{0}\" \"{1}\"", source, output);
                using (Process exeProcess = Process.Start(startInfo))
                {
                    exeProcess.WaitForExit();
                    if (exeProcess.ExitCode != 0)
                    {
                        throw new Exception(string.Format("Compiler exited with exit code {0}", exeProcess.ExitCode));
                    }
                }
            }
        }
    }
}
