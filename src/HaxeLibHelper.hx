package;

import haxe.Json;
import projects.HaxeLibInfo;
import sys.io.File;

class HaxeLibHelper {
    public static function localInfo(folder:String):HaxeLibInfo {
        var info = new HaxeLibInfo();
        var filename = folder + "/haxelib.json";
        var json = Json.parse(File.getContent(filename));
        for (f in Reflect.fields(json)) {
            info.properties.set(f, Reflect.field(json, f));
        }
        return info;
    }
    
    public static function remoteInfo(id:String):HaxeLibInfo {
        var output = ProcessHelper.exec("haxelib info " + id);
        var lines = output.split("\n");
        var inReleases:Bool = false;
        var info = new HaxeLibInfo();
        for (line in lines) {
            line = StringTools.trim(line);
            if (line.length == 0) {
                continue;
            }
            
            var parts = line.split(" ");
            if (parts[0] == "Releases:") {
                inReleases = true;
            } else if (inReleases == true) {
                var date = parts.shift();
                var time = parts.shift();
                var version = parts.shift();
                parts.shift(); // skip colon
                var notes = parts.join(" ");
                info.addRelease(date, time, version, notes);
            } else {
                var propName = parts.shift();
                propName = propName.substr(0, propName.length - 1);
                var propValue = StringTools.trim(parts.join(" "));
                propValue = StringTools.trim(propValue);
                info.properties.set(propName, propValue);
            }
        }
        
        info.releases.reverse();
        
        return info;
    }
}