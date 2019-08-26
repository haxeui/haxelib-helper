package projects;

class HaxeLibInfo {
    public var properties:Map<String, Any> = new Map<String, Any>();
    public var releases:Array<HaxeLibReleaseInfo> = [];
 
    public function new() {
    }

    public var contributors(get, null):Array<String>;
    private function get_contributors():Array<String> {
        var c = properties.get("contributors");
        if (c == null) {
            return [];
        }
        var a:Array<String> = c;
        return a;
    }
    
    public function addRelease(date:String, time:String, version:String, notes:String) {
        var release = new HaxeLibReleaseInfo();
        release.date = date;
        release.time = time;
        release.version = version;
        release.notes = notes;
        releases.push(release);
    }
}

class HaxeLibReleaseInfo {
    public var date:String;
    public var time:String;
    public var version:String;
    public var notes:String;
    
    public function new() {
    }
}