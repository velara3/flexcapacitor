

package com.flexcapacitor.effects.core.supportClasses {
	
	import com.flexcapacitor.effects.core.PlayerType;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.events.Event;
	import flash.system.Capabilities;
	

	/**
	 * @copy PlayerType
	 * */  
	public class PlayerTypeInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function PlayerTypeInstance(target:Object) {
			super(target);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 * */
		override public function play():void { 
			super.play(); // dispatch startEffect
			
			var action:PlayerType = PlayerType(effect);
			var playerType:String = Capabilities.playerType;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			// yep
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// check player type
			if (playerType==PlayerType.ACTIVEX) { 
				
				if (action.hasEventListener(PlayerType.ACTIVEX)) {
					dispatchActionEvent(new Event(PlayerType.ACTIVEX));
				}
				
				if (action.activeXPlayerTypeEffect) { 
					playEffect(action.activeXPlayerTypeEffect);
				}
				
			}
			else if (playerType==PlayerType.DESKTOP) {
				
				// this is also device
				if (action.hasEventListener(PlayerType.DESKTOP)) {
					dispatchActionEvent(new Event(PlayerType.DESKTOP));
				}
				
				if (action.desktopPlayerTypeEffect) { 
					playEffect(action.desktopPlayerTypeEffect);
				}
				
			}
			else if (playerType==PlayerType.EXTERNAL) { 
				
				if (action.hasEventListener(PlayerType.EXTERNAL)) {
					dispatchActionEvent(new Event(PlayerType.EXTERNAL));
				}
				
				if (action.externalPlayerTypeEffect) { 
					playEffect(action.externalPlayerTypeEffect);
				}
				
			}
			else if (playerType==PlayerType.PLUGIN) { 
				
				if (action.hasEventListener(PlayerType.PLUGIN)) {
					dispatchActionEvent(new Event(PlayerType.PLUGIN));
				}
				
				if (action.plugInPlayerTypeEffect) { 
					playEffect(action.plugInPlayerTypeEffect);
				}
				
			}
			else if (playerType==PlayerType.STANDALONE) { 
				
				if (action.hasEventListener(PlayerType.STANDALONE)) {
					dispatchActionEvent(new Event(PlayerType.STANDALONE));
				}
				
				if (action.standAlonePlayerTypeEffect) { 
					playEffect(action.standAlonePlayerTypeEffect);
				}
				
			}
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			finish();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
	}
	
	
}