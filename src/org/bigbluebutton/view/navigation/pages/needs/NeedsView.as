package org.bigbluebutton.view.navigation.pages.needs {
	
	import flash.events.MouseEvent;
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.List;
	import spark.components.RadioButtonGroup;
	
	public class NeedsView extends NeedsViewBase implements INeedsView {
		override protected function childrenCreated():void {
			super.childrenCreated();
		}
		
		public function dispose():void {
		}
		
		public function get moodList():List {
			return moodList0;
		}
	}
}
