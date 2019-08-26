package;

class DialogHelper {
    public function new() {
    }
    
    public static function folder(title:String, message:String):String {
        #if systools
        return systools.Dialogs.folder(title, message);
        #else
        return null;
        #end
    }
    
    public static function message(title:String, message:String, isError:Bool = false) {
        #if systools
        return systools.Dialogs.message(title, message, isError);
        #else
        return null;
        #end
    }
}