package com.flexcapacitor.utils
{
	import com.flexcapacitor.controls.AceEditor;

	public class AceEditorUtils {
		
		public var editor:AceEditor;
		
		public function AceEditorUtils()
		{
			
		}
		
		/**
		 * Creates an instance of the Ace Editor and returns it 
		 * Used for cases where browser and desktop application 
		 * uses the same view. By placing the definition in another
		 * class we prevent errors in the browser
		 */
		public static function createInstance():AceEditor {
			var editor:AceEditor = new AceEditor();
			
			
			return editor;
		}
	}
}