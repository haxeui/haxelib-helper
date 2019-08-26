package;

import haxe.ui.containers.Box;
import haxe.ui.containers.menus.Menu.MenuEvent;
import projects.Project;
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