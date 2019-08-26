package;

import haxe.Json;
import projects.Project;
import sys.FileSystem;
import sys.io.File;

class ReleaseHelper {
    public static function packageRelease(project:Project, version:String, notes:String) {
        var inclusions = project.inclusions.split(",");
        var exclusions = project.exclusions.split(",");
        
        var filename = zipFilename(project);
        if (FileSystem.exists(project.folder + "/" + filename)) {
            FileSystem.deleteFile(project.folder + "/" + filename);
        }

        var cmd:Array<String> = ["7z", "a", filename];
        
        if (inclusions.length > 0) {
            for (i in inclusions) {
                cmd.push(i);
            }
            cmd.push("-r");
        }
        
        if (exclusions.length > 0) {
            for (e in exclusions) {
                cmd.push("-xr!" + e);
            }
        }
        
        updateHaxelibJson(project, version, notes);
        var output = ProcessHelper.exec(cmd.join(" "), project.folder);
        trace(output);
    }
    
    public static function submit(project:Project, username:String, password:String) {
        var filename = zipFilename(project);
        password = StringTools.replace(password, "\"", "\\\"");
        var cmd = "haxelib submit " + filename + " " + username + " " + password;
        var output = ProcessHelper.exec(cmd, project.folder);
        trace(output);
    }
    
    public static function updateHaxelibJson(project:Project, version:String, notes:String) {
        var filename = project.folder + "/haxelib.json";
        var json = Json.parse(File.getContent(filename));
        Reflect.setField(json, "version", version);
        Reflect.setField(json, "releasenote", notes);
        File.saveContent(filename, Json.stringify(json, "    "));
    }
    
    public static function zipFilename(project:Project) {
        return project.id + "-haxelib-release.zip";
    }
}