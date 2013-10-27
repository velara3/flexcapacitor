
package com.flexcapacitor.effects.core {
	
	
	import com.flexcapacitor.effects.core.supportClasses.SetActionInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import mx.core.mx_internal;
	import mx.effects.IEffectInstance;
	
	//--------------------------------------
	//  Excluded APIs
	//--------------------------------------
	
	[Exclude(name="duration", kind="property")]
	
	/**
	 * The same as spark.effects.SetAction except it extends the ActionEffect class<br/><br/>
	 * 
	 * SetAction is more framework aware. Use it for setting properties on UIComponents and
	 * visual elements. <br/><br/>
	 * 
	 * Notes: There are things in this class that should be in CopyDataToTarget
	 * and things in CopyDataToTarget that should be in this class. At some point these
	 * both need to be aligned with spark.effects and com.flexcapacitor.effects. <br/>
	 * 
	 * @copy spark.effects.SetAction
	 * 
	 * @see com.flexcapacitor.effects.CopyDataToTarget
	 */
	public class SetAction extends ActionEffect {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
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
		public function SetAction(target:Object = null) {
			super(target);
			duration = 0;
			instanceClass = SetActionInstance;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  property
		//----------------------------------
		
		[Inspectable(category="General")]
		
		/** 
		 *  The name of the property being changed.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public var property:String;
		
		//----------------------------------
		//  propertyChangesArray
		//----------------------------------
		
		[Inspectable(category="General")]
		
		/** 
		 * Holds the init object passed in by the Transition.
		 * */
		public var propertyChangesArray:Array;
		
		//----------------------------------
		//  value
		//----------------------------------
		
		[Inspectable(category="General")]
		
		/** 
		 *  The new value for the property.
		 *  When run within a transition and value is not specified, Flex determines 
		 *  the value based on that set by the new view state.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public var value:*;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  relevantStyles
		//----------------------------------
		
		/**
		 *  @private
		 */
		override public function get relevantStyles():Array /* of String */
		{
			return [ property ];
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override public function getAffectedProperties():Array /* of String */
		{
			return [ property ];
		}
		
		/**
		 *  @private
		 */
		override protected function initInstance(instance:IEffectInstance):void
		{
			super.initInstance(instance);
			
			var actionInstance:SetActionInstance =
				SetActionInstance(instance);
			
			actionInstance.property = property;
			actionInstance.value = value;
			
		}
		
		override public function captureStartValues():void
		{
			super.captureStartValues();
			propertyChangesArray = mx_internal::propertyChangesArray;
			
		}
		
		
	}
	
}
