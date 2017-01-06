package com.flexcapacitor.utils
{
	import flash.html.HTMLLoader;
	
	import mx.controls.HTML;
	import mx.core.FlexHTMLLoader;

	
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
		public static function createHTMLInstance():HTML {
			return new HTML();
		}
		
		/**
		 * Creates an instance of the HTML loader and returns it 
		 **/
		public static function createHTMLLoaderInstance():HTMLLoader {
			return new HTMLLoader();
		}
		
		/**
		 * Creates an instance of the FlexHTMLLoader and returns it 
		 **/
		public static function createFlexHTMLLoaderInstance():FlexHTMLLoader {
			return new FlexHTMLLoader();
		}
	}
}