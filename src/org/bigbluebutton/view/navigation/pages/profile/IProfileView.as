package org.bigbluebutton.view.navigation.pages.profile {
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.Label;
	import spark.components.List;
	import spark.components.RadioButtonGroup;
	
	import org.bigbluebutton.core.view.IView;
	
	public interface IProfileView extends IView {
		function get shareCameraButton():Button;
		function get shareCameraBtnLabel():String;
		function get shareMicButton():Button;
		function get shareMicBtnLabel():String;
		function get statusButton():Button;
		function get needsButton():Button;
		function get logoutButton():Button;
		function get currentState():String;
		function set currentState(value:String):void;
		function get handButton():Button;
		function get clearAllStatusButton():Button;
		function get muteAllButton():Button;
		function get muteAllExceptPresenterButton():Button;
		function get lockViewersButton():Button;
		function get unmuteAllButton():Button;
	}
}
