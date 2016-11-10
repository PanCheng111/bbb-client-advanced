package org.bigbluebutton.view.navigation.pages.login.openroom.recentrooms {
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.Keyboard;
	import flash.utils.describeType;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.events.ItemClickEvent;
	import mx.resources.ResourceManager;
	
	import spark.components.View;
	import spark.events.IndexChangeEvent;
	
	import org.bigbluebutton.command.JoinMeetingSignal;
	import org.bigbluebutton.core.ISaveData;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.IUserUISession;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.UserList;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	import org.bigbluebutton.view.navigation.pages.disconnect.enum.DisconnectEnum;
	import org.bigbluebutton.view.navigation.pages.login.openroom.recentrooms.IRecentRoomsView;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class RecentRoomsViewMediator extends Mediator {
		
		[Inject]
		public var view:IRecentRoomsView;
		
		[Inject]
		public var userSession:IUserSession;
		
		[Inject]
		public var userUISession:IUserUISession;
		
		[Inject]
		public var saveData:ISaveData;
		
		[Inject]
		public var joinMeetingSignal:JoinMeetingSignal;
		
		protected var dataProvider:ArrayCollection;
		
		override public function initialize():void {
			if (saveData.read("rooms")) {
				dataProvider = new ArrayCollection((saveData.read("rooms") as ArrayCollection).toArray().reverse());
			}
			view.roomsList.dataProvider = dataProvider;
			view.roomsList.addEventListener(MouseEvent.CLICK, selectRoom);
			FlexGlobals.topLevelApplication.profileBtn.visible = false;
			FlexGlobals.topLevelApplication.backBtn.visible = false;
			FlexGlobals.topLevelApplication.pageName.text = "进行中的会议";//ResourceManager.getInstance().getString('resources', 'recentRooms.title');
			FlexGlobals.topLevelApplication.topActionBar.visible = true;
			FlexGlobals.topLevelApplication.bottomMenu.includeInLayout = false;
			FlexGlobals.topLevelApplication.backBtn.includeInLayout = true;
			FlexGlobals.topLevelApplication.backBtn.visible = true;
		}
		
		protected function selectRoom(event:MouseEvent):void {
			trace("trying to select a room");
			if (view.roomsList.selectedIndex >= 0) {
				trace(dataProvider[view.roomsList.selectedIndex].url);
				if (dataProvider[view.roomsList.selectedIndex].url) {
					//var urlReq = new URLRequest(dataProvider[view.roomsList.selectedIndex].url);
					//navigateToURL(urlReq);
					var url:String = dataProvider[view.roomsList.selectedIndex].url;
					userSession.joinUrl = url;
					userUISession.popPage();
					userUISession.popPage();
					userUISession.pushPage(PagesENUM.LOGIN);
				}
			}
		}
		
		override public function destroy():void {
			super.destroy();
			FlexGlobals.topLevelApplication.backBtn.visible = false;
			FlexGlobals.topLevelApplication.topActionBar.visible = false;
			view.roomsList.removeEventListener(IndexChangeEvent.CHANGE, selectRoom);
			view.dispose();
			view = null;
		}
	}
}
