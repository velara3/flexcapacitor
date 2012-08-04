
package com.flexcapacitor.effects.core {
	import com.flexcapacitor.effects.core.supportClasses.CallMethodInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import mx.effects.IEffectInstance;
	
	//--------------------------------------
	//  Excluded APIs
	//--------------------------------------
	
	[Exclude(name="duration", kind="property")]
	
	/**
	 * The CallMethod effect calls the function specified by 
	 * <code>methodName</code> property on the <code>target</code> object with
	 * optional arguments specified by the <code>arguments</code> property. <br/><br/>
	 * 
	 * The target property must be set and the method needs to be public to be seen by this class.<br/><br/>
	 * 
	 * The effect is useful in
	 * effect sequences where a function call can be included as part of 
	 * a composite effect.
	 *  
	 *  @mxml
	 *
	 *  <p>The <code>&lt;s:CallMethod&gt;</code> tag
	 *  inherits all of the tag attributes of its superclass,
	 *  and adds the following tag attributes:</p>
	 *
	 *  <pre>
	 *  &lt;s:CallMethod
	 *    <b>Properties</b>
	 *    id="ID"
	 *    methodName="no default"
	 *    arguments="no default"
	 *    data=""
	 *  /&gt;
	 *  </pre>
	 * */
	public class CallMethod extends ActionEffect {
		//include "../core/Version.as";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function CallMethod(target:Object = null) {
			super(target);
			duration = 0;
			instanceClass = CallMethodInstance;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  data
		//----------------------------------
		
		/**
		 *  The return value from calling the function (if any)
		 * */
		[Bindable]
		public var data:Object;
		
		//----------------------------------
		//  methodName
		//----------------------------------
		
		/** 
		 * Name of the function called on the target when this effect plays.
		 * */
		public var methodName:String;
		
		/** 
		 * The function to call. Set this or the method name.
		 * */
		public var method:Function;
		
		//----------------------------------
		//  Arguments
		//----------------------------------
		
		/** 
		 * Arguments passed to the function that is called
		 * by this effect.
		 * */
		public var arguments:Array =[];
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 * */
		override protected function initInstance(instance:IEffectInstance):void {
			super.initInstance(instance);
			
			var callInstance:CallMethodInstance = CallMethodInstance(instance);
			
			callInstance.method = method;
			callInstance.methodName = methodName;
			callInstance.arguments = arguments;
		}
		
	}
	
}
