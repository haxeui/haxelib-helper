package;
import haxe.ui.events.UIEvent;
import projects.Project;

class AppEvent extends UIEvent {
    public static inline var PROJECT_ADDED:String = "projectAdded";
    
    public var project:Project = null;
    
    public override function clone():AppEvent {
        var c:AppEvent = new AppEvent(this.type);
        c.type = this.type;
        c.project = this.project;
        return c;
    }
}