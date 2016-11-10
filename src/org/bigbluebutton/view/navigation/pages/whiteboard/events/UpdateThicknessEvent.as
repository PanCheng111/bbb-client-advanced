// ActionScript file
package org.bigbluebutton.view.navigation.pages.whiteboard.events
{
	import flash.events.Event;
	
	public class UpdateThicknessEvent extends Event
	{
		public static const UPDATE_THICKNESS:String = "UpdateThickness";
		
		public var thickness:Number;
		
		public function UpdateThicknessEvent(type:String)
		{
			super(type, true, false);
		}
		
	}
}


