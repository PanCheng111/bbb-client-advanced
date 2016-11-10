package org.bigbluebutton.view.navigation.pages.presentation
{
	public class SlideModel
	{
		public static const MYSTERY_NUM:Number = 2;
		
		public static const MAX_ZOOM_PERCENT:Number = 400;
		public static const HUNDRED_PERCENT:Number = 100;
		
		public var viewportX:Number = 0;
		public var viewportY:Number = 0;
		public var viewportW:Number = 0;
		public var viewportH:Number = 0;
		
		public var loaderW:Number = 0;
		public var loaderH:Number = 0;
		public var loaderX:Number = 0;
		public var loaderY:Number = 0;
		
		private var _viewedRegionX:Number = 0;
		private var _viewedRegionY:Number = 0;
		private var _viewedRegionW:Number = HUNDRED_PERCENT;
		private var _viewedRegionH:Number = HUNDRED_PERCENT;
		
		private var _pageOrigW:Number = 0;
		private var _pageOrigH:Number = 0;
		private var _calcPageW:Number = 0;
		private var _calcPageH:Number = 0;
		private var _calcPageX:Number = 0;
		private var _calcPageY:Number = 0;
		private var _calcPageX1:Number = 0;
		private var _calcPageY1:Number = 0;
		private var _parentW:Number = 0;
		private var _parentH:Number = 0;
		
		private var fitToPage:Boolean = true;
		
		public function SlideModel()
		{
		}
		
		public function resetForNewSlide(pageWidth:Number, pageHeight:Number):void {
			_pageOrigW = pageWidth;
			_pageOrigH = pageHeight;
		}
		
		public function parentChange(parentW:Number, parentH:Number):void {
			viewportW = _parentW = parentW;
			viewportH = _parentH = parentH;
		}
		
		public function calculateViewportNeededForRegion(regionW:Number, regionH:Number):void {			
			var vrwp:Number = _pageOrigW * (regionW/HUNDRED_PERCENT);
			var vrhp:Number = _pageOrigH * (regionH/HUNDRED_PERCENT);
			
			if (_parentW < _parentH) {
				viewportW = _parentW;
				viewportH = (vrhp/vrwp)*_parentW;				 
				if (_parentH < viewportH) {
					viewportH = _parentH;
					viewportW = ((vrwp * viewportH)/vrhp);
				}
			} else {
				viewportH = _parentH;
				viewportW = (vrwp/vrhp)*_parentH;
				if (_parentW < viewportW) {
					viewportW = _parentW;
					viewportH = ((vrhp * viewportW)/vrwp);
				}
			}
		}
		
		
		public function displayViewerRegion(x:Number, y:Number, regionW:Number, regionH:Number):void {
			_calcPageW = viewportW/(regionW/HUNDRED_PERCENT);
			_calcPageH = viewportH/(regionH/HUNDRED_PERCENT);
			_calcPageX = (x/HUNDRED_PERCENT) * _calcPageW * MYSTERY_NUM;
			_calcPageY = (y/HUNDRED_PERCENT) * _calcPageH * MYSTERY_NUM;
			
			_calcPageX1 = (x/HUNDRED_PERCENT) * _calcPageW;
			_calcPageY1 = (y/HUNDRED_PERCENT) * _calcPageH;
			
			/**
			 * I have no idea why I need to multiply the x and y percentages by 2, but I 
			 * do. I think it is a bug in 0.81, but I can't change that.
			 *     - capilkey March 11, 2015
			 */
		}
		
		public function calculateViewportXY():void {
			viewportX = SlideCalcUtil.calculateViewportX(viewportW, _parentW);
			viewportY = SlideCalcUtil.calculateViewportY(viewportH, _parentH);			
		}
		
		public function displayPresenterView():void {
			loaderX = Math.round(_calcPageX);
			loaderY = Math.round(_calcPageY);
			loaderW = Math.round(_calcPageW);
			loaderH = Math.round(_calcPageH);
		}
		
		// add after here
		
		private function doWidthBoundsDetection():void {
			if (_calcPageX1 >= 0) {
				// Don't let the left edge move inside the view.
				_calcPageX1 = 0;
			} else if ((_calcPageW + _calcPageX1 * MYSTERY_NUM) < viewportW) {
				// Don't let the right edge move inside the view.
				_calcPageX1 = (viewportW - _calcPageW) / MYSTERY_NUM;
			} else {
				// Let the move happen.
			}			
		}
		
		private function doHeightBoundsDetection():void {
			if (_calcPageY1 >= 0) {
				// Don't let the top edge move into the view.
				_calcPageY1 = 0;
			} else if ((_calcPageH + _calcPageY1 * MYSTERY_NUM) < viewportH) {
				// Don't let the bottome edge move into the view.
				_calcPageY1 = (viewportH - _calcPageH) / MYSTERY_NUM;
			} else {
				// Let the move happen.
			}			
		}
		
		private function onResizeMove():void {		
			doWidthBoundsDetection();
			doHeightBoundsDetection();
		}
		
		public function onMove(deltaX:Number, deltaY:Number):void {
			_calcPageX1 += deltaX / MYSTERY_NUM;
			_calcPageY1 += deltaY / MYSTERY_NUM;
			
			onResizeMove();	
			calcViewedRegion();
		}
		
		private function calcViewedRegion():void {
			_viewedRegionW = SlideCalcUtil.calcViewedRegionWidth(viewportW, _calcPageW);
			_viewedRegionH = SlideCalcUtil.calcViewedRegionHeight(viewportH, _calcPageH);
			_viewedRegionX = SlideCalcUtil.calcViewedRegionX(_calcPageX1, _calcPageW);
			_viewedRegionY = SlideCalcUtil.calcViewedRegionY(_calcPageY1, _calcPageH);
		}
		
		public function saveViewedRegion(x:Number, y:Number, regionW:Number, regionH:Number):void {
			_viewedRegionX = x;
			_viewedRegionY = y;
			_viewedRegionW = regionW;
			_viewedRegionH = regionH;
		}
		
		public function onZoom(zoomValue:Number, mouseX:Number, mouseY:Number):void {
			
			// Absolute x and y positions of the mouse over the (enlarged) slide:
			var absXcoordInPage:Number = Math.abs(_calcPageX1) * MYSTERY_NUM + mouseX;
			var absYcoordInPage:Number = Math.abs(_calcPageY1) * MYSTERY_NUM + mouseY;
			
			// Relative position of mouse over the slide. For example, if your slide is 1000 pixels wide, 
			// and your mouse has an absolute x-coordinate of 700, then relXcoordInPage will be 0.7 :
			var relXcoordInPage:Number = absXcoordInPage / _calcPageW; 
			var relYcoordInPage:Number = absYcoordInPage / _calcPageH;
			
			// Relative position of mouse in the view port (same as above, but with the view port):
			var relXcoordInViewport:Number = mouseX / viewportW;
			var relYcoordInViewport:Number = mouseY / viewportH;
			
			if (isPortraitDoc()) {
				if (fitToPage) {
					_calcPageH = viewportH * zoomValue / HUNDRED_PERCENT;
					_calcPageW = (_pageOrigW/_pageOrigH)*_calcPageH;
				} else {
					_calcPageW = viewportW * zoomValue / HUNDRED_PERCENT;
					_calcPageH = (_calcPageW/_pageOrigW)*_pageOrigH;
				}
			} else {
				if (fitToPage) {
					_calcPageW = viewportW * zoomValue / HUNDRED_PERCENT;
					_calcPageH = viewportH * zoomValue / HUNDRED_PERCENT;
				} else {
					_calcPageW = viewportW * zoomValue / HUNDRED_PERCENT;
					_calcPageH = (_calcPageW/_pageOrigW)*_pageOrigH;
				}
			}
			
			absXcoordInPage = relXcoordInPage * _calcPageW;
			absYcoordInPage = relYcoordInPage * _calcPageH;
			
			_calcPageX1 = -((absXcoordInPage - mouseX) / MYSTERY_NUM);
			_calcPageY1 = -((absYcoordInPage - mouseY) / MYSTERY_NUM);
			
			doWidthBoundsDetection();
			doHeightBoundsDetection();
			
			calcViewedRegion();
		}
		
		private function isPortraitDoc():Boolean {
			return _pageOrigH > _pageOrigW;
		}
		
		public function get viewedRegionW():Number {
			return _viewedRegionW;
		}
		
		public function get viewedRegionH():Number {
			return _viewedRegionH;
		}
		
		public function get viewedRegionX():Number {
			return _viewedRegionX;
		}
		
		public function get viewedRegionY():Number {
			return _viewedRegionY;
		}
	}
}