package ui;
import haxe.ui.containers.dialogs.Dialog;

@:build(haxe.ui.macros.ComponentMacros.build("assets/ui/project-settings-dialog.xml"))
class ProjectSettingsDialog extends Dialog {
    @:bind(inclusionsList.text)     public var inclusions:String;
    @:bind(exclusionsList.text)     public var exclusions:String;
    
    public function new() {
        super();
        width = 400;
        buttons = DialogButton.CLOSE | DialogButton.SAVE;
        #if haxeui_hxwidgets
        if (new hx.widgets.PlatformInfo().isWindows == true) {
            addClass("custom-dialog-footer");
        }
        #end
    }
}
