

package com.flexcapacitor.effects.email {
	
	import com.flexcapacitor.effects.email.supportClasses.OpenMailInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	
	/**
	 * Opens the default email application.
	 * */
	public class OpenMail extends ActionEffect {
		
		public static var PLAIN_TEXT_LINEBREAK:String = "%0a";
		public static var HTML_TEXT_LINEBREAK:String = "<br/>";
		
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
		public function OpenMail(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target)
				target = new Object();
			
			super(target);
			
			
			instanceClass = OpenMailInstance;
			
		}
		
		/**
		 * The receipient
		 * */
		public var to:String;
		
		/**
		 * The subject
		 * */
		public var subject:String;
		
		/**
		 * The message body
		 * */
		public var data:String;
		
		/**
		 * The line break character. 
		 * The plain text value is %0a.
		 * The HTML value is &lt;br/&gt;
		 * */
		[Inspectable(enumeration="plain,html")]
		public var linbreak:String;
		
		/**
		 * Limit of total characters that make up a mail to link. 
		 * Many email clients do not open when the maito link is more than 
		 * a defined number of characters. 
		 * */
		public var bodyLimit:int = 1000;
		
		/**
		 * Behavior if total charactter limit is reached.
		 * None does nothing.
		 * Truncate strips the content to fit the body limit character count.
		 * Clip removes the body content and places alternative text if defined
		 * */
		public var overflow:String = "truncate";
		
		/**
		 * Alternative body content if the overflow is set to clip. Optional.
		 * */
		public var alternativeBody:String;
	}
}