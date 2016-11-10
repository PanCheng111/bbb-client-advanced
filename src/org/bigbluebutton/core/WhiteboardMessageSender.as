package org.bigbluebutton.core {
	
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.modules.whiteboard.events.WhiteboardDrawEvent;
	import org.bigbluebutton.modules.whiteboard.events.WhiteboardPresenterEvent;
	
	public class WhiteboardMessageSender {
		private static var LOG:String = "WhiteboardMessageSender - ";
		
		private var userSession:IUserSession;
		
		public function WhiteboardMessageSender(userSession:IUserSession) {
			this.userSession = userSession;
		}
		
		public function changePage(pageNum:Number):void {
			//			LogUtil.debug("Sending [whiteboard.setActivePage] to server.");
		
		   var message:Object = new Object();
		   message["pageNum"] = pageNum;
		
		   //var _nc:ConnectionManager = BBB.initConnectionManager();
		   //_nc.sendMessage("whiteboard.setActivePage",
		   userSession.mainConnection.sendMessage("whiteboard.setActivePage",
		   function(result:String):void { // On successful result
		   //LogUtil.debug(result);
			   trace(result);
		   },
		   function(status:String):void { // status - On error occurred
		   //LogUtil.error(status);
			   trace(status);
		   },
		   message
		   );
		 
		}
		
		
		   public function modifyEnabled(e:WhiteboardPresenterEvent):void {
		   //			LogUtil.debug("Sending [whiteboard.enableWhiteboard] to server.");
		   var message:Object = new Object();
		   message["enabled"] = e.enabled;
		
		  // var _nc:ConnectionManager = BBB.initConnectionManager();
		  // _nc.sendMessage("whiteboard.toggleGrid",
		   userSession.mainConnection.sendMessage("whiteboard.toggleGrid",
		   function(result:String):void { // On successful result
		  // LogUtil.debug(result);
			   trace(result);
		   },
		   function(status:String):void { // status - On error occurred
		//   LogUtil.error(status);
			   trace(status);
		   },
		   message
		   );
		   }
		 
		
		   public function toggleGrid():void{
		   //			LogUtil.debug("Sending [whiteboard.toggleGrid] to server.");
		  // var _nc:ConnectionManager = BBB.initConnectionManager();
		  // _nc.sendMessage("whiteboard.toggleGrid",
		   userSession.mainConnection.sendMessage("whiteboard.toggleGrid",
		   function(result:String):void { // On successful result
		 //  LogUtil.debug(result);
			   trace(result);
		   },
		   function(status:String):void { // status - On error occurred
		 //  LogUtil.error(status);
			   trace(status);
		   }
		   );
		   }
		 
		public function undoGraphic(wbId:String):void {
			//			LogUtil.debug("Sending [whiteboard.undo] to server.");
			var msg:Object = new Object();
			msg["whiteboardId"] = wbId;
		  // var _nc:ConnectionManager = BBB.initConnectionManager();
		  // _nc.sendMessage("whiteboard.undo",
		   userSession.mainConnection.sendMessage("whiteboard.undo",
		   function(result:String):void { // On successful result
		  // LogUtil.debug(result);
			   trace(result);
		   },
		   function(status:String):void { // status - On error occurred
		  // LogUtil.error(status);
			   trace(status);
		   },
		   msg
		   );
		}
		
		public function clearBoard(wbId:String):void {
			//			LogUtil.debug("Sending [whiteboard.clear] to server.");
			var msg:Object = new Object();
			msg["whiteboardId"] = wbId;
		 //  var _nc:ConnectionManager = BBB.initConnectionManager();
		 //  _nc.sendMessage("whiteboard.clear",
		   userSession.mainConnection.sendMessage("whiteboard.clear",
		   function(result:String):void { // On successful result
	//	   LogUtil.debug(result);
		   },
		   function(status:String):void { // status - On error occurred
	//	   LogUtil.error(status);
		   },
		   msg
		   );
		 
		}
		
		public function requestAnnotationHistory(whiteboardID:String):void {
			trace("Sending [whiteboard.requestAnnotationHistory] to server.");
			var msg:Object = new Object();
			msg["whiteboardId"] = whiteboardID;
			userSession.mainConnection.sendMessage("whiteboard.requestAnnotationHistory",
												   function(result:String):void { // On successful result
													   trace(result);
												   },
												   function(status:String):void { // status - On error occurred
													   trace(status);
												   },
												   msg
												   );
		}
		
		public function sendText():void {
			//			LogUtil.debug("Sending [whiteboard.sendAnnotation] (TEXT) to server.");
		
		 //  var _nc:ConnectionManager = BBB.initConnectionManager();
		 //  _nc.sendMessage("whiteboard.sendAnnotation",
			userSession.mainConnection.sendMessage("whiteboard.sendAnnotation",
		   function(result:String):void { // On successful result
		   //                    LogUtil.debug(result);
		   },
		   function(status:String):void { // status - On error occurred
		//   LogUtil.error(status);
		   }
	//	   e.annotation.annotation
		   );
		 
		}
		
		public function sendShape(e:WhiteboardDrawEvent):void {
			//			LogUtil.debug("Sending [whiteboard.sendAnnotation] (SHAPE) to server.");
		
		//   var _nc:ConnectionManager = BBB.initConnectionManager();
		//   _nc.sendMessage("whiteboard.sendAnnotation",
			userSession.mainConnection.sendMessage("whiteboard.sendAnnotation",
		   function(result:String):void { // On successful result
		   //						LogUtil.debug(result);
			   trace(result);
		   },
		   function(status:String):void { // status - On error occurred
	//	   LogUtil.error(status);
			   trace(status);
		   },
		   e.annotation.annotation
		   );
		 
		}
		
		
		   public function checkIsWhiteboardOn():void {
		   //			LogUtil.debug("Sending [whiteboard.isWhiteboardEnabled] to server.");
	//	   var _nc:ConnectionManager = BBB.initConnectionManager();
	//	   _nc.sendMessage("whiteboard.isWhiteboardEnabled",
		   userSession.mainConnection.sendMessage("whiteboard.isWhiteboardEnabled",
		   function(result:String):void { // On successful result
		   //LogUtil.debug(result);
		   },
		   function(status:String):void { // status - On error occurred
		   //LogUtil.error(status);
		   }
		   );
		   }
		 
		public function setActivePresentation():void {
			//			LogUtil.debug("Sending [whiteboard.isWhiteboardEnabled] to server.");
		
		   var message:Object = new Object();
	//	   message["presentationID"] = e.presentationName;
	//	   message["numberOfSlides"] = e.numberOfPages;
		
		//   var _nc:ConnectionManager = BBB.initConnectionManager();
		//   _nc.sendMessage("whiteboard.setActivePresentation",
		   userSession.mainConnection.sendMessage("whiteboard.setActivePresentation",
		   function(result:String):void { // On successful result
		   //LogUtil.debug(result);
		   },
		   function(status:String):void { // status - On error occurred
		  // LogUtil.error(status);
		   },
		   message
		   );
		 
		}
	}
}
