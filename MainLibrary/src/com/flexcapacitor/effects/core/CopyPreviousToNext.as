

package com.flexcapacitor.effects.core {
	
	import com.flexcapacitor.effects.core.supportClasses.CopyPreviousToNextInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	/**
	 * Copies a value from the effect directly before this one into the effect directly after this one.
	 * It gets the value of the "data" property by default in the effect before and copies it to the data property
	 * by default in the effect after it. <br/><br/>
	 * 
	 * <b>Usage</b>:<br/>
	 * The following gets the data from the GetDataFromTarget effect 
	 * and copies it to the Trace effect after. Both effects have a property named "data":
<pre>
&lt;handlers:EventHandler eventName="click" target="{button}">
 	&lt;core:GetDataFromTarget target="{myTextInput}" targetPropertyName="text"/>
	
	&lt;core:CopyPreviousToNext />
	
	&lt;debugging:Trace />
&lt;handlers:EventHandler>
</pre>
	 * 
	 * If value in the data property of the previous or next effect is an object you can set the targetSubPropertyName
	 * and sourceSubPropertyName to get values on that object.<br/><br/>
	 * 
	 * If value in the data property of the previous or next effect is a list you can set the targetPropertyIndex 
	 * and sourcePropertyIndex to get the value at that index.<br/><br/>
	 * 
	 * You can cast the value to a type by setting the valueType property. <br/><br/>
	 * 
	 * Note: It is necessary to cast to type "String" when getting a String value from an XML object.<br/><br/>
	 * 
	 * You can set the previousEffectIndex to target an effect at a different index than the index of the previous effect. 
	 * <br/><br/>
	 * 
	 * You can set the nextEffectIndex to target an effect at a different index than the index of the next effect.<br/><br/>
	 *  
	 * You can set the targetEffectIndices to copy data to multiple effects<br/><br/>
	 * 
	 * You can change the default property name from "data" to another value using the sourcePropertyName and
	 * targetPropertyName properties. 
	 * */
	public class CopyPreviousToNext extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 * */
		public function CopyPreviousToNext(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			
			instanceClass = CopyPreviousToNextInstance;
		}
		
		/**
		 * Name of property on the next effect that will be set.
		 * The default property name is "data".
		 * */
		public var targetPropertyName:String = "data";
		
		/**
		 * If the property on the target is an array then 
		 * you can set the index in the targetPropertyIndex. 
		 * Default is -1.
		 * */
		public var targetPropertyIndex:int = -1;
		
		/**
		 * Name of property on previous effect that contains the value to copy.
		 * If the property is an array then you can set the index in the sourcePropertyIndex. 
		 * The default property name is "data".
		 * */
		public var sourcePropertyName:String = "data";
		
		/**
		 * If the property on the previous effect is an array then 
		 * you can set the index in the sourcePropertyIndex. 
		 * Default is -1.
		 * */
		public var sourcePropertyIndex:int = -1;
		
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
		public var valueType:Object;
		
		/**
		 * Allows you to get an effect further back than just the previous effect.
		 * When the value is 1 it gets the 1st effect prior to this one. 
		 * If the value is 2 it gets the 2nd effect prior to this one.
		 * Default is 1.
		 * */
		public var previousEffectDistance:int = 1;
		
		/**
		 * Allows you to set an effect further ahead than just the next effect.
		 * When the value is 1 it sets the 1st effect after this one. 
		 * If the value is 2 it sets the 2nd effect after this one.
		 * Default is 1.
		 * */
		public var nextEffectDistance:int = 1;
		
		/**
		 * Allows you to copy the values to more than one effect.
		 * For example, to copy values to the next three effects 
		 * set the value to "1,2,3".
		 * */
		public var targetEffectIndices:Object;
		
		/**
		 * When true traces the value to the console. 
		 * */
		public var inspectValue:Boolean;
		
	}
}