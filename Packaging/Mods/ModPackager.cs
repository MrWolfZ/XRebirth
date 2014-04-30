using System;
using System.IO;
using System.Linq;
using Packaging.Cat;
using Packaging.Lua;

namespace Packaging.Mods
{
    public static class ModPackager
    {
        private static string luaPath = @"F:\X Rebirth Modding\LuaJIT-2.0.3\src\luajit.exe";

        public static string LuaCompilerPath
        {
            get
            {
                return luaPath;
            }

            set
            {
                luaPath = value;
            }
        }

        public static void PackageMod(string modName, DirectoryInfo extensionDir)
        {
            var packager = new CatPackager(Steam.Steam.GetXRebirthCatTool().FullName);
            var lua = new LuaCompiler(LuaCompilerPath);
            var modDir = Steam.Steam.GetXRebirthModDirectory(modName);

            Console.WriteLine("Fetching content descriptor...");

            var contentDescriptor = extensionDir.GetFiles().SingleOrDefault(fi => fi.Name == "content.xml");

            if (contentDescriptor == null)
            {
                throw new Exception("Mod must have a content.xml");
            }

            var contentDescriptorOutput = string.Format(@"{0}\{1}", modDir.FullName, "content.xml");

            Console.WriteLine("Fetching readMe...");

            var readme = extensionDir.GetFiles().SingleOrDefault(fi => fi.Name == "README.txt");
            var readmeOutput = string.Format(@"{0}\{1}", modDir.FullName, "README.txt");

            Console.WriteLine("Copying base files...");

            File.Copy(contentDescriptor.FullName, contentDescriptorOutput, true);
            if (readme != null)
            {
                File.Copy(readme.FullName, readmeOutput, true);
            }

            Console.WriteLine("Compiling UI...");

            // compile the UI
            lua.Compile(string.Format(@"{0}\ui\addons\detailmonitor\sources", extensionDir.FullName));

            Console.WriteLine("Packaging UI...");

            // package the UI
            packager.Package(extensionDir.FullName, modDir.FullName, "subst_01.cat", @"^.*\.xpl$");

            Console.WriteLine("Packaging Scripts...");

            // package the scripts
            packager.Package(extensionDir.FullName, modDir.FullName, "ext_01.cat", @"^.*\.xml$", "^.*content.xml$");

            Console.WriteLine("Finished packaging mod!");
        }
    }
}
