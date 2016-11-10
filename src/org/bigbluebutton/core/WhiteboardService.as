package org.bigbluebutton.core {
	
	import org.bigbluebutton.core.IWhiteboardService;
	import org.bigbluebutton.core.WhiteboardMessageReceiver;
	import org.bigbluebutton.core.WhiteboardMessageSender;
	import org.bigbluebutton.model.IMessageListener;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.modules.whiteboard.events.WhiteboardDrawEvent;
	
	public class WhiteboardService implements IWhiteboardService {
		
		[Inject]
		public var userSession:IUserSession;
		
		private var whiteboardMessageSender:WhiteboardMessageSender;
		
		private var whiteboardMessageReceiver:WhiteboardMessageReceiver;
		
		public function WhiteboardService() {
		}
		
		public function setupMessageSenderReceiver():void {
			whiteboardMessageSender = new WhiteboardMessageSender(userSession);
			whiteboardMessageReceiver = new WhiteboardMessageReceiver(userSession);
			userSession.mainConnection.addMessageListener(whiteboardMessageReceiver as IMessageListener);
		}
		
		public function getAnnotationHistory(presentationID:String, pageNumber:int):void {
			whiteboardMessageSender.requestAnnotationHistory(presentationID + "/" + pageNumber);
		//	whiteboardMessageSender.toggleGrid();
		}
		
		public function changePage(pageNum:Number):void {
			pageNum += 1;
			//if (isPresenter) {
			whiteboardMessageSender.changePage(pageNum);
			//}
		}
		
		public function undoGraphic(wbId:String):void {
			whiteboardMessageSender.undoGraphic(wbId);
		}
		
		public function clearBoard(wbId:String):void {
			whiteboardMessageSender.clearBoard(wbId);
		}
		
		public function sendText():void {
			whiteboardMessageSender.sendText();
		}
		
		public function sendShape(e:WhiteboardDrawEvent):void {
			whiteboardMessageSender.sendShape(e);
		}
		
		public function setActivePresentation():void {
			//if (isPresenter) {
			whiteboardMessageSender.setActivePresentation();
			//}
		}
	}
}
