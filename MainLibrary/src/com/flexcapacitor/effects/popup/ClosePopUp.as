
/////////////////////////////////////////////////////////////////////////
//
// EFFECT
//
/////////////////////////////////////////////////////////////////////////

package com.flexcapacitor.effects.popup {
	import com.flexcapacitor.effects.popup.supportClasses.ClosePopUpInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	
	/**
	 * Closes a pop up.<br/><br/>
	 * 
	 * Typically you use it with OpenPopUp or ShowStatusMessage.
	 * 
	 * Opening a pop up:<br/>
	 * <pre>
&lt;popup:OpenPopUp id="openExportToImageEffect" 
		 popUpType="{ExportToImage}" 
		 modalDuration="250"
		 showDropShadow="true"
		 modalBlurAmount="1"
		 keepReference="true"
		 options="{{source:myImage.source, data:dataGrid.selectedItem}}">
&lt;/popup:OpenPopUp>
					 
	 * </pre>
	 * 
	 * To Use:<br/>
	 * <pre>
	 * 	&lt;popup:ClosePopUp popUp="{openPopUp.popUp}" />
	 * </pre>
	 * 
	 * To use when inside the pop up use:<br/>
	 * <pre>
	 * 	&lt;popup:ClosePopUp popUp="{this}" />
	 * </pre>
	 * 
	 * Note: If there is flicker when closing then be sure to set the triggerEvent of this 
	 * effect. 
	 * */
	public class ClosePopUp extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 *
		 *  @param target The Object to animate with this effect.
		 * 
		 */
		public function ClosePopUp(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			instanceClass = ClosePopUpInstance;
		}
		
		/**
		 * Popup instance
		 * */
		public var popUp:Object;
		
		/**
		 * Since a popup can be removed by clicking outside of it's self the 
		 * callout may be null. To throw an error when it's null set this to false.
		 * */
		public var popUpCanBeNull:Boolean = true;
	}
}

