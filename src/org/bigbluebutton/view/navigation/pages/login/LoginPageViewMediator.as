package org.bigbluebutton.view.navigation.pages.login {
	
	import com.adobe.crypto.SHA1;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.InvokeEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.Capabilities;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	
	import spark.components.Application;
	
	import org.bigbluebutton.command.JoinMeetingSignal;
	import org.bigbluebutton.core.ILoginService;
	import org.bigbluebutton.core.ISaveData;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.IUserUISession;
	import org.bigbluebutton.model.UserSession;
	import org.bigbluebutton.model.UserUISession;
	import org.bigbluebutton.view.navigation.IPagesNavigatorView;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	import org.bigbluebutton.view.navigation.pages.login.openroom.recentrooms.Room;
	import org.flexunit.internals.namespaces.classInternal;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class LoginPageViewMediator extends Mediator {
		private const LOG:String = "LoginPageViewMediator::";
		
		[Inject]
		public var view:ILoginPageView;
		
		[Inject]
		public var joinMeetingSignal:JoinMeetingSignal;
		
		[Inject]
		public var loginService:ILoginService;
		
		[Inject]
		public var userSession:IUserSession;
		
		[Inject]
		public var userUISession:IUserUISession;
		
		[Inject]
		public var saveData:ISaveData;
		
		private var count:Number = 0;
		
		override public function initialize():void {
			//loginService.unsuccessJoinedSignal.add(onUnsucess);
			fetchRooms();
			userUISession.unsuccessJoined.add(onUnsucess);
			view.tryAgainButton.addEventListener(MouseEvent.CLICK, tryAgain);
			joinRoom(userSession.joinUrl);
		}
		
		private function onUnsucess(reason:String):void {
			trace(LOG + "onUnsucess() " + reason);
			FlexGlobals.topLevelApplication.topActionBar.visible = false;
			FlexGlobals.topLevelApplication.bottomMenu.visible = false;
			switch (reason) {
				case "emptyJoinUrl":
					if (!saveData.read("rooms")) {
						view.currentState = LoginPageViewBase.STATE_NO_REDIRECT;
					}
					break;
				case "invalidMeetingIdentifier":
					view.currentState = LoginPageViewBase.STATE_INVALID_MEETING_IDENTIFIER;
					break;
				case "checksumError":
					view.currentState = LoginPageViewBase.STATE_CHECKSUM_ERROR;
					break;
				case "invalidPassword":
					view.currentState = LoginPageViewBase.STATE_INVALID_PASSWORD;
					break;
				case "invalidURL":
					view.currentState = LoginPageViewBase.STATE_INAVLID_URL;
					break;
				case "genericError":
					view.currentState = LoginPageViewBase.STATE_GENERIC_ERROR;
					break;
				case "authTokenTimedOut":
					view.currentState = LoginPageViewBase.STATE_AUTH_TOKEN_TIMEDOUT;
					break;
				case "authTokenInvalid":
					view.currentState = LoginPageViewBase.STATE_AUTH_TOKEN_INVALID;
					break;
				default:
					view.currentState = LoginPageViewBase.STATE_GENERIC_ERROR;
					break;
			}
			// view.messageText.text = reason;
		}
		
		public function joinRoom(url:String) {
			if (Capabilities.isDebugger) {
				//saveData.save("rooms", null);
				// test-install server no longer works with 0.9 mobile client
				//url = "bigbluebutton://test-install.blindsidenetworks.com/bigbluebutton/api/join?fullName=Air&meetingID=Demo+Meeting&password=ap&checksum=512620179852dadd6fe0665a48bcb852a3c0afac";
				//url = "bigbluebutton://lab1.mconf.org/bigbluebut/api/join?fullName=User+4237921ton/api/join?fullName=Air+client&meetingID=Test+room+4&password=prof123&checksum=5805753edd08fbf9af50f9c28bb676c7e5241349"
				//url = "bigbluebutton://143.54.10.103/bigbluebutton/api/join?fullName=User+4704407&meetingID=random-3458293&password=mp&redirect=true&checksum=9102efa4f55e8b920b7f14b1c6bcdee7e0bb9c62";
				//url = "bigbluebutton://192.168.33.10/bigbluebutton/api/join?fullName=User+3569058&meetingID=random-1143106&password=mp&redirect=true&checksum=41f67390d73ca6fa149842bf082eef72d628c041";
				var uri:String = "joinfullName=pancheng&meetingID=bbb05108-55c4-40a5-9fd5-1d3e2f03d6d0-1469192754&password=mp&redirect=true";
				var salt:String = "d1e83b64b0bd7573e1c775ae0dab78e1";
				var checksum:String = SHA1.hash(uri + salt);
				//url = "bigbluebutton://192.168.33.10/bigbluebutton/api/join?fullName=User+8169763&meetingID=random-71405&password=mp&redirect=true&checksum=2e76dc5a3b9efb34a4be5bfd8797fbae5459ec6f";
				//url = "bigbluebutton://192.168.33.11/bigbluebuttom/rooms/test/join";
			}
			if (!url) {
				url = "";
			}
			if (url.lastIndexOf("://") != -1) {
				url = getEndURL(url);
			} else {
				userUISession.pushPage(PagesENUM.OPENROOM);
			}
			joinMeetingSignal.dispatch(url);
		}
		
		
		private function fetchRooms():void {
			var url:String = "http://192.168.33.10/bigbluebutton/api/getMeetings?checksum=8150f7941d4925a767bab1de6bb7a7db9d4c121c";
			
			var request:URLRequest = new URLRequest(url);
			//	request.data = variables;
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
			saveData.save("XMLRooms", e.target.data);
		}
		
		/**
		 * Replace the schema with "http"
		 */
		protected function getEndURL(origin:String):String {
			return origin.replace('bigbluebutton://', 'http://');
		}
		
		override public function destroy():void {
			super.destroy();
			//loginService.unsuccessJoinedSignal.remove(onUnsucess);
			userUISession.unsuccessJoined.remove(onUnsucess);
			view.dispose();
			view = null;
		}
		
		private function tryAgain(event:Event):void {
			FlexGlobals.topLevelApplication.mainshell.visible = false;
			userUISession.popPage();
			userUISession.pushPage(PagesENUM.LOGIN);
		}
	}
}
