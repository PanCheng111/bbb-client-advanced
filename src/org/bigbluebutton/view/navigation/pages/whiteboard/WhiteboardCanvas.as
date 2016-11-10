package org.bigbluebutton.view.navigation.pages.whiteboard
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import spark.components.Group;
	
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.whiteboard.WhiteboardCanvasModel;
	import org.bigbluebutton.modules.whiteboard.business.shapes.DrawObject;
	import org.bigbluebutton.modules.whiteboard.business.shapes.WhiteboardConstants;
	import org.bigbluebutton.modules.whiteboard.events.WhiteboardButtonEvent;
	import org.bigbluebutton.modules.whiteboard.events.WhiteboardDrawEvent;
	import org.bigbluebutton.modules.whiteboard.models.Annotation;
//	import com.asfusion.mate.events.Dispatcher;
	
	
	public class WhiteboardCanvas extends WhiteboardCanvasBase implements IWhiteboardCanvas
	{
		private var _resizeCallback:Function;
		
		//public var model:WhiteboardCanvasModel;
		private var _toolType:String = DrawObject.PENCIL;
		private var _whiteboardEnabled:Boolean = false;
		private var _showWhiteboard:Boolean = true;
		private var _xPosition:int;
		private var _yPosition:int;
		
		[Inject]
		public var userSession: IUserSession;
		
		public function WhiteboardCanvas()
		{
			super();
			//this.label = "Highlighter";
			//model = new WhiteboardCanvasModel();
		}
		
		public function get resizeCallback():Function {
			return _resizeCallback;
		}
		
		public function set resizeCallback(callback:Function):void {
			_resizeCallback = callback;
		}
		
		public function moveCanvas(x:Number, y:Number, width:Number, height:Number, zoom:Number):void {
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			
			if (_resizeCallback != null)
				callLater(_resizeCallback, [zoom]);
		}
		
		public function get xPosition():int {
			return _xPosition;
		}
		
		public function get yPosition():int {
			return _yPosition;
		}
		
		public function set xPosition(x:int):void {
			_xPosition = x;
		}
		
		public function set yPosition(y:int):void {
			_yPosition = y;
		}
		
		public function get toolType():String {
			return _toolType;
		}
		public function set toolType(x:String):void {
			_toolType = x;
		}
		public function get whiteboardEnabled():Boolean {
			return _whiteboardEnabled;
		}
		public function set whiteboardEnabled(x:Boolean):void {
			_whiteboardEnabled = x;
		}
		public function get showWhiteboard():Boolean {
			return _showWhiteboard;
		}
		public function set showWhiteboard(x:Boolean):void {
			_showWhiteboard = x;
		}
		
//		public function get whiteboardcanvas():Group {
//			return whiteboardcanvas0;
//		}
		
		public function getMouseXY():Array {
			return [Math.min(Math.max(parent.mouseX, 0), parent.width-2) - this.x, Math.min(Math.max(parent.mouseY, 0), parent.height-2) - this.y];
		}
		
		public function sendGraphicToServer(gobj:Annotation, type:String):void {
			//               LogUtil.debug("DISPATCHING SEND sendGraphicToServer [" + type + "]");
			var event:WhiteboardDrawEvent = new WhiteboardDrawEvent(type);
			event.annotation = gobj;
			//var dispatcher:Dispatcher = new Dispatcher();
			dispatchEvent(event);					
		}
		
		public function dispose():void
		{
		}
	}
}