package;
import haxe.ui.core.Screen;

class DialogHelper {
    public function new() {
    }
    
    public static function folder(title:String, message:String):String {
        #if haxeui_hxwidgets
        var dialog = new hx.widgets.DirDialog(Screen.instance.frame, title);
        if (dialog.showModal() == hx.widgets.StandardId.OK) {
            return dialog.path;
        }
        return null;
        #else
        return null;
        #end
    }
    
    public static function message(title:String, message:String, isError:Bool = false) {
        #if haxeui_hxwidgets
        if (isError == true) {
            var dialog = new hx.widgets.MessageDialog(Screen.instance.frame, message, title);
            dialog.showModal();
        } else {
            var dialog = new hx.widgets.MessageDialog(Screen.instance.frame, message, title, hx.widgets.styles.MessageDialogStyle.ICON_ERROR);
            dialog.showModal();
        }
        #else
        #end
    }
}