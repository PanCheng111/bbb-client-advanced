package org.bigbluebutton.view.navigation.pages.splitdocuments {
	
	import flash.events.MouseEvent;
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.List;
	import spark.components.RadioButtonGroup;
	import spark.components.ViewNavigator;
	
	public class SplitDocumentsView extends SplitDocumentsViewBase implements ISplitDocumentsView {
		override protected function childrenCreated():void {
			super.childrenCreated();
		}
		
		public function dispose():void {
		}
		
		public function get documentsList():ViewNavigator {
			return documentslist0;
		}
		
		public function get documentDetails():ViewNavigator {
			return documentdetails0;
		}
	}
}
