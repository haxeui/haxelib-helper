package;
import projects.Project;

class GitHelper {
    public static function commitAndPush(project:Project, files:String, message:String) {
        var cmd = "git commit -m " + message + " " + files;
        var output = ProcessHelper.exec(cmd, project.folder);
        trace(output);
    }
}