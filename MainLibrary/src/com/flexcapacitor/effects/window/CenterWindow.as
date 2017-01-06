

package com.flexcapacitor.effects.window {
	
	import com.flexcapacitor.effects.window.supportClasses.CenterWindowInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	
	/**
	 * Centers a window or native window in the middle of the screen. 
	 * 
<pre>
&lt;handlers:EventHandler eventName="initialize" >
	&lt;window:CenterWindow target="{this}" offsetY="-30" />
&lt;/handlers:EventHandler>
</pre>
	 * */
	public class CenterWindow extends ActionEffect {
		
		
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
		public function CenterWindow(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = CenterWindowInstance;
			
		}
		
		/**
		 * Reference to the Window to center. If not set then the 
		 * target is used. If the target is not set then an error is thrown. 
		 * */
		[Bindable]
		public var window:Object;
		
		/**
		 * If set to true then no error is thrown when the application width and height are zero. 
		 * */
		public var ignoreWindowSizeError:Boolean;
		
		/**
		 * Amount to offset on the x axis
		 * */
		public var offsetX:int;
		
		/**
		 * Amount to offset on the y axis
		 * */
		public var offsetY:int;
		
		/**
		 * Include title bar offset when centered
		 * */
		public var includeTitleBar:Boolean = true;
		
		/**
		 * Height of title bar
		 * */
		public var titleBarHeight:Number = 32;
		
		/**
		 * If the target or the window property is not set then we 
		 * center the top level Application. If this is 
		 * set to false and those target or window is not set then
		 * an error is thrown. 
		 * */
		public var centerApplicationByDefault:Boolean = true;
		
	}
}