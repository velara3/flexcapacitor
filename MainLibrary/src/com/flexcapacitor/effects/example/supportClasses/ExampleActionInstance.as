

package com.flexcapacitor.effects.example.supportClasses {
	import flash.utils.getQualifiedClassName;
	
	import com.flexcapacitor.effects.example.ExampleAction;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	
	/**
	 *  The instance class for the ExampleAction effect. <br/><br/>
	 * 
	 *  Flex creates an instance of this class when it plays the ExampleAction
	 *  effect; you do not create one yourself.<br/><br/>
	 *  
	 *  This class is garbage collected after it has run or if it is part of 
	 *  a composite effect then after the composite effect has ended.<br/><br/>
	 *  
	 *  All the action takes place in the play method. Place your code there.<br/><br/>
	 * 
	 *  Two methods must be called at the end of the play method:
	 *  finish() or waitForHandlers(). <br/><br/>
	 * 
	 *  The finish method notifies the host Effect that it has completed it's 
	 *  task and ends the Effect. If the Effect is part of a sequence 
	 *  then the next Effect is played. <br/><br/>
	 * 
	 *  The waitForHandlers method pauses the effect instance. If the Effect 
	 *  is part of a composite effect such as a sequence then the sequence is 
	 *  paused. No further effects in the sequence are played. 
	 *  It is only when the finish() method is called that the Effect ends 
	 *  and the sequence continues. <br/><br/>
	 *  
	 *  A third method called cancel will end the effect and if part of a 
	 *  sequence ends the sequence. No effects positioned after it are run. <br/><br/>
	 *  
	 *  @copy mx.effects.effectClasses.TweenEffectInstance
	 *  
	 *  @see com.flexcapacitor.effects.example.ActionEffect
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4
	 */  
	public class ExampleActionInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *
		 *  @param target This argument is ignored by the effect.
		 *  It is included for consistency with other effects.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function ExampleActionInstance(target:Object) {
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
		 *  YOUR CODE GOES IN THE PLAY FUNCTION
		 * */
		override public function play():void {
			super.play(); // Required to dispatch startEffect
			
			var action:ExampleAction = ExampleAction(effect);
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				
				// if target is required we check for it here 
				if (!action.target) {
					
					// if it is not set then we cancel out of the effect 
					// we cancel the sequence even if we throw an error
					// to prevent possible further errors
					// If the effect is written to allow us to roll back 
					// the changes you would play the sequence in reverse
					// the cancel method will cancel the effect and the 
					// parent sequence as long as the parent sequence uses the 
					// playEffect 
					cancel("Target is required");
					
					
					// we can also play an effect for runtime situations
					// if it's set then use the playEffect method to play the effect
					if (action.targetNotSetEffect) {
						playEffect(action.targetNotSetEffect);
						// action.targetNotSetEffect.play() do not use this method
					}
					
					// notify the developer that an occured
					dispatchErrorEvent("Target is required");
				}
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// YOUR CODE HERE 
			// Trace a message to the console
			trace("Hello world! The target is a " + getQualifiedClassName(target));
			
			// Or set the properties of the target
			/*var component:UIComponent = UIComponent(action.target); // in a real case you would validate the type before hand
			component.visible = false;*/
			
			// Or if we need to wait for an event before continuing 
			// we can add an event listener and call waitForHandlers();
			/*action.target.addEventListener(Event.COMPLETE, myHandler);
			action.source = "large-image.jpg";
			waitForHandlers(); // our code continues in myHandler
			return;*/
			
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			
			// If we are done then we end the effect with finish()
			// This method must be called to continue to the next effect 
			// in the sequence (if part of a sequence)
			finish();
			
			// OR // 
			
			///////////////////////////////////////////////////////////
			// Pause the effect
			///////////////////////////////////////////////////////////
			
			// If we need to pause the effect we use waitForHandlers();
			// The action will pause until finish is called
			waitForHandlers();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * If we called waitForHandlers then we need to call finish() 
		 * before we can move on to the next effect in the sequence
		 * */
		protected function myHandler(event:Event):void {
			var action:ExampleAction = ExampleAction(effect);
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			// handle event here
			
			// Example, get bitmapData and set it on an effect property
			action.data = event.currentTarget.bitmapData;
			
			// Or set the source on the target (if target is an image)
			action.target.source = event.currentTarget.bitmapData;
			
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			// call finish() to end the effect and continue the sequence
			finish();
			
		}
		
	}
}