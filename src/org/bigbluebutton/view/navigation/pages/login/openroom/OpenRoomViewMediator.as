package org.bigbluebutton.view.navigation.pages.login.openroom {
	
	import com.adobe.crypto.SHA1;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.ui.Keyboard;
	import flash.utils.describeType;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.events.ItemClickEvent;
	import mx.resources.ResourceManager;
	
	import spark.components.View;
	import spark.events.IndexChangeEvent;
	
	import org.bigbluebutton.core.ISaveData;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.IUserUISession;
	import org.bigbluebutton.model.User;
	import org.bigbluebutton.model.UserList;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	import org.bigbluebutton.view.navigation.pages.disconnect.enum.DisconnectEnum;
	import org.bigbluebutton.view.navigation.pages.login.openroom.recentrooms.IRecentRoomsView;
	import org.bigbluebutton.view.navigation.pages.login.openroom.recentrooms.Room;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class OpenRoomViewMediator extends Mediator {
		
		[Inject]
		public var view:IOpenRoomView;
		
		[Inject]
		public var userSession:IUserSession;
		
		[Inject]
		public var userUISession:IUserUISession;
		
		[Inject]
		public var saveData:ISaveData;
		
		private var loader: URLLoader;
		
		override public function initialize():void {
			FlexGlobals.topLevelApplication.profileBtn.visible = false;
			FlexGlobals.topLevelApplication.backBtn.visible = false;
			FlexGlobals.topLevelApplication.bottomMenu.includeInLayout = false;
			FlexGlobals.topLevelApplication.topActionBar.visible = false;
			(view as View).addEventListener(KeyboardEvent.KEY_DOWN, KeyHandler);
			//view.goButton.addEventListener(MouseEvent.CLICK, onGoButtonClick);
			view.recentRoomsBtn.addEventListener(MouseEvent.CLICK, onGoButtonClick);
		}
		
		private function KeyHandler(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.ENTER && view.inputRoom.text && view.password.text) {
				onGoButtonClick(null);
			}
		}
		
		private function onGoButtonClick(e:MouseEvent):void {
			var url:String = "http://192.168.33.10/bigbluebutton/api/getMeetings?checksum=8150f7941d4925a767bab1de6bb7a7db9d4c121c";
			//var variables:URLVariables = new URLVariables();
			//variables["user[login]"] = view.inputRoom.text;
			//variables["user[password]"] = view.password.text;
			
			var request:URLRequest = new URLRequest(url);
			//request.data = variables;
			request.method = URLRequestMethod.GET;
			
			var loader:URLLoader = new URLLoader();
			//
			// 服务端将要返回的是纯文本数据
			//
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, loader_httpStatus);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loader_IOErrorHandler);
			loader.addEventListener(Event.COMPLETE, loader_completeHandler);
			loader.load(request);
		}
		
		private function loader_httpStatus (e:HTTPStatusEvent):void {
			trace("HTTPStatusEvent.HTTP_STATUS");
			trace("HTTP 状态代码 : " + e.status);
			
		}
		
		private function loader_IOErrorHandler(e: IOErrorEvent):void {
			trace("IOErrorEvent.IO_ERROR");
			trace("IO_Error: " + e);
		}
		
		private function loader_completeHandler(e: Event): void {
			trace(e.target.data);
			
			var xml:XML = new XML(saveData.read("XMLRooms"));
			var meetingNames:XMLList = xml.meetings.meeting.meetingName;
			var meetingCreateDates:XMLList = xml.meetings.meeting.createDate;
			var meetingIDs:XMLList = xml.meetings.meeting.meetingID;
			var meetingModeratorPWs:XMLList = xml.meetings.meeting.moderatorPW;
			var rooms:ArrayCollection = new ArrayCollection();
			for (var i:int = 0; i < meetingNames.length(); i++) {
				var meetingName:XML = meetingNames[i];
				var meetingCreateDate:XML = meetingCreateDates[i];
				var meetingID:XML = meetingIDs[i];
				var meetingModeratorPW:XML = meetingModeratorPWs[i];
				var uri:String = "joinfullName=" + view.inputRoom.text + "&meetingID=" + meetingID.children() + "&password=" + meetingModeratorPW.children() + "&redirect=true";
				var salt:String = "d1e83b64b0bd7573e1c775ae0dab78e1";
				var checksum:String = SHA1.hash(uri + salt);
				var url:String = "bigbluebutton://192.168.33.10/bigbluebutton/api/join?" + 
					"fullName=" + view.inputRoom.text + "&meetingID=" + 
					meetingID.children() + "&password=" + meetingModeratorPW.children() + "&redirect=true" +
					"&checksum=" + checksum;
				var room:Room = new Room(new Date(meetingCreateDate.children()), url, meetingName.children());
				rooms.addItem(room);
			}
			saveData.save("rooms", rooms);
			userUISession.pushPage(PagesENUM.RECENTROOMS);
		}
		
		override public function destroy():void {
			super.destroy();
			(view as View).removeEventListener(KeyboardEvent.KEY_DOWN, KeyHandler);
			//view.goButton.removeEventListener(MouseEvent.CLICK, onGoButtonClick);
			view.dispose();
			view = null;
		}
	}
}
