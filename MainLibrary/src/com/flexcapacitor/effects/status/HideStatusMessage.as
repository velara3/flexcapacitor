

package com.flexcapacitor.effects.status {
	
	import com.flexcapacitor.effects.status.supportClasses.HideStatusMessageInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	/**
	 * Removes a status message. Notice we set the statusMessagePopUp. Also notice we set 
	 * keepReference to true on the ShowStatusMessage instance. <br/><br/>
	 * 
	 * Usage: 
	 * 
	 * <pre>
&lt;status:ShowStatusMessage id="showRenderingStatus" message="Rendering" keepReference="true"/>
&lt;core:CallMethod method="renderImage" startDelay="250"/>
&lt;status:HideStatusMessage statusMessagePopUp="{showRenderingStatus.statusMessagePopUp}"/>
	 * </pre>
	 * 
	 * @see ShowStatusMessage
	 * */
	public class HideStatusMessage extends ActionEffect {
		
		
		/**
		 *  Constructor.
		 * */
		public function HideStatusMessage(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			duration = 2000;
			
			instanceClass = HideStatusMessageInstance;
		}
		
		/**
		 * Allows reference to the status message box to be null (meaning it could 
		 * have been closed). 
		 * */
		public var allowNullReference:Boolean;
		
		/**
		 * Function to run when status message is closed
		 * */
		public var closeHandler:Function;
		
		/**
		 * Reference to the status message object. Must set keep reference to true.
		 *  
		 * @see ShowStatusMessage.keepReference
		 * */
		[Bindable]
		public var statusMessagePopUp:Object;
		
		/**
		 * Fade out duration
		 * */
		public var fadeOutDuration:int = 250;
	}
}