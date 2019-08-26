package ui;

import haxe.ui.containers.Box;
import haxe.ui.containers.dialogs.Dialog.DialogButton;
import haxe.ui.containers.dialogs.Dialog.DialogEvent;
import haxe.ui.core.Component;
import haxe.ui.events.MouseEvent;
import projects.Project;
import sys.FileSystem;

@:build(haxe.ui.macros.ComponentMacros.build("assets/ui/project-tab.xml"))
class ProjectTab extends Box {
    public function new() {
        super();
    }
    
    @:bind(refreshReleases, MouseEvent.CLICK)
    private function onRefreshReleases(e) {
        refresh();
    }

    @:bind(refreshGitStatus, MouseEvent.CLICK)
    private function onRefreshGitStatus(e) {
        gitStatus.refresh();
    }

    @:bind(createNewRelease, MouseEvent.CLICK)
    private function onCreateNewRelease(e) {
        var dialog = new NewReleaseDialog();
        dialog.cleanUp = _project.cleanUpAfterRelease;
        dialog.autoSubmit = _project.automaticallySubmitToHaxelib;
        dialog.autoCommit = _project.commitAndPushHaxelibJson;
        dialog.populateUserInfo(_project);
        dialog.onDialogClosed = function(e:DialogEvent) {
            if (e.button == DialogButton.OK) {
                var version = StringTools.trim(dialog.releaseVersion);
                var notes = StringTools.trim(dialog.releaseNotes);
                if (version.length == 0) {
                    DialogHelper.message("No release version", "You must enter a version for the release", true);
                    return;
                }
                if (notes.length == 0) {
                    DialogHelper.message("No release notes", "You must enter notes for the release", true);
                    return;
                }
                ReleaseHelper.packageRelease(_project, version, notes);
                if (dialog.autoCommit == true) {
                    GitHelper.commitAndPush(_project, "haxelib.json", "haxelib");
                }
                if (dialog.autoSubmit == true) {
                    ReleaseHelper.submit(_project, dialog.releaseUser, dialog.releasePassword);
                }
                if (dialog.cleanUp == true) {
                    FileSystem.deleteFile(_project.folder + "/" + ReleaseHelper.zipFilename(_project));
                }
                
                _project.cleanUpAfterRelease = dialog.cleanUp;
                _project.automaticallySubmitToHaxelib = dialog.autoSubmit;
                _project.commitAndPushHaxelibJson = dialog.autoCommit;
                _project.lastUsedUser = dialog.releaseUser;
                Passwords.set(_project.lastUsedUser, dialog.releasePassword);
                
                refresh();
                gitStatus.refresh();
            }
        }
        dialog.show();
    }

    @:bind(projectSettings, MouseEvent.CLICK)
    private function onProjectSettings(e) {
        var dialog = new ProjectSettingsDialog();
        dialog.title = _project.label;
        dialog.inclusions = StringTools.replace(_project.inclusions, ",", "\n");
        dialog.exclusions = StringTools.replace(_project.exclusions, ",", "\n");
        dialog.onDialogClosed = function(e:DialogEvent) {
            if (e.button == DialogButton.SAVE) {
                _project.inclusions = dialog.inclusions;
                _project.exclusions = dialog.exclusions;
            }
        }
        dialog.show();
    }

    private var _project:Project;
    public var project(get, set):Project;
    private function get_project():Project {
        return _project;
    }
    private function set_project(value:Project):Project {
        _project = value;
        gitStatus.folder = _project.folder;
        refresh();
        return value;
    }
    
    public function refresh() {
        var info = HaxeLibHelper.remoteInfo(_project.id);
        
        // TODO: this isnt ideal - ScrollView::clear?
        var contents = projectReleases.findComponent("scrollview-contents", Component);
        if (contents != null) {
            contents.removeAllComponents();
        }
        
        var n = 0;
        for (release in info.releases) {
            var item = new ProjectListItem();
            item.date = release.date;
            item.time = release.time;
            item.version = release.version;
            item.notes = release.notes;
            projectReleases.addComponent(item);
            if (n % 2 != 0) {
                item.backgroundColor = 0xEEEEEE;
            }
            n++;
        }
    }
}

@:build(haxe.ui.macros.ComponentMacros.build("assets/ui/project-list-item.xml"))
class ProjectListItem extends Box {
    @:bind(releaseDate.text)        public var date:String;
    @:bind(releaseTime.text)        public var time:String;
    @:bind(releaseVersion.text)     public var version:String;
    @:bind(releaseNotes.text)       public var notes:String;
    
    public function new() {
        super();
        percentWidth = 100;
    }
}