/**
* BigBlueButton open source conferencing system - http://www.bigbluebutton.org/
* 
* Copyright (c) 2012 BigBlueButton Inc. and by respective authors (see below).
*
* This program is free software; you can redistribute it and/or modify it under the
* terms of the GNU Lesser General Public License as published by the Free Software
* Foundation; either version 3.0 of the License, or (at your option) any later
* version.
* 
* BigBlueButton is distributed in the hope that it will be useful, but WITHOUT ANY
* WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
* PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public License along
* with BigBlueButton; if not, see <http://www.gnu.org/licenses/>.
*
*/
package org.bigbluebutton.view.navigation.pages.whiteboard.events
{
	import flash.events.Event;
	
	import org.bigbluebutton.model.whiteboard.DrawObject;
	import org.bigbluebutton.model.whiteboard.GraphicObject;
	import org.bigbluebutton.model.whiteboard.Annotation;
	
	public class WhiteboardDrawEvent extends Event
	{
		public static const SEND_SHAPE:String = "sendShape";
		public static const SEND_TEXT:String = "sendText";
		public static const CLEAR:String = "WhiteboardClearCommand";
		public static const UNDO:String = "WhiteboardUndoCommand";
		public static const NEW_SHAPE:String = "NewShapeEvent";	
        
   		public static const GET_ANNOTATION_HISTORY:String = "WhiteboardGetAnnotationHistory";
		
		public var annotation:Annotation;
		       
		public function WhiteboardDrawEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}

	}
}