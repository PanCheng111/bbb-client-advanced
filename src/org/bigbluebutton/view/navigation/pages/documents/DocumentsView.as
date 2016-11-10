package org.bigbluebutton.view.navigation.pages.documents {
	
	import flash.events.MouseEvent;
	import spark.components.Button;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class DocumentsView extends DocumentsViewBase implements IDocumentsView {
		//private var _buttonTestSignal: Signal = new Signal();
		//public function get buttonTestSignal(): ISignal
		//{
		//	return _buttonTestSignal;
		//}
		override protected function childrenCreated():void {
			super.childrenCreated();
			//this.addEventListener(MouseEvent.CLICK, onClick);
		}
		import spark.components.List;
		
		public function get list():List {
			return documentslist;
		}
		
		
		/*
		   public function onClick(e:MouseEvent):void
		   {
		   //buttonTestSignal.dispatch();
		   }
		 */
		public function dispose():void {
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
	}
}
