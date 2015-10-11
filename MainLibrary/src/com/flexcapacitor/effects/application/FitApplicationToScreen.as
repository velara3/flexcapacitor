

package com.flexcapacitor.effects.application {
	
	import com.flexcapacitor.effects.application.supportClasses.FitApplicationToScreenInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	
	/**
	 * Fits the application to the screen size
<pre>
&lt;handlers:EventHandler target="{this}" eventNames="{['initialize,'creationComplete']}" >
	&lt;local:FitApplicationToScreen target="{this}" centerApplication="true" includeTitleBar="true"/>
&lt;/handlers:EventHandler>
</pre>
	 * */
	public class FitApplicationToScreen extends ActionEffect {
		
		
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
		public function FitApplicationToScreen(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			//TypeError: Error #1034: Type Coercion failed: cannot convert com.flexcapacitor.effects.application::FitApplicationToScreen@8619301 to mx.effects.IEffectInstance.
			//		at mx.effects::Effect/createInstance()[E:\dev\4.y\frameworks\projects\framework\src\mx\effects\Effect.as:1102]
			//		at com.flexcapacitor.effects.supportClasses
		
			//instanceClass = FitApplicationToScreenInstance;
			instanceClass = FitApplicationToScreenInstance;
			
		}
		
		/**
		 * Reference to the Application to size. If not set then the 
		 * FlexGlobals.topLevelApplication is used.
		 * */
		[Bindable]
		public var application:Object;
		
		
		/**
		 * Centers the application
		 * */
		public var centerApplication:Boolean = true;
		public var widthRatio:Number = .85;
		public var heightRatio:Number = .88;
		public var includeTitleBar:Boolean = true;
		public var titleBarHeight:Number = 32;
	}
}