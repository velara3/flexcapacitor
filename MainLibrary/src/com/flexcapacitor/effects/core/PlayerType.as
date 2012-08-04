

package com.flexcapacitor.effects.core {
	
	import com.flexcapacitor.effects.core.supportClasses.PlayerTypeInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import mx.effects.Effect;
	
	
	/**
	 * Event dispatched when player type is ActiveX
	 * */
	[Event(name="ActiveX", type="flash.events.Event")]
	
	/**
	 * Event dispatched when player type is Desktop
	 * or Device
	 * */
	[Event(name="Desktop", type="flash.events.Event")]
	
	/**
	 * Event dispatched when player type is External
	 * */
	[Event(name="External", type="flash.events.Event")]
	
	/**
	 * Event dispatched when player type is PlugIn
	 * */
	[Event(name="PlugIn", type="flash.events.Event")]
	
	/**
	 * Event dispatched when player type is StandAlone
	 * */
	[Event(name="StandAlone", type="flash.events.Event")]
	
	
	/**
	 * Checks the type of player and runs the effects you define for that player.
	 * */
	public class PlayerType extends ActionEffect {
		
		/**
		 * Active X player type. The control used by Microsoft Internet Explorer
		 * */
		public static const ACTIVEX:String = "ActiveX";
		
		/**
		 * Desktop or device player type. The Adobe AIR runtime (except for SWF content loaded by 
		 * an HTML page, which has Capabilities.playerType set to "PlugIn").
		 * */
		public static const DESKTOP:String = "Desktop";
		
		/**
		 * External player type. The external Flash Player or in test mode. 
		 * */
		public static const EXTERNAL:String = "External";
		
		/**
		 * Plug in player type. The Flash Player browser plug-in (and for 
		 * SWF content loaded by an HTML page in an AIR application)
		 * */
		public static const PLUGIN:String = "PlugIn";
		
		/**
		 * Stand Alone player type. The stand-alone Flash Player.
		 * */
		public static const STANDALONE:String = "StandAlone";
		
		
		
		/**
		 *  Constructor.
		 *
		 *  @param target The Object to animate with this effect.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function PlayerType(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			
			instanceClass = PlayerTypeInstance;
			
		}
		
		/**
		 * Effect that is played if the player is of type activeX.
		 * */
		public var activeXPlayerTypeEffect:Effect;
		
		/**
		 * Effect that is played if the player is of type desktop, device or device emulation.
		 * */
		public var desktopPlayerTypeEffect:Effect;
		
		/**
		 * Effect that is played if the player is of type external.
		 * */
		public var externalPlayerTypeEffect:Effect;
		
		/**
		 * Effect that is played if the player is of type plug in.
		 * This appears to be run when the application is run in the browser
		 * */
		public var plugInPlayerTypeEffect:Effect;
		
		/**
		 * Effect that is played if the player is of type stand alone.
		 * */
		public var standAlonePlayerTypeEffect:Effect;
		
	}
}