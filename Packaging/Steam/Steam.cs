using System;
using System.IO;
using System.Linq;
using Microsoft.Win32;

namespace Packaging.Steam
{
    public static class Steam
    {
        public static string path = null;

        public static string Path
        {
            get
            {
                if (path == null)
                {
                    RegistryKey regKey = Registry.CurrentUser;
                    regKey = regKey.OpenSubKey(@"Software\Valve\Steam");

                    if (regKey == null)
                    {
                        throw new Exception("Could not find Steam directory!");
                    }

                    path = regKey.GetValue("SteamPath").ToString();
                }

                return path;
            }
        }

        public static DirectoryInfo GetXRebirthDirectory()
        {
            return new DirectoryInfo(string.Format(@"{0}\{1}", Steam.Path, @"steamapps\common\X Rebirth"));
        }

        public static DirectoryInfo GetXRebirthModDirectory(string modName)
        {
            var extensionsDirPath = string.Format(@"{0}\{1}\{2}", GetXRebirthDirectory().FullName, "extensions", modName);
            var di = new DirectoryInfo(extensionsDirPath);
            if (!di.Exists)
            {
                di.Create();
            }
            return di;
        }

        public static DirectoryInfo GetXRebirthToolsDirectory()
        {
            var toolsDirPath = string.Format(@"{0}\{1}", Steam.Path, @"steamapps\common\X Rebirth Tools");
            return new DirectoryInfo(toolsDirPath);
        }

        public static FileInfo GetXRebirthCatTool()
        {
            return GetXRebirthToolsDirectory().GetFiles().Single(fi => fi.Name == "XRCatTool.exe");
        }
    }
}
