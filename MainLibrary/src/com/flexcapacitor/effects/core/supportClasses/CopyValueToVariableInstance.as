

package com.flexcapacitor.effects.core.supportClasses {
	import com.flexcapacitor.effects.core.CopyValueToVariable;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	/**
	 *  The CopyToInstance class implements the instance class
	 *  for the XML action effect.
	 *  Flex creates an instance of this class when it plays a action
	 *  effect; you do not create one yourself.
	 *
	 *  @see com.flexcapacitor.effects.xml.action
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */  
	public class CopyValueToVariableInstance extends ActionEffectInstance {
		
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
		public function CopyValueToVariableInstance(target:Object) {
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
		 */
		override public function play():void {
			// Dispatch an effectStart event
			super.play();
			
			var action:CopyValueToVariable = CopyValueToVariable(effect);
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			if (action.target==null || action.targetPropertyName==null
				|| action.source==null || action.sourcePropertyName==null) {
				cancel();
				throw new Error("A required property is not set. If the source or target objects are not applicable set it to the keyword 'this'");
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			action.targetPropertyName = action.source[action.sourcePropertyName];
			
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		
	}
}