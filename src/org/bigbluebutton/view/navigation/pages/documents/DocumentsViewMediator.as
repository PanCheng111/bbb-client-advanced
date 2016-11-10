package org.bigbluebutton.view.navigation.pages.documents {
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StageOrientationEvent;
	import flash.utils.Dictionary;
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.events.CollectionEvent;
	import mx.events.ResizeEvent;
	import mx.resources.ResourceManager;
	import org.bigbluebutton.core.IUsersService;
	import org.bigbluebutton.model.IUserSession;
	import org.bigbluebutton.model.IUserUISession;
	import org.bigbluebutton.model.presentation.Presentation;
	import org.bigbluebutton.model.presentation.PresentationList;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	import org.bigbluebutton.view.navigation.pages.TransitionAnimationENUM;
	import org.bigbluebutton.view.navigation.pages.participants.guests.GuestResponseEvent;
	import org.bigbluebutton.view.navigation.pages.splitsettings.SplitViewEvent;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import robotlegs.bender.bundles.mvcs.Mediator;
	import spark.components.Button;
	import spark.events.IndexChangeEvent;
	
	import mx.core.mx_internal;
	use namespace mx_internal;
	
	public class DocumentsViewMediator extends Mediator {
		
		[Inject]
		public var view:IDocumentsView;
		
		[Inject]
		public var userSession:IUserSession
		
		[Inject]
		public var userUISession:IUserUISession
		
		[Inject]
		public var usersService:IUsersService;
		
		protected var dataProvider:ArrayCollection;
		
//		protected var dicUserIdtoUser:Dictionary;
//		
//		protected var dicUserIdtoGuest:Dictionary
		
		protected var usersSignal:ISignal;
		
//		private var _userMe:User;
		
		override public function initialize():void {
			dataProvider = new ArrayCollection();
			view.list.dataProvider = dataProvider;
			view.list.addEventListener(IndexChangeEvent.CHANGE, onSelectDocument);
//			dicUserIdtoUser = new Dictionary();
			var presentationList:ArrayCollection = userSession.presentationList.presentations;
			for each (var document:Presentation in presentationList) {
				addPresentation(document);
//				if (user.me) {
//					_userMe = user;
//				}
			}
			//userSession.userList.userChangeSignal.add(userChanged);
			//userSession.userList.userAddedSignal.add(addUser);
			//userSession.userList.userRemovedSignal.add(userRemoved);
			setPageTitle();
			FlexGlobals.topLevelApplication.profileBtn.visible = true;
			FlexGlobals.topLevelApplication.backBtn.visible = false;
			//view.guestsList.addEventListener(GuestResponseEvent.GUEST_RESPONSE, onSelectGuest);
			FlexGlobals.topLevelApplication.stage.addEventListener(ResizeEvent.RESIZE, stageOrientationChangingHandler);
			//view.allowAllButton.addEventListener(MouseEvent.CLICK, allowAllGuests);
			//view.denyAllButton.addEventListener(MouseEvent.CLICK, denyAllGuests);
			//dicUserIdtoGuest = new Dictionary();
			//var guests:ArrayCollection = userSession.guestList.users;
//			for each (var guest:User in guests) {
//				addGuest(guest);
//			}
//			userSession.guestList.userAddedSignal.add(addGuest);
//			userSession.guestList.userRemovedSignal.add(guestRemoved);
//			if (_userMe.role == User.MODERATOR && dataProviderGuests.length > 0) {
//				view.guestsList.visible = true;
//				view.guestsList.includeInLayout = true;
//				view.allGuests.visible = true;
//				view.allGuests.includeInLayout = true;
//			}
			if (FlexGlobals.topLevelApplication.isTabletLandscape()) {
				if (userUISession.currentPageDetails is Presentation) {
					view.list.setSelectedIndex(dataProvider.getItemIndex(userUISession.currentPageDetails), true);
				} else {
					view.list.setSelectedIndex(0, true);
				}
			}
			var tabletLandscape = FlexGlobals.topLevelApplication.isTabletLandscape();
			if (tabletLandscape) {
				userUISession.pushPage(PagesENUM.SPLITDOCUMENTS);
			} else {
				userUISession.pushPage(PagesENUM.DOCUMENTS);
			}
		}
		
		private function stageOrientationChangingHandler(e:Event):void {
			var tabletLandscape = FlexGlobals.topLevelApplication.isTabletLandscape();
			if (tabletLandscape) {
				userUISession.pushPage(PagesENUM.SPLITDOCUMENTS);
			}
		}
		
		private function addPresentation(document:Presentation):void {
			dataProvider.addItem(document);
			dataProvider.refresh();
			//dicUserIdtoUser[document.userID] = user;
			setPageTitle();
		}
		
//		private function addGuest(guest:Object):void {
//			dataProviderGuests.addItem(guest);
//			dataProviderGuests.refresh();
//			dicUserIdtoGuest[guest.userID] = guest;
//			if (_userMe.role == User.MODERATOR && dataProviderGuests.length > 0) {
//				view.guestsList.visible = true;
//				view.guestsList.includeInLayout = true;
//				view.allGuests.visible = true;
//				view.allGuests.includeInLayout = true;
//			}
//		}
		
//		private function userRemoved(userID:String):void {
//			var user:User = dicUserIdtoUser[userID] as User;
//			var index:uint = dataProvider.getItemIndex(user);
//			dataProvider.removeItemAt(index);
//			dicUserIdtoUser[user.userID] = null;
//			setPageTitle();
//			if (FlexGlobals.topLevelApplication.isTabletLandscape() && userUISession.currentPageDetails == user) {
//				view.list.setSelectedIndex(0, true);
//			}
//		}
		
//		private function guestRemoved(userID:String):void {
//			var guest:User = dicUserIdtoGuest[userID] as User;
//			if (guest) {
//				var index:uint = dataProviderGuests.getItemIndex(guest);
//				dataProviderGuests.removeItemAt(index);
//				dicUserIdtoGuest[guest.userID] = null;
//				if (_userMe.role == User.MODERATOR && dataProviderGuests.length == 0 && view && view.guestsList != null) {
//					view.guestsList.includeInLayout = false;
//					view.guestsList.visible = false;
//					view.allGuests.includeInLayout = false;
//					view.allGuests.visible = false;
//				}
//			}
//		}
		
//		private function documentChanged(document:Presentation, property:String = null):void {
//			dataProvider.refresh();
//			if (_userMe.role == User.MODERATOR && dataProviderGuests.length > 0) {
//				view.guestsList.visible = true;
//				view.guestsList.includeInLayout = true;
//				view.allGuests.visible = true;
//				view.allGuests.includeInLayout = true;
//			} else {
//				view.guestsList.visible = false;
//				view.guestsList.includeInLayout = false;
//				view.allGuests.visible = false;
//				view.allGuests.includeInLayout = false;
//			}
//		}
		
		protected function onSelectDocument(event:IndexChangeEvent):void {
			if (event.newIndex >= 0) {
				var document:Presentation = dataProvider.getItemAt(event.newIndex) as Presentation;
				if (FlexGlobals.topLevelApplication.isTabletLandscape()) {
					eventDispatcher.dispatchEvent(new SplitViewEvent(SplitViewEvent.CHANGE_VIEW, PagesENUM.getClassfromName(PagesENUM.DOCUMENT_DETAILS), document, true))
				} else {
					userUISession.pushPage(PagesENUM.DOCUMENT_DETAILS, document, TransitionAnimationENUM.SLIDE_LEFT);
				}
			}
		}
		
//		protected function onSelectGuest(event:GuestResponseEvent):void {
//			usersService.responseToGuest(event.guestID, event.allow);
//		}
		
//		protected function allowAllGuests(event:MouseEvent):void {
//			usersService.responseToAllGuests(true);
//		}
//		
//		protected function denyAllGuests(event:MouseEvent):void {
//			usersService.responseToAllGuests(false);
//		}
		
		/**
		 * Count participants and set page title accordingly
		 **/
		private function setPageTitle():void {
			if (dataProvider != null) {
				FlexGlobals.topLevelApplication.pageName.text = "文档"; //ResourceManager.getInstance().getString('resources', 'participants.title') + " (" + dataProvider.length + ")";
			}
		}
		
		override public function destroy():void {
			super.destroy();
			view.dispose();
			view = null;
			FlexGlobals.topLevelApplication.stage.removeEventListener(ResizeEvent.RESIZE, stageOrientationChangingHandler);
//			userSession.userList.userChangeSignal.remove(userChanged);
//			userSession.userList.userAddedSignal.remove(addUser);
//			userSession.userList.userRemovedSignal.remove(userRemoved);
//			userSession.guestList.userAddedSignal.remove(addGuest);
		}
	}
}
