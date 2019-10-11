package;

import haxe.ui.containers.Box;
import haxe.ui.containers.dialogs.Dialog.DialogEvent;
import haxe.ui.containers.menus.Menu.MenuEvent;
import projects.Project;
import ui.MultiSubmitDialog;
import ui.ProjectTab;

@:build(haxe.ui.macros.ComponentMacros.build("assets/main.xml"))
class MainView extends Box {
    public function new() {
        super();
        percentWidth = 100;
        percentHeight = 100;
        AppData.instance.registerEvent(AppEvent.PROJECT_ADDED, onProjectAdded);
        AppData.instance.loadData();
    }
    
    @:bind(mainMenu, MenuEvent.MENU_SELECTED)
    private function onMainMenu(event:MenuEvent) {
        switch (event.menuItem.id) {
            case "addProject":
                var projectFolder = DialogHelper.folder("Add Project", "Select the root folder of the project");
                if (projectFolder != null) {
                    try { 
                        AppData.instance.loadProject(projectFolder);
                    } catch (e:Dynamic) {
                        DialogHelper.message("Add Project", e, true);
                    }
                }
            case "submitMultiple":
                var multiSubmitDialog = new MultiSubmitDialog();
                multiSubmitDialog.onDialogClosed = function(e:DialogEvent) {
                    if (e.button == "Submit Multiple") {
                        var submitInfo:MultiSubmitInfo = multiSubmitDialog.submitInfo;
                        for (item in submitInfo.items) {
                            var project = AppData.instance.findProject(item.projectId);
                            ReleaseHelper.performRelease(project, item.version, item.notes, submitInfo.user, submitInfo.password, submitInfo.commit, submitInfo.submit, submitInfo.clean);
                        }
                    }
                }
                multiSubmitDialog.show();
        }
    }
    
    private function onProjectAdded(event:AppEvent) {
        var tab = createProjectTab(event.project);
        mainTabs.addComponent(tab);
    }
    
    private function createProjectTab(project:Project):ProjectTab {
        var tab = new ProjectTab();
        tab.percentWidth = 100;
        tab.percentHeight = 100;
        tab.text = project.label;
        tab.icon = "icons/folder-horizontal.png";
        tab.project = project;
        return tab;
    }
}