

package com.flexcapacitor.effects.example {
	
	import com.flexcapacitor.effects.example.supportClasses.ExampleActionInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import mx.effects.Effect;
	
	/**
	 * An example Action Effect
	 * */
	public class ExampleAction extends ActionEffect {
		
		
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
		public function ExampleAction(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = ExampleActionInstance;
		}
		
		/**
		 * Example property. We add the properties we need to perform the action
		 * Read more on Spark Effects 
		 * http://help.adobe.com/en_US/flex/using/WS4809A78C-9738-465d-B875-B0049C9B0ED4.html
		 * 
		 * We can copy the documentation
		 * written else where by using the copy tag. The first is a reference to a property. 
		 * The second is a reference to a method. The third is a reference to a class. 
		 * Nothing we write after the copy tag line is used. Place all comments before it.<br/>
		 * 
		 * @copy mx.effects.Effect#target 
		 * @copy mx.effects.Effect#end()
		 * @copy mx.effects.Effect
		 * */
		public var value:String;
		
		/**
		 * Store data we need
		 * */
		public var data:Object;
		
		/**
		 * If we need to handle an expected or unexpected situation 
		 * we can provide a property that can be set to an effect 
		 * that will be played when that condition is met
		 * */
		public var targetNotSetEffect:Effect;
		
	}
}