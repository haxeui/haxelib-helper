package ui;

import haxe.ui.containers.dialogs.Dialog;
import haxe.ui.data.ArrayDataSource;
import projects.Project;

@:build(haxe.ui.macros.ComponentMacros.build("assets/ui/new-release-dialog.xml"))
class NewReleaseDialog extends Dialog {
    @:bind(version.text)        public var releaseVersion:String;
    @:bind(notes.text)          public var releaseNotes:String;
    @:bind(user.selectedItem)   public var releaseUser:String;
    @:bind(password.text)       public var releasePassword:String;
    @:bind(clean.selected)      public var cleanUp:Bool;
    @:bind(submit.selected)     public var autoSubmit:Bool;
    @:bind(commit.selected)     public var autoCommit:Bool;
    
    public function new() {
        super();
        title = "Create New Release";
        buttons = DialogButton.CANCEL | DialogButton.OK;
        addClass("custom-dialog-footer");
    }
    
    public function populateUserInfo(project:Project) {
        var info = HaxeLibHelper.localInfo(project.folder);
        var ds = new ArrayDataSource<String>();
        var n = 0;
        var i = 0;
        for (c in info.contributors) {
            ds.add(c);
            if (c == project.lastUsedUser) {
                n = i;
            }
            i++;
        }
        user.dataSource = ds;
        user.selectedIndex = n;
        
        if (project.lastUsedUser != null) {
            var password = Passwords.get(project.lastUsedUser);
            if (password != null) {
                releasePassword = password;
            }
        }
    }
}