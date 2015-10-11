package com.flexcapacitor.utils
{
	import com.flexcapacitor.controls.AceEditor;
	
	import mx.core.IVisualElementContainer;

	public class AceEditorUtils {
		
		public var editor:AceEditor;
		
		public function AceEditorUtils()
		{
			
		}
		
		/**
		 * Creates an instance of the Ace Editor and returns it 
		 * Used for cases where browser and desktop application 
		 * uses the same view. By placing the definition in another
		 * class we prevent errors when our app is running in the browser
		 */
		public static function createInstance():AceEditor {
			var editor:AceEditor = new AceEditor();
			
			return editor;
		}
		
		public static var editorMargin:String = "28px 0 8px 0px";
		
		/**
		 * Creates a common instance of the editor. 
		 * I was using this method so many times it seems to help to have it here. 
		 * @param mode is the type of editor, "ace/mode/xml", "ace/mode/html/"...css
		 * */
		public static function createCommonEditor(mode:String = null, parent:IVisualElementContainer = null, parentIndex:int = 0):AceEditor {
			// 1067: Implicit coercion of a value of type com.flexcapacitor.controls:AceEditor to an unrelated type Object
			
			var editor:AceEditor = createInstance();
			editor.percentWidth = 100;
			editor.percentHeight = 100;
			editor.top = 0;
			editor.left = 0;
			editor.showFoldWidgets = false;
			editor.scrollSpeed = .5;
			
			editor.margin = editorMargin;
			editor.mode = mode;
			
			//editor.addEventListener(FocusEvent.FOCUS_IN, editorFocusInHandler, false, 0, true);
			
			//private function editorFocusInHandler(event:FocusEvent):void { lastFocusedEditor = event.currentTarget; }
			
			if (parent) {
				parent.addElementAt(editor, parentIndex);
			}
			
			return editor;
		}
	}
}