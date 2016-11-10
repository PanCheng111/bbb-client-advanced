package org.bigbluebutton.view.navigation.pages.whiteboard.toolbar
{
	import spark.components.VGroup;
	import spark.components.VSlider;
	import spark.primitives.Rect;
	
	import org.bigbluebutton.view.navigation.pages.whiteboard.WhiteboardCanvas;
	import org.bigbluebutton.view.navigation.pages.whiteboard.buttons.CircleButton;
	import org.bigbluebutton.view.navigation.pages.whiteboard.buttons.ClearButton;
	import org.bigbluebutton.view.navigation.pages.whiteboard.buttons.ColorPicker;
	import org.bigbluebutton.view.navigation.pages.whiteboard.buttons.LineButton;
	import org.bigbluebutton.view.navigation.pages.whiteboard.buttons.PanZoomButton;
	import org.bigbluebutton.view.navigation.pages.whiteboard.buttons.RectangleButton;
	import org.bigbluebutton.view.navigation.pages.whiteboard.buttons.ScribbleButton;
	import org.bigbluebutton.view.navigation.pages.whiteboard.buttons.TextButton;
	import org.bigbluebutton.view.navigation.pages.whiteboard.buttons.TriangleButton;
	import org.bigbluebutton.view.navigation.pages.whiteboard.buttons.UndoButton;

	public class WhiteboardToolbar extends WhiteboardToolbarBase implements IWhiteboardToolbar
	{
		
		public var canvas:WhiteboardCanvas;
		
		public function get panzoomBtn():PanZoomButton {
			return panzoomBtn0;
		}
		public function get scribbleBtn():ScribbleButton {
			return scribbleBtn0;
		}
		public function get rectangleBtn():RectangleButton {
			return rectangleBtn0;
		}
		public function get circleBtn():CircleButton {
			return circleBtn0;
		}
		public function get triangleBtn():TriangleButton {
			return triangleBtn0;
		}
		public function get lineBtn():LineButton {
			return lineBtn0;
		}
		public function get textBtn():TextButton {
			return textBtn0;
		}
		public function get clearBtn():ClearButton {
			return clearBtn0;
		}
		public function get undoBtn():UndoButton {
			return undoBtn0;
		}
		public function get sld():VSlider {
			return sld0;
		}
		
		public function get background():Rect {
			return background0;
		}
		
		public function get showWhiteboardToolbar():Boolean {
			return showWhiteboardToolbar0;
		}
		public function set showWhiteboardToolbar(x:Boolean):void {
			showWhiteboardToolbar0 = x;
		}
		public function get buttonList():VGroup {
			return buttonList0;
		}
		
		public function get colorPicker():ColorPicker {
			return colorPicker0;
		}
		public function dispose():void {
			
		}
	}
}