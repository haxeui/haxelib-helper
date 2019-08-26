package projects;
import haxe.io.Path;

class Project {
    public var id:String;
    public var label:String;
    public var folder:String;
    
    public function new() {
    }

    private var _lastUsedUser:String = null;
    public var lastUsedUser(get, set):String;
    private function get_lastUsedUser():String {
        return _lastUsedUser;
    }
    private function set_lastUsedUser(value:String):String {
        _lastUsedUser = value;
        AppData.instance.setProjectProperty(id, "lastUsedUser", _lastUsedUser);
        return value;
    }
    
    private var _cleanUpAfterRelease:Bool = false;
    public var cleanUpAfterRelease(get, set):Bool;
    private function get_cleanUpAfterRelease():Bool {
        return _cleanUpAfterRelease;
    }
    private function set_cleanUpAfterRelease(value:Bool):Bool {
        _cleanUpAfterRelease = value;
        AppData.instance.setProjectProperty(id, "cleanUpAfterRelease", _cleanUpAfterRelease);
        return value;
    }
    
    private var _automaticallySubmitToHaxelib:Bool = false;
    public var automaticallySubmitToHaxelib(get, set):Bool;
    private function get_automaticallySubmitToHaxelib():Bool {
        return _automaticallySubmitToHaxelib;
    }
    private function set_automaticallySubmitToHaxelib(value:Bool):Bool {
        _automaticallySubmitToHaxelib = value;
        AppData.instance.setProjectProperty(id, "automaticallySubmitToHaxelib", _automaticallySubmitToHaxelib);
        return value;
    }
    
    private var _commitAndPushHaxelibJson:Bool = false;
    public var commitAndPushHaxelibJson(get, set):Bool;
    private function get_commitAndPushHaxelibJson():Bool {
        return _commitAndPushHaxelibJson;
    }
    private function set_commitAndPushHaxelibJson(value:Bool):Bool {
        _commitAndPushHaxelibJson = value;
        AppData.instance.setProjectProperty(id, "commitAndPushHaxelibJson", _commitAndPushHaxelibJson);
        return value;
    }
    
    private var _inclusions:String;
    public var inclusions(get, set):String;
    private function get_inclusions():String {
        return _inclusions;
    }
    public function set_inclusions(value:String):String {
        _inclusions = sanitizeList(value);
        AppData.instance.setProjectProperty(id, "inclusions", _inclusions);
        return value;
    }
    
    private var _exclusions:String;
    public var exclusions(get, set):String;
    private function get_exclusions():String {
        return _exclusions;
    }
    public function set_exclusions(value:String):String {
        _exclusions = sanitizeList(value);
        AppData.instance.setProjectProperty(id, "exclusions", _exclusions);
        return value;
    }

    public function load() {
        var path = new Path(folder);
        id = path.file;
        label = path.file;
    }
    
    public static function fromFolder(folder:String):Project {
        var p = new Project();
        p.folder = folder;
        p.load();
        return p;
    }
    
    public static function sanitizeList(value:String):String {
        value = StringTools.replace(value, "\r\n", " ");
        value = StringTools.replace(value, "\r", " ");
        value = StringTools.replace(value, "\n", " ");
        var list = value.split(" ");
        var temp = [];
        for (l in list) {
            l = StringTools.trim(l);
            if (l.length == 0) {
                continue;
            }
            temp.push(l);
        }
        value = temp.join(",");
        return value;
    }
}