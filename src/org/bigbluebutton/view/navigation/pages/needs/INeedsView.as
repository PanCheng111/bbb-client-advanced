package org.bigbluebutton.view.navigation.pages.needs {
	
	import org.bigbluebutton.core.view.IView;
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.List;
	import spark.components.RadioButtonGroup;
	
	public interface INeedsView extends IView {
		function get moodList():List;
	}
}
