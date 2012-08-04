

package com.flexcapacitor.effects.navigation {
	
	import com.flexcapacitor.effects.navigation.supportClasses.OpenURLInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.net.URLVariables;
	
	
	/**
	 * Opens a browser window (or replaces one if the targetWindow is set). 
	 * In Adobe AIR, the function opens a URL in the default system web browser
	 * @see flash.net.navigateToURL
	 * */
	public class OpenURL extends ActionEffect {
		
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
		public function OpenURL(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			
			instanceClass = OpenURLInstance;
			
		}
		
		/**
		 * @copy flash.net.URLRequest#url
		 * */
		public var URL:String;
		
		/**
		 * @copy flash.net.URLVariables
		 * */
		public var variables:URLVariables;
		
		/**
		 * The name of the target window. 
		 * Default is "_self". 
		 * To open in a new blank window or tab enter "_blank"
		 * 
		 * @see flash.net.navigateToURL
		 * */
		public var window:String = "_self";
	}
}