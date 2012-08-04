

package com.flexcapacitor.events {
	
	import flash.events.Event;
	
	import mx.effects.IEffectInstance;
	import mx.events.EffectEvent;
	
	/**
	 * Extends the mx.events.EffectEvent to add the EffectCancel event.
	 * */
	public class EffectEvent extends mx.events.EffectEvent {
		
		/**
		 *  The <code>EffectEvent.EFFECT_CANCEL</code> constant defines the value of the 
		 *  <code>type</code> property of the event object for an 
		 *  <code>effectCancel</code> event. 
		 *  
		 *  <p>The properties of the event object have the following values:</p>
		 *  <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td>false</td></tr>
		 *     <tr><td><code>cancelable</code></td><td>false</td></tr>
		 *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
		 *       event listener that handles the event. For example, if you use 
		 *       <code>myButton.addEventListener()</code> to register an event listener, 
		 *       myButton is the value of the <code>currentTarget</code>. </td></tr>
		 *     <tr><td><code>effectInstance</code></td><td>The effect instance object 
		 *       for the event.</td></tr>
		 *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
		 *       it is not always the Object listening for the event. 
		 *       Use the <code>currentTarget</code> property to always access the 
		 *       Object listening for the event.</td></tr>
		 *  </table>
		 *
		 *  @see mx.effects.Effect
		 *
		 *  @eventType effectCancel
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static const EFFECT_CANCEL:String = "effectCancel";
		public static const EFFECT_STOP:String = "effectStop";
		public static const EFFECT_END:String = "effectEnd";
		public static const EFFECT_START:String = "effectStart";
		public static const EFFECT_TIMEOUT:String = "effectTimeout";
		
		/**
		 * Used to indicate the reason for this event. 
		 * Mainly only used in the cancel event. 
		 * */
		public var message:String;
		
		
		public function EffectEvent(eventType:String, bubbles:Boolean=false, cancelable:Boolean=false, effectInstance:IEffectInstance=null, message:String = "") {
			this.message = message;
			super(eventType, bubbles, cancelable, effectInstance);
		}
		
		override public function clone():Event {
			return new com.flexcapacitor.events.EffectEvent(type, bubbles, cancelable, effectInstance, message);
		}
		
		
	}
}