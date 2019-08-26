package;

import haxe.Json;
import haxe.ui.events.UIEvent;
import haxe.ui.util.EventMap;
import projects.Project;
import sys.FileSystem;
import sys.io.File;

class AppData {
    private static var _instance:AppData;
    public static var instance(get, null):AppData;
    private static function get_instance():AppData {
        if (_instance == null) {
            _instance = new AppData();
        }
        return _instance;
    }

    private var _data:Dynamic = {};
    private var _eventMap:EventMap = new EventMap();
    public function new() {
    }
    
    public function registerEvent(type:String, listener:Dynamic) {
        _eventMap.add(type, listener);
    }
    
    public function loadData() {
        if (FileSystem.exists("data.json")) {
            var content = File.getContent("data.json");
            _data = Json.parse(content);
            
            if (_data.projects != null) {
                var projects:Array<Dynamic> = _data.projects;
                for (p in projects) {
                    var projectFolder = p.folder;
                    if (p.folder != null) {
                        var project = loadProject(projectFolder, false);
                        if (p.inclusions != null) {
                            project.inclusions = p.inclusions;
                        }
                        if (p.exclusions != null) {
                            project.exclusions = p.exclusions;
                        }
                        if (p.cleanUpAfterRelease != null) {
                            project.cleanUpAfterRelease = p.cleanUpAfterRelease;
                        }
                        if (p.automaticallySubmitToHaxelib != null) {
                            project.automaticallySubmitToHaxelib = p.automaticallySubmitToHaxelib;
                        }
                        if (p.commitAndPushHaxelibJson != null) {
                            project.commitAndPushHaxelibJson = p.commitAndPushHaxelibJson;
                        }
                        if (p.lastUsedUser != null) {
                            project.lastUsedUser = p.lastUsedUser;
                        }
                    }
                }
            }
        }
    }
    
    public function saveData() {
        var content = Json.stringify(_data, "  ");
        File.saveContent("data.json", content);
    }
    
    public var projects:Array<Project> = [];
    public function loadProject(folder:String, save:Bool = true):Project {
        for (p in projects) {
            if (p.folder == folder) {
                throw "Project already exists at " + p.folder;
            }
        }
        
        trace("Loading project from: " + folder);
        var project = Project.fromFolder(folder);
        if (project == null) {
            return null;
        }
        projects.push(project);
        
        if (save == true) {
            if (_data.projects == null) {
                _data.projects = [];
            }
            
            var projectData:Dynamic = {};
            projectData.folder = project.folder;
            _data.projects.push(projectData);
            saveData();
        }
        
        var event = new AppEvent(AppEvent.PROJECT_ADDED);
        event.project = project;
        _eventMap.invoke(AppEvent.PROJECT_ADDED, event);
        
        return project;
    }
    
    public function findProject(projectId:String):Project {
        for (p in projects) {
            if (p.id == projectId) {
                return p;
            }
        }
        return null;
    }
    
    public function setProjectProperty(projectId:String, propName:String, propValue:Any) {
        var project = findProject(projectId);
        if (project == null) {
            throw "Project not found: " + projectId;
        }
        
        if (_data.projects != null) {
            var projects:Array<Dynamic> = _data.projects;
            for (p in projects) {
                if (p.folder != null && p.folder == project.folder) {
                    Reflect.setField(p, propName, propValue);
                    saveData();
                    break;
                }
            }
        }
    }
}