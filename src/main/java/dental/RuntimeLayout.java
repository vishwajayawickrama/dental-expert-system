package dental;

import org.jpl7.JPL;
import java.nio.file.*;
import java.util.*;

/** Locates relocatable vendor runtimes without using a machine's Prolog installation. */
final class RuntimeLayout {
    static Path applicationRoot() throws Exception {
        String explicit=System.getProperty("dental.home");
        if(explicit!=null)return Path.of(explicit).toAbsolutePath().normalize();
        Path code=Path.of(RuntimeLayout.class.getProtectionDomain().getCodeSource().getLocation().toURI());
        return (Files.isDirectory(code)?code:code.getParent()).toAbsolutePath().normalize();
    }
    static String platform(String os,String arch){
        boolean x64=Set.of("amd64","x86_64").contains(arch.toLowerCase(Locale.ROOT));
        boolean arm=Set.of("aarch64","arm64").contains(arch.toLowerCase(Locale.ROOT));
        if(os.startsWith("Mac")&&arm)return "macos-arm64";
        if(os.startsWith("Windows")&&x64)return "windows-x64";
        if(os.startsWith("Linux")&&x64)return "linux-x64";
        throw new IllegalStateException("Unsupported platform: "+os+" / "+arch+". Use macOS ARM64, Windows x64 or Ubuntu 24.04 x64 package.");
    }
    static Path find(Path root,String name) throws Exception {
        try(var paths=Files.walk(root)){
            return paths.filter(p->Files.isRegularFile(p)&&p.getFileName().toString().equals(name))
                .sorted(Comparator.comparingInt(Path::getNameCount)).findFirst()
                .orElseThrow(()->new IllegalStateException("Missing bundled dependency: "+name+" in "+root+". Extract the complete platform package."));
        }
    }
    static void initialize(Path root) throws Exception {
        String platform=platform(System.getProperty("os.name"),System.getProperty("os.arch"));
        Path runtime=root.resolve("runtime/prolog");
        if(!Files.isDirectory(runtime))runtime=root.resolve("runtime");
        if(!Files.isDirectory(runtime))runtime=root.resolve(platform.equals("macos-arm64")?".runtime/SWI-Prolog.app/Contents":".runtime/prolog");
        if(!Files.isDirectory(runtime))throw new IllegalStateException("Bundled Prolog runtime missing in "+root+". Extract the complete "+platform+" package.");
        Path jvm=Path.of(System.getProperty("java.home"),platform.equals("windows-x64")?"bin/server/jvm.dll":platform.equals("macos-arm64")?"lib/server/libjvm.dylib":"lib/server/libjvm.so");
        System.load(jvm.toString());
        String core,jpl;
        if(platform.equals("macos-arm64")){
            System.load(find(runtime,"libgmp.10.dylib").toString());
            System.load(find(runtime,"libz.1.dylib").toString());
            core="libswipl.10.dylib";jpl="libjpl.dylib";
        }else if(platform.equals("windows-x64")){
            core="libswipl.dll";jpl="jpl.dll";
        }else{core="libswipl.so";jpl="libjpl.so";}
        System.load(find(runtime,core).toString());
        JPL.setNativeLibraryPath(find(runtime,jpl).toString());
        Path boot=find(runtime,"boot.prc"),home=boot.getParent();
        if(!Files.isRegularFile(root.resolve("knowledge/engine.pl")))throw new IllegalStateException("Knowledge files missing in "+root+". Keep the complete application folder together.");
        JPL.setDefaultInitArgs(new String[]{"swipl","--quiet","--nosignals","--home="+home,"-x",boot.toString()});
        if(!JPL.init()&&JPL.getActualInitArgs()==null)throw new IllegalStateException("SWI-Prolog initialization failed");
    }
}
