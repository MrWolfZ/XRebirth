using System;
using System.Collections.Generic;
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
            Console.WriteLine("Packaging mod {0}...", modName);

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

            // TODO: make generic to scan mutliple locations for lua files to compile
            // compile the UI
            var uiFiles = extensionDir.EnumerateFiles("*.lua", SearchOption.AllDirectories);
            var uiDirectories = uiFiles.Select(f => f.Directory).Distinct(new DirectoryByNameComparer());
            foreach (var uiDir in uiDirectories)
            {
                var outputDir = string.Compare(uiDir.Name, "sources", true) == 0 ? null : uiDir.FullName;
                lua.Compile(uiDir.FullName, outputDir);
            }

            Console.WriteLine("Packaging UI...");

            // package the UI
            packager.Package(extensionDir.FullName, modDir.FullName, "subst_01.cat", @"^.*\.xpl$");

            Console.WriteLine("Packaging Scripts...");

            // package the scripts
            packager.Package(extensionDir.FullName, modDir.FullName, "ext_01.cat", @"^.*(\.xml|\.txt)$", "^.*content.xml$");

            Console.WriteLine("Finished packaging mod!");
        }

        private class DirectoryByNameComparer : IEqualityComparer<DirectoryInfo>
        {
            public bool Equals(DirectoryInfo x, DirectoryInfo y)
            {
                return x.FullName.Equals(y.FullName);
            }

            public int GetHashCode(DirectoryInfo obj)
            {
                return obj.FullName.GetHashCode();
            }
        }
    }
}
