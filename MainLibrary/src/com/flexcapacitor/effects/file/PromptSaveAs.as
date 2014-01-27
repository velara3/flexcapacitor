

package com.flexcapacitor.effects.file {
	
	import com.flexcapacitor.effects.file.supportClasses.PromptSaveAsInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.display.DisplayObjectContainer;
	import flash.net.FileReference;
	
	import mx.effects.IEffect;
	
	
	/**
	 * Dispatched on the file browse select event
	 * @copy file.net.FileReference.select
	 * */
	[Event(name="save", type="flash.events.Event")]
	
	/**
	 * Dispatched on the file browse cancel event
	 * @copy file.net.FileReference.cancel
	 * */
	[Event(name="cancel", type="flash.events.Event")]
	
	/**
	 * Opens a native Save as dialog to save data to a file. 
	 * Set the data property to the contents of the file. <br/><br/>
	 * 
	 * NOTE! If nothing happens or you have to click the button twice
	 * make sure that the button or *buttons* 
	 * that are triggering this event have the targetAncestor property set and 
	 * that the target ancestor is a parent or owner of the button or buttons 
	 * and that there is no pause or duration effect between the click event and 
	 * this effect. See code example. <br/><br/>
	 * 
	 * IE no other effect that has a duration can run before this one.<br/><br/>
	 * 
	 * This effect MUST be called within the bubbling of a click event. 
	 * If another effect is run before this one this effect may not be run in time. <br/><br/>
	 * 
<pre>
 &lt;handlers:EventHandler eventName="click" 
					   target="{exportButton}">
											
	&lt;file:PromptSaveAs id="promptFile" 
					   targetAncestor="{this}"
					   data="Save this value to a file"
					   fileName="MyDocument"
					   fileExtension="txt"
					   >
		&lt;file:saveEffect>
			&lt;s:Sequence>
				&lt;status:ShowStatusMessage startDelay="500" message="The file was saved successfully."/>
			&lt;/s:Sequence>
		&lt;/file:saveEffect>
		&lt;file:cancelEffect>
			&lt;s:Sequence>
				&lt;status:ShowStatusMessage startDelay="500" message="The user canceled the dialog."/>
			&lt;/s:Sequence>
		&lt;/file:cancelEffect>
	&lt;/file:PromptSaveAs>
&lt;/handlers:EventHandler>
</pre>
	 * 
	 * @see SaveDataToFile
	 * */
	public class PromptSaveAs extends ActionEffect {
		
		public static const SAVE:String 		= "save";
		public static const CANCEL:String 		= "cancel";
		
		/**
		 *  Constructor.
		 * */
		public function PromptSaveAs(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target) {
				target = new Object();
			}
			
			super(target);
			
			instanceClass = PromptSaveAsInstance;
			
		}
		
		
		/**
		 * Suggested file name
		 * */
		public var fileName:String;
		
		/**
		 * @copy FileReference#save()
		 * */
		public var data:Object;
		
		/**
		 * Prints the file URL to the console.
		 * */
		public var traceFileURL:Boolean;
		
		/**
		 * Prints the file native path to the console.
		 * */
		public var traceFileNativePath:Boolean;
		
		/**
		 * Reference to the selected file. Use fileReferenceList if
		 * multiple files were expected. 
		 * 
		 * @see allowMultipleSelection
		 * */
		[Bindable]
		public var fileReference:FileReference;
		
		/**
		 * An ancestor of the display object generating the click event. You can most likely 
		 * set this property to the this keyword. 
		 * Note: Browsing for a file while in the browser requires a button event to 
		 * pass the security sandbox. 
		 * */
		public function set targetAncestor(value:DisplayObjectContainer):void {
			_targetAncestor = value;
		}
		
		public function get targetAncestor():DisplayObjectContainer {
			return _targetAncestor;
		}
		private var _targetAncestor:DisplayObjectContainer;
		
		/**
		 * Flag indicating to open a save as file dialog. You do not set this. 
		 * */
		public var invokeSaveAsDialog:Boolean;
		
		/**
		 * Throws an error if data is null
		 * */
		public var throwErrorOnNoData:Boolean = true;
		
		/**
		 * File extension. 
		 * */
		public var fileExtension:String = "txt";
		
		/**
		 * Effect played on the file save event
		 * */
		public var saveEffect:IEffect;
		
		/**
		 * Effect played on the file cancel event
		 * */
		public var cancelEffect:IEffect;
		
	}
}