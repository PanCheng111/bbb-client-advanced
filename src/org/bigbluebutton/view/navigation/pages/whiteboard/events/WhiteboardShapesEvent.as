package org.bigbluebutton.view.navigation.pages.whiteboard.events
{
  import flash.events.Event;
  
  public class WhiteboardShapesEvent extends Event
  {
    
    public static const SHAPES_EVENT:String = "whiteboard shapes history event";
    
    public var whiteboardId:String;
    
    public function WhiteboardShapesEvent(wbId:String)
    {
      super(SHAPES_EVENT, true, false);
      whiteboardId = wbId;
    }
  }
}