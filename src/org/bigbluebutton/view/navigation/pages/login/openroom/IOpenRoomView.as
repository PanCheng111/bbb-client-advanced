package org.bigbluebutton.view.navigation.pages.login.openroom {
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.List;
	import spark.components.RadioButtonGroup;
	import spark.components.TextInput;
	
	import org.bigbluebutton.core.view.IView;
	import org.bigbluebutton.view.ui.NavigationButton;
	
	public interface IOpenRoomView extends IView {
		function get inputRoom():TextInput;
		function get password(): TextInput;
		//function get goButton():Button;
		function get recentRoomsBtn(): Button;
	}
}
