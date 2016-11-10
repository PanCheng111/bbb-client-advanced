package org.bigbluebutton.view.navigation.pages.splitdocuments {
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StageOrientationEvent;
	import flash.utils.setTimeout;
	import mx.core.FlexGlobals;
	import mx.events.ItemClickEvent;
	import mx.events.ResizeEvent;
	import mx.resources.ResourceManager;
	import org.bigbluebutton.command.ClearUserStatusSignal;
	import org.bigbluebutton.command.MoodSignal;
	import org.bigbluebutton.core.IUsersService;
	import org.bigbluebutton.model.IConferenceParameters;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.IUserUISession;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.UserList;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	import org.bigbluebutton.view.navigation.pages.splitsettings.SplitViewEvent;
	import robotlegs.bender.bundles.mvcs.Mediator;
	import spark.events.IndexChangeEvent;
	
	public class SplitDocumentsViewMediator extends Mediator {
		
		[Inject]
		public var view:ISplitDocumentsView;
		
		[Inject]
		public var userUISession:IUserUISession;
		
		private var currentDocument:Object = null;
		
		override public function initialize():void {
			eventDispatcher.addEventListener(SplitViewEvent.CHANGE_VIEW, changeView);
			view.documentsList.pushView(PagesENUM.getClassfromName(PagesENUM.DOCUMENTS));
			FlexGlobals.topLevelApplication.stage.addEventListener(ResizeEvent.RESIZE, stageOrientationChangingHandler);
		}
		
		private function stageOrientationChangingHandler(e:Event):void {
			var tabletLandscape = FlexGlobals.topLevelApplication.isTabletLandscape();
			if (currentDocument) {
				if (tabletLandscape) {
					userUISession.pushPage(PagesENUM.SPLITDOCUMENTS, currentDocument);
				} else {
					userUISession.popPage();
					userUISession.pushPage(PagesENUM.DOCUMENTS);
					userUISession.pushPage(PagesENUM.DOCUMENT_DETAILS, currentDocument);
				}
			}
		}
		
		private function changeView(event:SplitViewEvent) {
			view.documentDetails.pushView(event.view);
			currentDocument = event.details;
			userUISession.pushPage(PagesENUM.SPLITDOCUMENTS, event.details);
		}
		
		override public function destroy():void {
			super.destroy();
			eventDispatcher.removeEventListener(SplitViewEvent.CHANGE_VIEW, changeView);
			FlexGlobals.topLevelApplication.stage.removeEventListener(ResizeEvent.RESIZE, stageOrientationChangingHandler);
			view.dispose();
			view = null;
		}
	}
}
