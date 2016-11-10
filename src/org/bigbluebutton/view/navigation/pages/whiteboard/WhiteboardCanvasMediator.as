package org.bigbluebutton.view.navigation.pages.whiteboard {
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.FlexGlobals;
	
	import org.bigbluebutton.core.IWhiteboardService;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.whiteboard.IAnnotation;
	import org.bigbluebutton.modules.whiteboard.events.WhiteboardButtonEvent;
	import org.bigbluebutton.modules.whiteboard.events.WhiteboardDrawEvent;
	import org.bigbluebutton.modules.whiteboard.business.shapes.WhiteboardConstants;
	import org.bigbluebutton.modules.whiteboard.models.Annotation;
	import org.osmf.logging.Log;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class WhiteboardCanvasMediator extends Mediator {
		
		[Inject]
		public var view:IWhiteboardCanvas;
		
		[Inject]
		public var userSession:IUserSession;
		
		[Inject]
		public var whiteboardService: IWhiteboardService;
		
		private var _zoom:Number = 1.0;
		
		override public function initialize():void {
			Log.getLogger("org.bigbluebutton").info(String(this));
			userSession.presentationList.annotationHistorySignal.add(annotationHistoryHandler);
			userSession.presentationList.annotationUpdatedSignal.add(annotationUpdatedHandler);
			userSession.presentationList.annotationUndoSignal.add(annotationUndoHandler);
			userSession.presentationList.annotationClearSignal.add(annotationClearHandler);
			userSession.presentationList.slideChangeSignal.add(slideChangeHandler);
			userSession.whiteboardCanvasModel.wbCanvas = view as WhiteboardCanvas;
			userSession.whiteboardCanvasModel.whiteboardModel.userSession = userSession;
			userSession.whiteboardCanvasModel.idGenerator.userid = userSession.userList.me.userID;
			view.resizeCallback = onWhiteboardResize;
			registerForMouseEvents();
			view.addEventListener(WhiteboardDrawEvent.SEND_SHAPE, sendShape);
		}
		
		private function annotationHistoryHandler():void {
			drawAllAnnotations();
		}
		
		private function annotationUpdatedHandler(annotation:IAnnotation):void {
			annotation.draw(view, _zoom);
		}
		
		private function annotationUndoHandler(annotation:IAnnotation):void {
			annotation.remove(view);
		}
		
		private function annotationClearHandler():void {
			removeAllAnnotations();
		}
		
		private function slideChangeHandler():void {
			removeAllAnnotations();
			drawAllAnnotations();
		}
		
		private function onWhiteboardResize(zoom:Number):void {
			trace("whiteboard zoom = " + zoom);
			_zoom = zoom;
		//	var h:int = userSession.whiteboardCanvasModel.height * _zoom;
		//	var w:int = userSession.whiteboardCanvasModel.width * _zoom;
		//	userSession.whiteboardCanvasModel.zoomCanvas(w, h);
			drawAllAnnotations();
		}
		
		private function drawAllAnnotations():void {
			var annotations:Array = userSession.presentationList.currentPresentation.getSlideAt(userSession.presentationList.currentPresentation.currentSlideNum).annotations;
			for (var i:int = 0; i < annotations.length; i++) {
				var an:IAnnotation = annotations[i] as IAnnotation;
				an.draw(view, _zoom);
			}
		}
		
		private function removeAllAnnotations():void {
			view.removeAllElements();
		}
		
		
		
		public function registerForMouseEvents():void {
			view.addEventListener(MouseEvent.MOUSE_DOWN, doMouseDown);
			//        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			//        stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);               
		}
		
		public function unregisterForMouseEvents():void {
			view.removeEventListener(MouseEvent.MOUSE_DOWN, doMouseDown);
			//        stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			//        stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		//		private function onKeyDown(event:KeyboardEvent):void {
		//			model.onKeyDown(event); 
		//		}
		//		
		//		private function onKeyUp(event:KeyboardEvent):void {
		//			model.onKeyUp(event);
		//		}
		
		private function doMouseUp(event:Event):void {
			userSession.whiteboardCanvasModel.doMouseUp(Math.min(Math.max(view.mouseX, 0), view.width-2) - view.x, Math.min(Math.max(view.mouseY, 0), view.height-2) - view.y);
			
			view.removeEventListener(MouseEvent.MOUSE_UP, doMouseUp);
			view.removeEventListener(MouseEvent.MOUSE_MOVE, doMouseMove);
		}
		
		private function doMouseDown(event:Event):void {
			if (userSession.whiteboardCanvasModel.wbTool.graphicType ==  WhiteboardConstants.TYPE_ZOOM)
				return;
			//displayModel.doMouseDown(this.mouseX, this.mouseY);
			userSession.whiteboardCanvasModel.doMouseDown(view.mouseX, view.mouseY);
			event.stopPropagation(); // we want to stop the bubbling so slide doesn't move
			
			view.addEventListener(MouseEvent.MOUSE_UP, doMouseUp);
			view.addEventListener(MouseEvent.MOUSE_MOVE, doMouseMove);
		}
		
		private function doMouseMove(event:Event):void {
			//var view1 = view as WhiteboardCanvas;
			//userSession.whiteboardCanvasModel.doMouseMove(Math.min(Math.max(view.mouseX, 0), view.width-2) - view.x, Math.min(Math.max(view.mouseY, 0), view.height-2) - view.y);
			userSession.whiteboardCanvasModel.doMouseMove(Math.min(Math.max(view.parent.mouseX, 0), view.parent.width-2) - view.x, Math.min(Math.max(view.parent.mouseY, 0), view.parent.height-2) - view.y);
		}
		
		
		public function setShape(s:String):void {
			//                LogUtil.debug("SET SHAPE [" + s + "]");
			//				model.setShape(s);
		}
		
		public function changeColor(e:Event):void {
			userSession.whiteboardCanvasModel.changeColor(e.target.selectedColor);
		}
		
		
		
		
		public function setGraphicType(type:String):void {
			if (userSession.whiteboardCanvasModel == null) return;
			userSession.whiteboardCanvasModel.setGraphicType(type);
		}
		
		public function setTool(s:String):void {
			if (userSession.whiteboardCanvasModel == null) return;
			userSession.whiteboardCanvasModel.setTool(s);
			//view.whiteboardcanvas.toolType = s;
		}
		
		public function changeFillColor(e:Event):void {
			//				model.changeFillColor(e.target.selectedColor);
		}
		
		
		
		public function toggleFill():void {
			//				model.toggleFill();
		}
		
		public function toggleTransparency():void {
			//				model.toggleTransparency();
		}
		
		
		
		public function modifySelectedTextObject(fgColor:uint, bgColorVisible:Boolean, backgroundColor:uint, textSize:Number):void {
			//                LogUtil.debug("modifying text size = " + textSize);
			//displayModel.modifySelectedTextObject(fgColor, bgColorVisible, backgroundColor, textSize);
		}
		
		//	public function makeTextObjectsEditable(e:MadePresenterEvent):void {
		//				model.makeTextObjectsEditable(e);
		//	}
		
		//	public function makeTextObjectsUneditable(e:MadePresenterEvent):void {
		//				model.makeTextObjectsUneditable(e);
		//	}
		
		private function setWhiteboardVisibility():void {
			if (view.whiteboardEnabled && view.showWhiteboard) {
				view.visible = true;
				registerForMouseEvents();
			} else {
				view.visible = false;
				unregisterForMouseEvents();
			}
		}
		
		//		/* added this functionality in WhiteboardToolbar.mxml instead to allow a variety of cursors */			
		//		public function setCursorPencil():void {
		//			CursorManager.setCursor(pencil_icon);
		//		}
		//		
		//		public function setCursor(toolType:String):void {
		//			if(toolType == DrawObject.ELLIPSE) {
		//				CursorManager.setCursor(ellipse_icon);
		//			} else if(toolType == DrawObject.RECTANGLE) {
		//				CursorManager.setCursor(rectangle_icon);
		//			} else if(toolType == DrawObject.TRIANGLE) {
		//				CursorManager.setCursor(triangle_icon, 2, -7, 0);
		//			} else if(toolType == DrawObject.PENCIL) {
		//				CursorManager.setCursor(pencil_icon, 2, 0, -16);
		//			} else if(toolType == DrawObject.LINE) {
		//				CursorManager.setCursor(line_icon, 2, 0, -14);
		//			} else if(toolType == DrawObject.HIGHLIGHTER) {
		//				CursorManager.setCursor(highlighter_icon);
		//			} else if(toolType == DrawObject.ERASER) {
		//				CursorManager.setCursor(eraser_icon);
		//			} else if(toolType == TextObject.TEXT_TOOL) {
		//				CursorManager.setCursor(text_icon);
		//				//				} else if(toolType == SelectObject.SELECT_TOOL) {
		//				//					CursorManager.setCursor(select_icon);
		//			} 
		//		}
		
		//		private function removeCursor():void {
		//			CursorManager.removeCursor(CursorManager.currentCursorID);
		//		}
		
		//		/** Inherited from org.bigbluebutton.common.IBbbCanvas*/
		//		public function addRawChild(child:DisplayObject):void {
		//			this.bbbCanvas.addRawChild(child);
		//		}
		//		
		//		public function removeRawChild(child:DisplayObject):void {
		//			this.bbbCanvas.removeRawChild(child);
		//		}
		//		
		//		public function doesContain(child:DisplayObject):Boolean {
		//			return bbbCanvas.doesContain(child);
		//		}
		//		
		//		public function acceptOverlayCanvas(overlay:IBbbCanvas):void {
		//			//				LogUtil.debug("WhiteboardCanvas::acceptOverlayCanvas()");
		//			//				LogUtil.debug("OVERLAYING PRESENTATION CANVAS");
		//			
		//			this.bbbCanvas = overlay;
		//			//Load existing shapes onto the canvas.
		//			dispatchEvent(new PageEvent(PageEvent.LOAD_PAGE));
		//			
		//			/**
		//			 * Check if this is the first time we overlayed the whiteboard canvas into the
		//			 * presentation canvas. If so, query for annotations history.
		//			 */
		//			if (! displayModel.canvasInited) {
		//				displayModel.parentCanvasInitialized();
		//				var webId:String = model.whiteboardModel.getCurrentWhiteboardId();
		//				if (webId != null) {
		//					queryForAnnotationHistory(webId);
		//				}        
		//			}
		//			
		//		}
		
		
		
		//		public function removeGraphic(child:DisplayObject):void {
		//			if (bbbCanvas == null) return;
		//			if (doesContain(child)) removeRawChild(child);
		//		}
		//		
		//		public function addGraphic(child:DisplayObject):void {
		//			if (bbbCanvas == null) return;
		//			addRawChild(child);
		//		}
		//		
				public function zoomCanvas(width:Number, height:Number, zoom:Number):void {
					view.width = width;
					view.height = height;	
					//displayModel.zoomCanvas(width, height, zoom);
					userSession.whiteboardCanvasModel.zoomCanvas(width, height);
					//textToolbar.adjustForZoom(width, height);
				}
		
		public function showCanvas(show:Boolean):void{
			view.showWhiteboard = show;
			
			setWhiteboardVisibility();
		}
		
		public function sendShape(e:WhiteboardDrawEvent):void {
			whiteboardService.sendShape(e);
		}
		
		/** End IBBBCanvas*/		
		//		public function isPageEmpty():Boolean {
		//			return displayModel.isPageEmpty();
		//		}
		
		public function enableWhiteboard(e:WhiteboardButtonEvent):void{
			view.whiteboardEnabled = true;
			setWhiteboardVisibility();
			view.useHandCursor = false;
		}
		
		public function disableWhiteboard(e:WhiteboardButtonEvent):void{
			view.whiteboardEnabled = false;
			setWhiteboardVisibility();
			view.useHandCursor = true;
		}
		
		
		override public function destroy():void {
			userSession.presentationList.annotationHistorySignal.remove(annotationHistoryHandler);
			userSession.presentationList.annotationUpdatedSignal.remove(annotationUpdatedHandler);
			userSession.presentationList.annotationUndoSignal.remove(annotationUndoHandler);
			userSession.presentationList.annotationClearSignal.remove(annotationClearHandler);
			userSession.presentationList.slideChangeSignal.remove(slideChangeHandler);
			super.destroy();
			view.dispose();
			view = null;
		}
	}
}
