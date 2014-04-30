using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Packaging.Mods;

namespace Packaging
{
    public class Program
    {
        public static void Main(string[] args)
        {
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
                if (modDir.GetDirectories().Any(di => di.Name == "Extension"))
                {
                    modDir = modDir.GetDirectories().Single(di => di.Name == "Extension");
                }

                ModPackager.PackageMod(mod, modDir);
            }
        }
    }
}
