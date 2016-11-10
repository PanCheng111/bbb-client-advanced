package org.bigbluebutton.view.navigation.pages.splitdocuments {
	
	import org.bigbluebutton.core.view.IView;
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.Label;
	import spark.components.List;
	import spark.components.RadioButtonGroup;
	import spark.components.ViewNavigator;
	
	public interface ISplitDocumentsView extends IView {
		function get documentDetails():ViewNavigator;
		function get documentsList():ViewNavigator;
	}
}
