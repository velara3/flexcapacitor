package com.flexcapacitor.utils
{
	import flash.html.HTMLLoader;
	
	import mx.controls.HTML;

	
	/**
	 * Creates an instance of the HTML component and returns it.
	 * Used for cases where a library project has a 
	 * browser and desktop application and the HTML control cannot 
	 * be referenced by the browser version.
	 * */
	public class HTMLUtils {
		
		public function HTMLUtils()
		{
			
		}
		
		/**
		 * Creates an instance of the HTML component and returns it 
		 **/
		public static function createInstance():HTML {
			return new HTML();
		}
		
		/**
		 * Creates an instance of the HTML loader and returns it 
		 **/
		public static function createLoaderInstance():HTMLLoader {
			return new HTMLLoader();
		}
	}
}