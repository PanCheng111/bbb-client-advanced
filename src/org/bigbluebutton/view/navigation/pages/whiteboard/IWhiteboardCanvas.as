package org.bigbluebutton.view.navigation.pages.whiteboard
{
	//import spark.display.DisplayObjectContainer;
	import flash.display.DisplayObjectContainer;
	
	import mx.core.IVisualElement;
	
	import spark.components.Group;
	
	import org.bigbluebutton.core.view.IView;
	import org.bigbluebutton.modules.whiteboard.business.shapes.DrawObject;
	
	public interface IWhiteboardCanvas extends IView
	{
		function set resizeCallback(callback:Function):void;
		function get resizeCallback():Function;
		function get width():Number;
		function get height():Number;
		function set width(v:Number):void;
		function set height(v:Number):void;
		function get parent():DisplayObjectContainer;
		function addElement(element:IVisualElement):IVisualElement;
		function removeElement(element:IVisualElement):IVisualElement;
		function removeAllElements():void;
		function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void;
		function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void;
		function containsElement(element:IVisualElement):Boolean;
		function get mouseX():Number;
		function get mouseY():Number;
		function get x():Number;
		function get y():Number;
		function get xPosition():int;
		function get yPosition():int;
		function set visible(v:Boolean):void;
		function set xPosition(x:int):void;
		function set yPosition(y:int):void;
		function get toolType():String;
		function set toolType(x:String):void;
		function get whiteboardEnabled():Boolean;
		function set whiteboardEnabled(x:Boolean):void;
		function set useHandCursor(v:Boolean):void;
		function get showWhiteboard():Boolean;
		function set showWhiteboard(x:Boolean):void;
		//function get whiteboardcanvas():Group;
		//private var _xPosition:int;
		//private var _yPosition:int;
	}
}