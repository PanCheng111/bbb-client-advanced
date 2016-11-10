package org.bigbluebutton.view.navigation.pages.whiteboard.toolbar
{
	import spark.components.VGroup;
	import spark.components.VSlider;
	import spark.primitives.Rect;
	
	import org.bigbluebutton.core.view.IView;
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
	
	public interface IWhiteboardToolbar extends IView
	{
		function get buttonList():VGroup;
		function get panzoomBtn():PanZoomButton;
		function get scribbleBtn():ScribbleButton;
		function get rectangleBtn():RectangleButton;
		function get circleBtn():CircleButton;
		function get triangleBtn():TriangleButton;
		function get lineBtn():LineButton;
		function get textBtn():TextButton;
		function get clearBtn():ClearButton;
		function get undoBtn():UndoButton;
		function get sld():VSlider;
		function get colorPicker():ColorPicker;
		function get background():Rect;
		function set showWhiteboardToolbar(x:Boolean): void;
		function get showWhiteboardToolbar():Boolean;
		
	}
}