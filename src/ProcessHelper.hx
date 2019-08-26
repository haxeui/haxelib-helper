package;

import haxe.io.Bytes;
import sys.io.Process;

class ProcessHelper {
    public static function exec(cmd:String, cwd:String = null):String {
        var oldCwd = Sys.getCwd();
        if (cwd != null) {
            Sys.setCwd(cwd);
        }
        
        trace("executing: " + cmd + " in folder: " + cwd);
        var p = new Process(cmd, null, false);
        var stdout:String = p.stdout.readAll().toString();
        var stderr:String = p.stderr.readAll().toString();
        if (stderr != null) {
            trace(stderr);
        }

        Sys.setCwd(oldCwd);
        
        return stdout;
    }
}