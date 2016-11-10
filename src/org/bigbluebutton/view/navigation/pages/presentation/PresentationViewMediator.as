package org.bigbluebutton.view.navigation.pages.presentation {
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Point;
	
	import mx.core.FlexGlobals;
	import mx.events.ResizeEvent;
	
	import org.bigbluebutton.command.LoadSlideSignal;
	import org.bigbluebutton.core.IPresentationService;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.IUserUISession;
	import org.bigbluebutton.model.UserUISession;
	import org.bigbluebutton.model.presentation.Presentation;
	import org.bigbluebutton.model.presentation.Slide;
	import org.bigbluebutton.util.CursorIndicator;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	import org.osmf.logging.Log;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class PresentationViewMediator extends Mediator {
		
		[Inject]
		public var view:IPresentationView;
		
		[Inject]
		public var userSession:IUserSession;
		
		[Inject]
		public var loadSlideSignal:LoadSlideSignal;
		
		[Inject]
		public var presentationService:IPresentationService;
		
		[Inject]
		public var userUISession:IUserUISession;
		
		private var _currentPresentation:Presentation;
		
		private var _currentSlideNum:int = -1;
		
		private var _currentSlide:Slide;
		
		private var _slideModel:SlideModel = new SlideModel();
		
		private var _cursor:CursorIndicator = new CursorIndicator();
		
		private var prevMouseX:Number;
		private	var prevMouseY:Number;
		private var zoomPercent:Number = 100;
		
		override public function initialize():void {
			userSession.presentationList.presentationChangeSignal.add(presentationChangeHandler);
			view.slide.addEventListener(TransformGestureEvent.GESTURE_SWIPE, swipehandler);
			view.slide.addEventListener(TransformGestureEvent.GESTURE_ZOOM, zoomhandler);
			userSession.presentationList.viewedRegionChangeSignal.add(viewedRegionChangeHandler);
			userSession.presentationList.cursorUpdateSignal.add(cursorUpdateHandler);
			FlexGlobals.topLevelApplication.stage.addEventListener(ResizeEvent.RESIZE, stageOrientationChangingHandler);
			view.slide.addEventListener(Event.COMPLETE, handleLoadingComplete);
			_slideModel.parentChange(view.content.width, view.content.height);
			setPresentation(userSession.presentationList.currentPresentation);
			//setCurrentSlideNum(userSession.presentationList.currentSlideNum);
			FlexGlobals.topLevelApplication.backBtn.visible = false;
			FlexGlobals.topLevelApplication.profileBtn.visible = true;
			
			view.viewport.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
		}
		
		private function swipehandler(e:TransformGestureEvent):void {
			if (userSession.userList.me.presenter) {
				if (e.offsetX == -1 && _currentSlideNum < _currentPresentation.slides.length - 1) {
					setCurrentSlideNum(_currentSlideNum + 1);
					presentationService.gotoSlide(_currentPresentation.id + "/" + _currentSlide.slideNumber);
				} else if (e.offsetX == 1 && _currentSlideNum > 0) {
					trace("current slide : " + _currentSlideNum);
					setCurrentSlideNum(_currentSlideNum - 1);
					presentationService.gotoSlide(_currentPresentation.id + "/" + _currentSlide.slideNumber);
				}
			}
		}
		
		private function zoomhandler(e:TransformGestureEvent):void {
			if (userSession.userList.me.presenter) {
				zoomPercent *= Math.min(e.scaleX, e.scaleY);
				if (zoomPercent < 100) zoomPercent = 100;
				else if (zoomPercent > 400) zoomPercent = 400;
				_slideModel.onZoom(zoomPercent, (((view.slide.content.width/2)* SlideModel.HUNDRED_PERCENT)/zoomPercent), (((view.slide.content.height/2)*SlideModel.HUNDRED_PERCENT)/zoomPercent));
				_slideModel.displayPresenterView();
				//fitSlideToLoader();	
				//fitLoaderToSize();
				notifyOthersOfZoomEvent();
			}
		}
		
		private function displaySlide():void {
			if (_currentSlide != null) {
				_currentSlide.slideLoadedSignal.remove(slideLoadedHandler);
			}
			if (_currentPresentation != null && _currentSlideNum >= 0) {
				_currentSlide = _currentPresentation.getSlideAt(_currentSlideNum);
				if (_currentSlide != null) {
					if (_currentSlide.loaded && view != null) {
						view.setSlide(_currentSlide);
					} else {
						_currentSlide.slideLoadedSignal.add(slideLoadedHandler);
						loadSlideSignal.dispatch(_currentSlide, _currentPresentation.id);
					}
				}
			} else if (view != null) {
				view.setSlide(null);
			}
		}
		
		private function viewedRegionChangeHandler(x:Number, y:Number, widthPercent:Number, heightPercent:Number):void {
			resetSize(x, y, widthPercent, heightPercent);
		}
		
		private function resizePresentation():void {
			if (_slideModel && view && view.slide) {
				_slideModel.resetForNewSlide(view.slide.contentWidth, view.slide.contentHeight);
				var currentSlide:Slide = userSession.presentationList.currentPresentation.getSlideAt(_currentSlideNum);
				if (currentSlide) {
					resetSize(currentSlide.x, currentSlide.y, currentSlide.widthPercent, currentSlide.heightPercent);
					_cursor.draw(view.viewport, userSession.presentationList.cursorXPercent, userSession.presentationList.cursorYPercent);
						//resetSize(_currentSlide.x, _currentSlide.y, _currentSlide.widthPercent, _currentSlide.heightPercent);
				}
			}
		}
		
		private function stageOrientationChangingHandler(e:Event):void {
			if (userUISession.currentPage == PagesENUM.PRESENTATION) { //apply rotation only if user didn´t change view at the same time
				var newWidth:Number = FlexGlobals.topLevelApplication.width;
				var newHeight:Number = FlexGlobals.topLevelApplication.height - FlexGlobals.topLevelApplication.topActionBar.height - FlexGlobals.topLevelApplication.bottomMenu.height;
				_slideModel.parentChange(newWidth, newHeight);
				resizePresentation();
			}
		}
		
		private function handleLoadingComplete(e:Event):void {
			resizePresentation();
			//view.rotationHandler(FlexGlobals.topLevelApplication.currentOrientation);
		}
		
		private function resetSize(x:Number, y:Number, widthPercent:Number, heightPercent:Number):void {
			//_slideModel.saveViewedRegion(x, y, widthPercent, heightPercent);
			_slideModel.calculateViewportNeededForRegion(widthPercent, heightPercent);
			_slideModel.displayViewerRegion(x, y, widthPercent, heightPercent);
			_slideModel.calculateViewportXY();
			_slideModel.displayPresenterView();
			setViewportSize();
			fitLoaderToSize();
			//fitSlideToLoader();
			zoomPercent = Math.max(widthPercent, heightPercent);
			zoomCanvas(view.slide.x, view.slide.y, view.slide.width, view.slide.height, 1 / Math.max(widthPercent / 100, heightPercent / 100));
			userSession.whiteboardCanvasModel.zoomCanvas(view.slide.width, view.slide.height);
		}
		
		private function setViewportSize():void {
			view.viewport.x = _slideModel.viewportX;
			view.viewport.y = _slideModel.viewportY;
			view.viewport.height = _slideModel.viewportH;
			view.viewport.width = _slideModel.viewportW;
		}
		
		private function fitLoaderToSize():void {
			view.slide.x = _slideModel.loaderX;
			view.slide.y = _slideModel.loaderY;
			view.slide.width = _slideModel.loaderW;
			view.slide.height = _slideModel.loaderH;
		}
		
		public function zoomCanvas(x:Number, y:Number, width:Number, height:Number, zoom:Number):void {
			view.whiteboardCanvas.moveCanvas(x, y, width, height, zoom);
		}
		
		private function resizeWhiteboard():void {
			view.whiteboardCanvas.height = view.slide.height;
			view.whiteboardCanvas.width = view.slide.width;
			view.whiteboardCanvas.x = view.slide.x;
			view.whiteboardCanvas.y = view.slide.y;
		}
		
		private function cursorUpdateHandler(xPercent:Number, yPercent:Number):void {
			_cursor.draw(view.viewport, xPercent, yPercent);
		}
		
		private function presentationChangeHandler():void {
			setPresentation(userSession.presentationList.currentPresentation);
		}
		
		private function slideChangeHandler():void {
			setCurrentSlideNum(userSession.presentationList.currentPresentation.currentSlideNum);
			_cursor.remove(view.viewport);
		}
		
		private function setPresentation(p:Presentation):void {
			_currentPresentation = p;
			if (_currentPresentation != null) {
				_currentPresentation.slideChangeSignal.remove(slideChangeHandler);
				view.setPresentationName(_currentPresentation.fileName);
				_currentPresentation.slideChangeSignal.add(slideChangeHandler);
				setCurrentSlideNum(p.currentSlideNum);
			} else {
				view.setPresentationName("");
			}
		}
		
		private function setCurrentSlideNum(n:int):void {
			_currentSlideNum = n;
			displaySlide();
		}
		
		private function slideLoadedHandler():void {
			displaySlide();
		}
		
		
		/**
		 * Triggered when the presenter clicks on the slides with the intent of moving it.
		 */		
		private function onMouseDown(e:MouseEvent):void {
			prevMouseX = view.viewport.mouseX;
			prevMouseY = view.viewport.mouseY;
			//myNumber += 1;
			//if (myNumber > 0) myNumber = 0;
			//presentationService.move(myNumber, -13.91934407474497, 58.823529411764696, 58.823529411764696);
			//return;
			view.viewport.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			view.viewport.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		/**
		 * Triggered when the mouse had been clicked and dragged to move the slide.
		 */ 
		private function onMouseMove(e:MouseEvent):void {	
			// Compute the change in mouse position from where the mouse was clicked.
			var deltaCanvasMouseX:Number = view.viewport.mouseX - prevMouseX;
			var deltaCanvasMouseY:Number = view.viewport.mouseY - prevMouseY;
			prevMouseX = view.viewport.mouseX;
			prevMouseY = view.viewport.mouseY;	
			trace('premousex =', prevMouseX, 'premousey =', prevMouseY);
			_slideModel.onMove(deltaCanvasMouseX, deltaCanvasMouseY); 
			//_slideModel.printViewedRegion();
			_slideModel.displayPresenterView();
			//fitSlideToLoader();	
			//fitLoaderToSize();
			notifyOthersOfZoomEvent();
		}
		
		/**
		 * Triggered when the presenter releases the mouse button.
		 */		
		private function onMouseUp(e:MouseEvent):void{		
			view.viewport.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			view.viewport.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function fitSlideToLoader():void {
			if (view.slide.content == null) return;
			view.slide.content.x = view.slide.x;
			view.slide.content.y = view.slide.y;
			view.slide.content.width = view.slide.width;
			view.slide.content.height = view.slide.height;
			//zoomCanvas(view.slide.x, view.slide.y, view.slide.width, view.slide.height, 1 / Math.max(widthPercent / 100, heightPercent / 100));
		}
		
		private function notifyOthersOfZoomEvent():void {
//			var presentEvent:PresenterCommands = new PresenterCommands(PresenterCommands.ZOOM);
//			presentEvent.xOffset = slideModel.viewedRegionX;
//			presentEvent.yOffset = slideModel.viewedRegionY;
//			presentEvent.slideToCanvasWidthRatio = slideModel.viewedRegionW;
//			presentEvent.slideToCanvasHeightRatio = slideModel.viewedRegionH;
//			dispatchEvent(presentEvent);
			presentationService.move(_slideModel.viewedRegionX, _slideModel.viewedRegionY, _slideModel.viewedRegionW, _slideModel.viewedRegionH);
		}
		
		
		override public function destroy():void {
			view.slide.removeEventListener(Event.COMPLETE, handleLoadingComplete);
			FlexGlobals.topLevelApplication.stage.removeEventListener(ResizeEvent.RESIZE, stageOrientationChangingHandler);
			userSession.presentationList.presentationChangeSignal.remove(presentationChangeHandler);
			userSession.presentationList.viewedRegionChangeSignal.remove(viewedRegionChangeHandler);
			userSession.presentationList.cursorUpdateSignal.remove(cursorUpdateHandler);
			if (_currentPresentation != null) {
				_currentPresentation.slideChangeSignal.remove(slideChangeHandler);
			}
			super.destroy();
			view.dispose();
			view = null;
		}
	}
}
