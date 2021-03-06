package org.bigbluebutton.view.navigation.pages.common {
	
	import org.bigbluebutton.view.ui.NavigationButton;
	import spark.components.Button;
	
	public class MenuButtonsView extends MenuButtons implements IMenuButtonsView {
		
		public function get menuPollsButton():NavigationButton {
			return pollsBtn0;
		}
			
		public function get menuDeskshareButton():NavigationButton {
			return deskshareBtn0;
		}
		
		public function get menuVideoChatButton():NavigationButton {
			return videochatBtn0;
		}
		
		public function get menuPresentationButton():NavigationButton {
			return presentationBtn0;
		}
		
		public function get pushToTalkButton():Button {
			return pushToTalkButton0;
		}
		
		public function get menuChatButton():NavigationButton {
			return chatBtn0;
		}
		
		public function get menuParticipantsButton():NavigationButton {
			return participantsBtn0;
		}
		
		public function get menuDocumentsButton():NavigationButton {
			return documentsBtn0;
		}
	}
}
