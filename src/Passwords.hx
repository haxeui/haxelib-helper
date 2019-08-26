package;

class Passwords {
    private static var _cache:Map<String, String> = new Map<String, String>();
    
    public static function get(username:String):String {
        return _cache.get(username);
    }
    
    public static function set(username:String, password:String) {
        _cache.set(username, password);
    }
}