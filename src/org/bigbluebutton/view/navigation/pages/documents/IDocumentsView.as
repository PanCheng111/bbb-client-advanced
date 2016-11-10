package org.bigbluebutton.view.navigation.pages.documents {
	
	import mx.collections.IList;
	import org.bigbluebutton.core.view.IView;
	import org.osflash.signals.ISignal;
	import spark.components.Button;
	import spark.components.List;
	import spark.components.supportClasses.SkinnableComponent;
	
	public interface IDocumentsView extends IView {
		function get list():List;
	}
}
