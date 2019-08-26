package ui;
import haxe.ui.containers.Box;
import haxe.ui.data.ArrayDataSource;

@:build(haxe.ui.macros.ComponentMacros.build("assets/ui/git-status.xml"))
class GitStatus extends Box {
    public function new() {
        super();
    }
    
    private var _folder:String;
    public var folder(get, set):String;
    public function get_folder() {
        return _folder;
    }
    public function set_folder(value:String):String {
        if (_folder == value) {
            return value;
        }
        _folder = value;
        refresh();
        return value;
    }
    
    
    public function refresh() {
        trace("refreshing: " + _folder);
        var output = ProcessHelper.exec("git status --porcelain", _folder);
        var lines = output.split("\n");
        var ds:ArrayDataSource<Dynamic> = new ArrayDataSource<Dynamic>();
        for (line in lines) {
            if (StringTools.trim(line).length == 0) {
                continue;
            }
            
            var status = line.substr(0, 2);
            var file = StringTools.trim(line.substr(2));
            var icon = "icons/question-button.png";
            switch (status.charAt(1)) {
                case "?": //untracked
                    icon = "icons/question-button.png";
                case "M": // modified
                    icon = "icons/pencil-button.png";
                case "A": // added
                    icon = "icons/plus-button.png";
                case "D": // deleted
                    icon = "icons/minus-button.png";
                case "R": // renamed
                    icon = "icons/pencil-button.png";
                case "C": // copied
                    icon = "icons/pencil-button.png";
                case "U": // updated but unmerged
                    icon = "icons/pencil-button.png";
            }
            
            ds.add({
                value: file,
                icon: icon
            });
        }
        fileStatus.dataSource = ds;
    }
}