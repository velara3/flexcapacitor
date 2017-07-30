

package com.flexcapacitor.effects.core {
	
	import com.flexcapacitor.effects.core.supportClasses.CopyDataToTargetInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	
	/**
	 * Copies the value in the data property or the value in the property on the source property 
	 * to the target object<br/><br/>
	 * 
	 * <b>Usage</b>:<br/>
	 * To copy the value of 10 to a text input named, "myTextInput" use the following:
<pre>
&ltcore:CopyDataToTarget data="10" 
 * target="{myTextInput}" 
 * targetPropertyName="text"/>
</pre>
	 * 
	 * If data property is not set and there is no error then try setting the 
	 * target to the parent on the original target and set the targetPropertyName like so,<br/><br/>
	 * 
	 * Before:<br/>
	 * target = "{objectA}";<br/><br/>
	 * 
	 * After:<br/>
	 * target = "{parentOfObjectA}" targetPropertyName="objectA" 
	 * 
	 * @see SetAction
	 * */
	public class CopyDataToTarget extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 *
		 *  @param target The Object that contains the property that will be set to the source value.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function CopyDataToTarget(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			duration = 0;
			
			instanceClass = CopyDataToTargetInstance;
		}
		
		/**
		 * Value to assign to target. If the source is set this is not used.
		 * */
		[Bindable]
		public var data:*;
		
		/**
		 * Source object that is used if set. You can get a property value 
		 * or property index by setting the sourcePropertyName or sourcePropertyIndex
		 * */
		[Bindable]
		public var source:Object;
		
		/**
		 * Name of property on source object. If the property is an array then 
		 * you can set the index in the sourcePropertyIndex. 
		 * */
		public var sourcePropertyName:String;
		
		/**
		 * If the property on the source is an array then 
		 * you can set the index in the sourcePropertyIndex. 
		 * Default is -1.
		 * */
		public var sourcePropertyIndex:int = -1;
		
		/**
		 * Name of property on target object. See source and sourcePropertyName.
		 * */
		public var targetPropertyName:String;
		
		/**
		 * If the property on the target is an array then 
		 * you can set the index in the targetPropertyIndex. 
		 * Default is -1.
		 * */
		public var targetPropertyIndex:int = -1;
		
		/**
		 * Copy sub property with the name specified
		 * */
		public var sourceSubPropertyName:String;
		
		/**
		 * Copy sub property with the name specified
		 * */
		public var targetSubPropertyName:String;
		
		/**
		 * Casts the value to the type. Default is null.
		 * You would use this for example, to case an attribute on a
		 * XML node to a string. If you are not using this that attribute
		 * might be interpreted as an XMLList
		 * */
		public var dataType:Object;
		
		/**
		 * When true traces the value to the console. 
		 * */
		public var inspectData:Boolean;
		
		/**
		 * Convert object to string
		 * */
		public var convertObjectToString:Boolean;
		
		/**
		 * If data is null throw error
		 **/
		public var throwErrorIfDataIsNull:Boolean = true;
	}
}