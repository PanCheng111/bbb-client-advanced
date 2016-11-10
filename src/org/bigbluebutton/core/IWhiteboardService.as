package org.bigbluebutton.core
{
	import org.bigbluebutton.modules.whiteboard.events.WhiteboardDrawEvent;

	public interface IWhiteboardService
	{
		function setupMessageSenderReceiver():void;
		function getAnnotationHistory(presentationID:String, pageNumber:int):void;
		function changePage(pageNum:Number):void;
		function undoGraphic(wbId:String):void;
		function clearBoard(wbId:String):void;
		function sendText():void;
		function sendShape(e:WhiteboardDrawEvent):void;
		function setActivePresentation():void;
	}
}