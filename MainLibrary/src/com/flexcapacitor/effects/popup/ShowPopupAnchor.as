

package com.flexcapacitor.effects.popup {
	
	import com.flexcapacitor.effects.popup.supportClasses.ShowPopupAnchorInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import mx.core.IFlexDisplayObject;
	
	/**
	 * Shows a popup anchor
	 * */
	public class ShowPopupAnchor extends ActionEffect {
		
		
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
		public function ShowPopupAnchor(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = ShowPopupAnchorInstance;
		}
		
		/**
		 * @copy spark.components.PopUpAnchor#popUpHeightMatchesAnchorHeight
		 * */
		public var popUpHeightMatchesAnchorHeight:Boolean;
		
		/**
		 * @copy spark.components.PopUpAnchor#popUpWidthMatchesAnchorWidth
		 * */
		public var popUpWidthMatchesAnchorWidth:Boolean;
		
		/**
		 * @copy spark.components.PopUpAnchor#popUpPosition
		 * */
		[Inspectable(category="General", enumeration="left,right,above,below,center,topLeft", defaultValue="topLeft")]
		public var popUpPosition:String;
		
		/**
		 * @copy spark.components.PopUpAnchor#updatePopUpTransform
		 * */
		public var updatePopUpTransform:Boolean;
		
		/**
		 * @copy spark.components.PopUpAnchor#popUp
		 * */
		public var popUp:IFlexDisplayObject;
		
		/**
		 * Hide if already open
		 * */
		public var hideIfOpen:Boolean;
		
	}
}