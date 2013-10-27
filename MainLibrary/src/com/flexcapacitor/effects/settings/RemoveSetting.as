

package com.flexcapacitor.effects.settings {
	
	import com.flexcapacitor.effects.settings.supportClasses.RemoveSettingInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.net.SharedObject;
	
	import mx.effects.Effect;
	import flash.events.NetStatusEvent;
	import flash.events.AsyncErrorEvent;
	
	
	/**
	 * Event when there is an error during remove
	 * */
	[Event(name="error", type="flash.events.Event")]
	
	/**
	 * Event when a setting was removed successfully
	 * */
	[Event(name="removed", type="flash.events.Event")]
	
	/**
	 * Event when save is pending
	 * 
	 * */
	[Event(name="pending", type="flash.events.Event")]

	/**
	 * Removes a setting previously saved to disk
	 * This abstracts the Shared Object class. 
	 * 
	 * The localPath property is the path to the shared object. 
	 * By default this value is null. <br/><br/>
	 * 
	 * <b>Usage:</b><br/>
	 * To remove all settings with the name, "AllGameSettings" use the following,
<pre>
&lt;settings:RemoveSetting id="removeSetting" name="AllGameSettings" >
	&lt;settings:pendingEffect>
		&lt;status:ShowStatusMessage message="Settings will be removed"/>
	&lt;/settings:pendingEffect>
	&lt;settings:removedEffect>
		&lt;status:ShowStatusMessage message="Settings were removed"/>
	&lt;/settings:removedEffect>
	&lt;settings:errorEffect>
		&lt;status:ShowStatusMessage message="An error occured when attempting to remove the settings" data="{removeSetting.errorEvent}"/>
	&lt;/settings:errorEffect>
&lt;/settings:RemoveSetting>
</pre>
	 * <b>Usage:</b><br/>
	 * To save a score for a game and then immediately remove it use the following,
<pre>
&lt;settings:SaveSetting name="MyGameSettings" property="score" data="1000" id="saveSetting">
	&lt;settings:savedEffect>
		&lt;status:ShowStatusMessage message="Value is was saved successfully"/>
	&lt;/settings:savedEffect>
	&lt;settings:pendingEffect>
		&lt;status:ShowStatusMessage message="Value will be saved on exit"/>
	&lt;/settings:pendingEffect>
	&lt;settings:errorEffect>
		&lt;status:ShowStatusMessage message="An error occured when attempting to save!" data="{saveSetting.errorEvent}"/>
	&lt;/settings:errorEffect>
&lt;/settings:SaveSetting>
 * 

&lt;settings:RemoveSetting id="removeSetting" name="MyGameSettings" property="score">
	&lt;settings:pendingEffect>
		&lt;status:ShowStatusMessage message="The setting property will be removed"/>
	&lt;/settings:pendingEffect>
	&lt;settings:removedEffect>
		&lt;status:ShowStatusMessage message="The setting property was removed"/>
	&lt;/settings:removedEffect>
	&lt;settings:errorEffect>
		&lt;status:ShowStatusMessage message="An error occured when attempting to remove the setting property" data="{removeSetting.errorEvent}"/>
	&lt;/settings:errorEffect>
&lt;/settings:RemoveSetting>
 * 
</pre>
	 * 
	 * For errors see http://www.actionscripterrors.com/?p=806
	 * 
	 * <br/><br/>
 	 * @see GetSetting
	 * @see GetSettings
 	 * @see SaveSetting
 	 * @see SaveSettings
	 * */
	public class RemoveSetting extends ActionEffect {
		
		public static const ERROR:String = "error";
		public static const REMOVED:String = "removed";
		public static const PENDING:String = "pending";
		
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
		public function RemoveSetting(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			

			instanceClass = RemoveSettingInstance;
			
		}
		
		/**
		 * Applies the remove immediately.<br/>
		 * 
		 * @copy flash.net.SharedObject.flush()
		 * */
		public var applyImmediately:Boolean = true;
		
		/**
		 * Reference to the shared object
		 * */
		public var sharedObject:SharedObject;
		
		/**
		 * Name of setting. Required. 
		 * Cannot contain spaces. <br/><br/>
		 * 
		 * For errors see http://www.actionscripterrors.com/?p=806
		 * */
		public var name:String;
		
		/**
		 * Name of property. Optional. 
		 * Cannot contain spaces. <br/><br/>
		 * 
		 * For errors see http://www.actionscripterrors.com/?p=806
		 * */
		public var property:String;
		
		/**
		 * Name of path for the setting. Default is null. 
		 * Optional. The name can include forward slashes (/); for example, 
		 * work/addresses is a legal name. 
		 * Spaces are not allowed in the name, nor are the following characters: 
		 * ˜ % & \ ; : ' , < > ? #
		 *  
		 * For errors see http://www.actionscripterrors.com/?p=806<br/>
		 * 
		 * @copy flash.net.SharedObject.getLocal()
		 * */
		public var localPath:String;
		
		/**
		 * If this parameter is set to true, creates a new secure settings file 
		 * (ie shared object) or gets a reference to an existing secure shared object. 
		 * 
		 * If your SWF file is delivered over a non-HTTPS connection and you try to set 
		 * this parameter to true, the creation of a new shared object (or the access of 
		 * a previously created secure shared object) fails and null is returned. <br/>
		 * 
		 * @copy flash.net.SharedObject.getLocal()
		 * */
		public var secure:Boolean;
		
		/**
		 * Minimum amount of space in bytes to request when more space is needed. 
		 * Default is 0.<br/>
		 * 
		 * @copy flash.net.SharedObject.flush()
		 * */
		public var minimumSettingsSpace:int;
		
		/**
		 * Reference to error event when a shared object error event occurs.
		 * */
		[Bindable]
		public var errorEvent:Object;
		
		/**
		 * Reference to AsyncErrorEvent when an AsyncError event occurs.
		 * */
		[Bindable]
		public var asyncErrorEvent:AsyncErrorEvent;
		
		/**
		 * Reference to NetStatusEvent when an NetStatus event occurs.
		 * */
		[Bindable]
		public var netStatusEvent:NetStatusEvent;
		
		/**
		 * Effect to play when an error occurs when attempting to remove a setting. 
		 * 
		 * @copy flash.net.SharedObject
		 * */
		public var errorEffect:Effect;
		
		/**
		 * Effect to play when the remove is pending. 
		 * 
		 * @copy flash.net.SharedObject.flush()
		 * */
		public var pendingEffect:Effect;
		
		/**
		 * Effect to play when the remove is successful. 
		 * 
		 * @copy flash.net.SharedObject.flush()
		 * */
		public var removedEffect:Effect;
		
	}
}