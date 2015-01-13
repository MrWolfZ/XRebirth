using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Packaging.Mods;

namespace Packaging
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var rebirthProc = Process.GetProcessesByName("XRebirth");
            if (rebirthProc.Any())
            {
                rebirthProc[0].CloseMainWindow();
                Thread.Sleep(1000);
            }

            var basePath = args[0];
            var modNames = args[1];

            if (args.Length > 2)
            {
                ModPackager.LuaCompilerPath = args[2];
            }

            var baseDir = new DirectoryInfo(basePath);

            foreach (var mod in modNames.Split(','))
            {
                var modDir = new DirectoryInfo(string.Format(@"{0}\{1}", baseDir.FullName, mod));
                modDir = modDir = modDir.GetDirectories().SingleOrDefault(di => string.Compare(di.Name, "Extension", true) == 0) ?? modDir;

                ModPackager.PackageMod(mod, modDir);
            }

            var rebirthExe = Steam.Steam.GetXRebirthDirectory().GetFiles().Single(fi => fi.Name == "XRebirth.exe");
            ProcessStartInfo startInfo = new ProcessStartInfo();
            startInfo.FileName = rebirthExe.FullName;
            Process.Start(startInfo);
        }
    }
}
