
package com.flexcapacitor.effects.core.supportClasses {
	import com.flexcapacitor.effects.core.CallMethod;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	
	/**
	 *  @copy CallMethod
	 * */  
	public class CallMethodInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function CallMethodInstance(target:Object) {
			super(target);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  functionName
		//----------------------------------
		
		/** 
		 *  @copy spark.effects.CallAction#functionName
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 * */
		public var methodName:String;
		
		//----------------------------------
		//  function
		//----------------------------------
		
		/** 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 * */
		public var method:Function;
		
		//----------------------------------
		//  args
		//----------------------------------
		
		/** 
		 *  @copy spark.effects.CallAction#args
		 * */
		public var arguments:Array;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override public function play():void {
			super.play();   // Dispatch an effectStart event from the target.
			
			var action:CallMethod = CallMethod(effect);
			var methodName:String = action.methodName;
			var method:Function = action.method;
			var methodArguments:Array = action.arguments;
			var returnValue:Object;
			
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				if (!target) {
					dispatchErrorEvent("Target is required.");
				}
				
				if (methodName && !(methodName in target)) {
					
					// NOTE!!! target is probably not set, method name incorrect or method is not public
					// It should be the document the method is defined in.
					// Usually setting it to "this" works
					dispatchErrorEvent("The method is not on the target. Check if the method name is spelled correctly, the target is set and marked public.");
				}
				
				if (methodName==null && method==null) {
					dispatchErrorEvent("The method or method name is not set.");
				}
			}
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			if (method!=null) {
				
				if (methodArguments) {
					returnValue = method.apply(action, methodArguments);
				}
				else {
					returnValue = method.apply(action);
				}
			}
			else {
				if (methodArguments) {
					method = target[methodName];
					returnValue = method.apply(target, methodArguments);
				}
				else {
					returnValue = target[methodName]();
				}
			}
			
			action.data = returnValue;
			
			///////////////////////////////////////////////////////////
			// End the effect
			///////////////////////////////////////////////////////////
			finish();
		}
		
	}
}
