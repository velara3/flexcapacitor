

package com.flexcapacitor.effects.clipboard {
	
	import com.flexcapacitor.effects.clipboard.supportClasses.CopyToClipboardInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.desktop.ClipboardFormats;
	import flash.display.DisplayObjectContainer;
	

	/**
	 * Copies data to the clipboard. <br/><br/>
	 * 
	 * For this to work correctly in the browser it must be run in the bubble phase of a 
	 * click event. You cannot automatically copy to the clipboard without user interaction. 
	 * 
	 * For AIR you do not need to set the target or targetAncestor property.
	 * 
	 * Add a "copy to clipboard" type of button for the user to click, set the targetAncestor property of this effect 
	 * to a parent container of the button (usually you can set it to the "this" keyword)
	 * and run the effect in the button click handler.<br/><br/><br/>
	 * <pre><code>
		&lt;handlers:EventHandler eventName="click" target="{list}" >
			
				&lt;clipboard:CopyToClipboard data="{dataForTheClipboard}" targetAncestor="{anyParentContainer}" />
			
		&lt;/handlers:EventHandler></code></pre>
	 * 
	 * NOTE: If nothing is happening make sure that you set the targetAncestor property to a display object
	 * that is a parent of the target (event target) and that there is no pause or duration between the 
	 * click event and this effect.
	 * 
	 * What we are trying to do is add an event listener for the click event while the click event is in progress.
	 * To do this it has to be added to a parent of the display object that generated the click event. 
	 * 
	 * IE no other effect that has a duration can run before this one.<br/><br/>
	 * 
	 * @copy flash.desktop.Clipboard
	 * */
	public class CopyToClipboard extends ActionEffect {
		
		
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
		public function CopyToClipboard(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			
			instanceClass = CopyToClipboardInstance;
			
		}
		
		/**
		 * Data to be copied to the clipboard
		 * */
		public var data:Object;
		
		/**
		 * @copy flash.desktop.Clipboard#clear()
		 * */
		public var clearClipboard:Boolean = true;
		
		/**
		 * @copy flash.desktop.Clipboard@serializable;
		 * */
		public var serializable:Boolean;
		
		/**
		 * Format of content being copied to the clipboard
		 * 
		 * @copy flash.desktop.Clipboard#setData()
		 * */
		[Inspectable]
		public var format:String = ClipboardFormats.TEXT_FORMAT;
		
		/**
		 * An ancestor of the display object generating the click event. You can most likely 
		 * set this property to the this keyword. 
		 * Note: Setting the contents of the clipboard requires a click event to 
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
		 * Indicates to add a listener to the targetAncestor. 
		 * You do not set this. 
		 * */
		public var invokeCopyToClipboard:Boolean;
		
		/**
		 * Allow the data to be null. If set to false and the data is null then an error
		 * is thrown. If set to true and the data is null no error is thrown
		 * */
		public var allowNullData:Boolean;
	}
}