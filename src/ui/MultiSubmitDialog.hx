package ui;

import haxe.ui.containers.Box;
import haxe.ui.containers.dialogs.Dialog;
import haxe.ui.data.ArrayDataSource;
import haxe.ui.events.MouseEvent;

typedef SubmitInfo = {
    var projectId:String;
    var version:String;
    var notes:String;
}

typedef MultiSubmitInfo = {
    var user:String;
    var password:String;
    var clean:Bool;
    var submit:Bool;
    var commit:Bool;
    var items:Array<SubmitInfo>;
}

@:build(haxe.ui.macros.ComponentMacros.build("assets/ui/multi-submit-dialog.xml"))
class MultiSubmitDialog extends Dialog {
    public function new() {
        super();
        width = 600;
        title = "Submit Multiple Haxelibs";
        buttons = DialogButton.CLOSE | "Submit Multiple";
        #if haxeui_hxwidgets
        if (new hx.widgets.PlatformInfo().isWindows == true) {
            addClass("custom-dialog-footer");
        }
        #end
    }

    @:bind(addProject, MouseEvent.CLICK)
    private function onAddProject(e) {
        var item = createProjectItem();
        projectList.addComponent(item);
    }
    
    private function createProjectItem():MultiSubmitItem {
        var item = new MultiSubmitItem();
        return item;
    }
    
    public var submitInfo(get, null):MultiSubmitInfo;
    private function get_submitInfo():MultiSubmitInfo {
        var items = projectList.findComponents(MultiSubmitItem);
        var submitItems:Array<SubmitInfo> = [];
        for (item in items) {
            if (item.projectName.selectedItem == null) {
                DialogHelper.message("No project", "You must select a project to use", true);
                return null;
            }
            if (StringTools.trim(item.projectVersion.text) == "") {
                DialogHelper.message("No release version", "You must enter a version for the release", true);
                return null;
            }
            if (StringTools.trim(item.projectNotes.text) == "") {
                DialogHelper.message("No release notes", "You must enter notes for the release", true);
                return null;
            }
            
            submitItems.push({
                projectId: item.projectName.selectedItem.id,
                version: item.projectVersion.text,
                notes: item.projectNotes.text
            });
        }
        
        if (submitItems.length == 0) {
            DialogHelper.message("No projects", "You must add at least one project", true);
            return null;
        }
        
        return {
            user: user.text,
            password: password.text,
            clean: clean.selected,
            submit: submit.selected,
            commit: commit.selected,
            items: submitItems
        };
    }
}

@:build(haxe.ui.macros.ComponentMacros.build("assets/ui/multi-submit-item.xml"))
private class MultiSubmitItem extends Box {
    public function new() {
        super();
        percentWidth = 100;
        populateProjects();
    }
    
    private function populateProjects() {
        var ds = new ArrayDataSource<Dynamic>();
        for (p in AppData.instance.projects) {
            ds.add({
                value: p.label,
                id: p.id
            });
        }
        
        projectName.dataSource = ds;
    }
}