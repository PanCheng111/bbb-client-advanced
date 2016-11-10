package org.bigbluebutton.view.navigation.pages.whiteboard.toolbar
{
	
	import flash.events.Event;
	
	import org.bigbluebutton.core.IWhiteboardService;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.whiteboard.WhiteboardConstants;
	import org.bigbluebutton.modules.whiteboard.events.WhiteboardDrawEvent;
	import org.bigbluebutton.view.navigation.pages.whiteboard.buttons.ColorPicker;
	import org.bigbluebutton.view.navigation.pages.whiteboard.events.UpdateThicknessEvent;
	import org.bigbluebutton.view.navigation.pages.whiteboard.events.WhiteboardButtonEvent;
	import org.osmf.logging.Log;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class WhiteboardToolbarMediator extends Mediator {
		
		[Inject]
		public var view:IWhiteboardToolbar;
		
		[Inject]
		public var userSession:IUserSession;
		
		[Inject]
		public var whiteboardService: IWhiteboardService;
		
		override public function initialize():void
		{
			trace("init whiteboard tool bar");
			view.buttonList.addEventListener(WhiteboardButtonEvent.WHITEBOARD_BUTTON_PRESSED, handleWhiteboardButtonPressed);
			view.sld.addEventListener(Event.CHANGE, changeThickness);
			view.colorPicker.addEventListener(Event.CHANGE, changeColor);
			view.buttonList.addEventListener(WhiteboardDrawEvent.CLEAR, sendClear);
			view.buttonList.addEventListener(WhiteboardDrawEvent.UNDO, sendUndo);
			onCreationComplete();
		}
		
		private function onCreationComplete():void {
			setToolType(WhiteboardConstants.TYPE_ZOOM, null);
//			if (userSession.userList.me.presenter) {
//				view.showWhiteboardToolbar = true;
//				view.background.visible = true;
//			}
//			else {
//				view.showWhiteboardToolbar = false;
//				view.background.visible = false;
//			}
		}
		
		private function handleWhiteboardButtonPressed(e:WhiteboardButtonEvent):void {
			setToolType(e.graphicType, e.toolType);
		}
		
		private function setToolType(graphicType:String, toolType:String):void {                
			if (graphicType == WhiteboardConstants.TYPE_CLEAR) {
				view.clearBtn.setTool(graphicType, toolType);
				view.buttonList.dispatchEvent(new WhiteboardDrawEvent(WhiteboardDrawEvent.CLEAR));
			} else if (graphicType == WhiteboardConstants.TYPE_UNDO) {
				sendUndoCommand();
				view.undoBtn.setTool(graphicType, toolType);
			} else {
				userSession.whiteboardCanvasModel.setTool(toolType);
				userSession.whiteboardCanvasModel.setGraphicType(graphicType);
				
				if (view.panzoomBtn != null) {
					view.panzoomBtn.setTool(graphicType, toolType);
				}
				
				if (view.scribbleBtn != null) {
					view.scribbleBtn.setTool(graphicType, toolType); 
				}
				
				if (view.rectangleBtn != null) {
					view.rectangleBtn.setTool(graphicType, toolType); 
				}
				
				if (view.circleBtn != null) {
					view.circleBtn.setTool(graphicType, toolType);
				}
				
				if (view.triangleBtn != null) {
					view.triangleBtn.setTool(graphicType, toolType);
				}
				
				if (view.lineBtn != null) {
					view.lineBtn.setTool(graphicType, toolType);
				}
				
				if (view.textBtn != null) {
					view.textBtn.setTool(graphicType, toolType);
				}
			}
		}
		
//		protected function changeColor(e:Event):void {
//			canvas.changeColor(e);
//		}
//		
//		protected function changeFillColor(e:Event):void {
//			canvas.changeFillColor(e);
//		}
//		
		public function changeThickness(e:Event):void {
			userSession.whiteboardCanvasModel.changeThickness(e.target.value);
		}
		
		public function changeColor(e:Event):void {
			userSession.whiteboardCanvasModel.changeColor(ColorPicker(e.currentTarget).currentColor.color);
		}
		
		public function sendClear(e:WhiteboardDrawEvent):void {
			var wbId:String = userSession.presentationList.currentPresentation.id + "/" + (userSession.presentationList.currentPresentation.currentSlideNum + 1);
			whiteboardService.clearBoard(wbId);
		}
		
		public function sendUndo(e:WhiteboardDrawEvent):void {
			var wbId:String = userSession.presentationList.currentPresentation.id + "/" + (userSession.presentationList.currentPresentation.currentSlideNum + 1);
			whiteboardService.undoGraphic(wbId);
		}
		
//		protected function toggleFill():void {
//			canvas.toggleFill();
//		}
//		
//		protected function toggleTransparency():void {
//			canvas.toggleTransparency();
//		}
//		
//		private function presenterMode(e:MadePresenterEvent):void {
//			if (canvas == null) return;
//			
//			canvas.makeTextObjectsEditable(e);
//			setToolType(WhiteboardConstants.TYPE_ZOOM, null);
//		}
//		
//		private function viewerMode(e:MadePresenterEvent):void {
//			canvas.makeTextObjectsUneditable(e);
//			if (!toolbarAllowed()) {
//				checkVisibility();
//				if (view.panzoomBtn) {
//					view.panzoomBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
//				}
//			}
//		}
		
//		private function undoShortcut(e:ShortcutEvent):void{
//			//LOGGER.debug("Ctrl-Z got into undoShortcut");
//			sendUndoCommand();
//		}
//		
		private function sendUndoCommand():void {
			//				if (!canvas.isPageEmpty()) {          
			view.buttonList.dispatchEvent(new WhiteboardDrawEvent(WhiteboardDrawEvent.UNDO));
			//        }
		}
		
//		public function positionToolbar(window:PresentationWindow):void {
//			LOGGER.debug("Positioning whiteboard toolbar");
//			presentationWindow = window;
//			presentationWindow.addEventListener(MoveEvent.MOVE, setPositionAndDepth);
//			presentationWindow.addEventListener(ResizeEvent.RESIZE, setPositionAndDepth);
//			presentationWindow.addEventListener(MouseEvent.CLICK, setPositionAndDepth);
//			
//			if (!wbOptions.keepToolbarVisible) {
//				window.presCtrlBar.addEventListener(MouseEvent.ROLL_OVER, handleMouseOut);
//				window.presCtrlBar.addEventListener(MouseEvent.ROLL_OUT, handleMouseIn);
//				
//				window.addEventListener(MouseEvent.ROLL_OVER, handleMouseIn);
//				window.addEventListener(MouseEvent.ROLL_OUT, handleMouseOut);
//				
//				this.addEventListener(MouseEvent.ROLL_OVER, handleMouseIn);
//				this.addEventListener(MouseEvent.ROLL_OUT, handleMouseOut);
//			} else {
//				var listener1:Listener = new Listener();
//				listener1.method = checkVisibility;
//				listener1.type = MadePresenterEvent.SWITCH_TO_PRESENTER_MODE;
//				var listener2:Listener = new Listener();
//				listener2.method = checkVisibility;
//				listener2.type = MadePresenterEvent.SWITCH_TO_VIEWER_MODE;
//				//Do an initial check to see if the toolbar should be visible
//				checkVisibility();
//			}
//		}
		
//		private function checkVisibility(e:MadePresenterEvent = null):void {
//			if (toolbarAllowed() && slideLoaded && (wbOptions.keepToolbarVisible || mousedOver)) {
//				setPositionAndDepth();
//				showWhiteboardToolbar = true;
//			} else {
//				showWhiteboardToolbar = false;
//			}
//		}
//		
//		private function setPositionAndDepth(e:Event = null):void {
//			this.x = presentationWindow.x + presentationWindow.width - 43;
//			this.y = presentationWindow.y + 30;
//			parent.setChildIndex(this, parent.numChildren - 1);
//		}
//		
//		private function closeToolbar(e:StopWhiteboardModuleEvent):void {
//			parent.removeChild(this);
//		}
//		
//		private function handleMouseIn(e:MouseEvent):void {
//			mousedOver = true;
//			checkVisibility();
//		}
//		
//		private function handleMouseOut(e:MouseEvent = null):void {
//			mousedOver = false;
//			checkVisibility();
//		}
//		
//		private function handleSlideLoaded(e:DisplaySlideEvent):void {
//			slideLoaded = true;
//			checkVisibility();
//		}
//		
//		private function handleSlideChange(e:NavigationEvent):void {
//			slideLoaded = false;
//			// don't switch the toolbar button on slide change
//			checkVisibility();
//		}
//		
//		private function handlePresentationSwitch(e:UploadEvent):void {
//			slideLoaded = false;
//			if (view.panzoomBtn) {
//				view.panzoomBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
//			}
//			checkVisibility();
//		}
		
//		private function graphicObjSelected(event:GraphicObjectFocusEvent):void  {
//			var gobj:GraphicObject = event.data;
//		}
//		
//		private function graphicObjDeselected(event:GraphicObjectFocusEvent):void  {
//			var gobj:GraphicObject = event.data;
//		}
//		
//		private function toolbarAllowed():Boolean {
//			if (wbOptions) {
//				if (wbOptions.whiteboardAccess == "presenter")
//					return isPresenter;
//				else if (wbOptions.whiteboardAccess == "moderator")
//					return isModerator || isPresenter;
//				else if (wbOptions.whiteboardAccess == "all")
//					return true;
//				else
//					return false;
//			} else
//				return false;
//		}
//		
		/** Helper method to test whether this user is the presenter */
		private function get isPresenter():Boolean {
			return userSession.userList.me.role == User.PRESENTER;
		}
		
		private function get isModerator():Boolean {
			return userSession.userList.me.role == User.MODERATOR;
		}
		
		override public function destroy():void {
			super.destroy();
			view.dispose();
			view = null;
		}
	}
}