using System;
using System.Diagnostics;

namespace Packaging.Cat
{
    public class CatPackager
    {
        private readonly string packagerPath;

        public CatPackager(string packagerPath)
        {
            this.packagerPath = packagerPath;
        }

        public void Package(string rootDirectoryPath, string outputPath, string outputFileName, string includePattern = "", string excludePattern = "")
        {
            ProcessStartInfo startInfo = new ProcessStartInfo();
            startInfo.CreateNoWindow = false;
            startInfo.UseShellExecute = false;
            startInfo.FileName = this.packagerPath;
            startInfo.WindowStyle = ProcessWindowStyle.Hidden;

            string targetName = string.Format(@"{0}\{1}", outputPath, outputFileName);
            startInfo.Arguments = string.Format("-in \"{0}\" -out \"{1}\" -include {2} -exclude {3} -dump", rootDirectoryPath, targetName, includePattern, excludePattern);
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
