package org.bigbluebutton.view.navigation.pages.splitparticipants {
	
	import flash.events.Event;
	
	import mx.core.FlexGlobals;
	import mx.events.ResizeEvent;
	
	import org.bigbluebutton.model.IUserUISession;
	import org.bigbluebutton.view.navigation.pages.PagesENUM;
	import org.bigbluebutton.view.navigation.pages.splitsettings.SplitViewEvent;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class SplitParticipantsViewMediator extends Mediator {
		
		[Inject]
		public var view:ISplitParticipantsView;
		
		[Inject]
		public var userUISession:IUserUISession;
		
		private var currentParticipant:Object = null;
		
		override public function initialize():void {
			eventDispatcher.addEventListener(SplitViewEvent.CHANGE_VIEW, changeView);
			view.participantsList.pushView(PagesENUM.getClassfromName(PagesENUM.PARTICIPANTS));
			FlexGlobals.topLevelApplication.stage.addEventListener(ResizeEvent.RESIZE, stageOrientationChangingHandler);
		}
		
		private function stageOrientationChangingHandler(e:Event):void {
			var tabletLandscape:Boolean = FlexGlobals.topLevelApplication.isTabletLandscape();
			if (currentParticipant) {
				if (tabletLandscape) {
					userUISession.pushPage(PagesENUM.SPLITPARTICIPANTS, currentParticipant);
				} else {
					userUISession.popPage();
					userUISession.pushPage(PagesENUM.PARTICIPANTS);
					userUISession.pushPage(PagesENUM.USER_DETAIS, currentParticipant);
				}
			}
		}
		
		private function changeView(event:SplitViewEvent):void {
			view.participantDetails.pushView(event.view);
			currentParticipant = event.details
			userUISession.pushPage(PagesENUM.SPLITPARTICIPANTS, event.details);
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
