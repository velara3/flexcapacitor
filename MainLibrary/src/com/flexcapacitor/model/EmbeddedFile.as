
package com.flexcapacitor.model {
	import flash.events.EventDispatcher;

	/**
	 * Embeds the file for databinding and getting the string value
	 * 
	 * Use the following in the attribute:   
<pre>
&lt;fx:Declarations>
	&lt;model:EmbeddedFile id="embeddedFile" file="@Embed('./test.txt',mimeType='application/octet-stream')"/>
&lt;/fx:Declarations>
 
&lt;s:Label text="{embeddedFile.value}"/>
</pre>
 	 * 
	 * */
	public class EmbeddedFile extends EventDispatcher {
		
		public function EmbeddedFile() {
			
		}
		
		/**
		 * Embed the file into this property. <br > <br >
		 *
		 * Use the following in the attribute:   
<pre>
&lt;fx:Declarations>
	&lt;model:EmbeddedFile id="embeddedFile" file="@Embed('./test.txt',mimeType='application/octet-stream')"/>
&lt;/fx:Declarations>
 * 
&lt;s:Label text="{embeddedFile.value}"/>
</pre>
		 * 
		 * */
		public var file:Class;
		
		private var _value:String;

		/**
		 * Gets the string value of the embedded value
		 * */
		[Bindable]
		public function get value():String {
			if (_value==null && file) {
				_value = new file();
			}
			
			return _value;
		}
		
		public function set value(val:String):void {
			
		}

		override public function toString():String {
			return value;
		}
	}
}