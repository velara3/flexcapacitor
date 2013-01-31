/**
 * License is free for commercial use. 
 * Charities must pay 1 billion dollars. 
 * License is WTFYW 2.0
 * */
package com.flexcapacitor.controls  {
	
	/**
	 * A static class that holds the calls that can be made to the <code>StageWebView</code>. 
	 * 
	 * Some code from https://github.com/flex-users/flex-iframe used. 
	 * */
	public class WebViewExternalCalls {
		
		//include "../core/Version.as";
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		* The name of the JavaScript function that inserts script.
		**/
        public static var FUNCTION_INSERT_SCRIPT:String = "insertScript";
		
		/**
		* When calling JavaScript and an error occurs we use this constant in the return object.
		**/
        public static var FUNCTION_ERROR:String = "error";
		
		/**
		* Error message when element is not found. It is generic in use but typically used 
		 * when calling getElementById().
		**/
        public static var ELEMENT_NOT_FOUND:String = "The following element was not found";

		/**
		* The name of the JavaScript function that inserts the test script.
		**/
        public static var FUNCTION_INSERT_TEST_SCRIPT:String = "webView_testInsertScript";
		
		/**
		 * The JavaScript code to call to test inserting functions.
		 * Returns the string "success" in the location change event.
		 * 
		 * Note: Calls too quickly overwrite the previous calls. 
		 * */
        public static var INSERT_FUNCTION_TEST:String =
            "document.insertScript = function ()" +
            "{ " +
                "if (document." + FUNCTION_INSERT_TEST_SCRIPT + "==null)" +
                "{" +
                    FUNCTION_INSERT_TEST_SCRIPT + " = function ()" +
                    "{ " +
						"alert('Insert script test passed! Now attempting to return results.');" +
						"var result = JSON.stringify({event:'test',method:'"+FUNCTION_INSERT_TEST_SCRIPT+"',results:'success'});" +
						"document.location = result;" +
                    "}" +
                "}" +
            "}";

		
		/**
		* The name of the JavaScript function that gets the document width and height.
		**/
        public static var FUNCTION_MEASURE_DOCUMENT:String = "webView_measureDocumentSize";
		
		/**
		 * The JavaScript code that gets the document content width and height.
		 * Must be called after page load or in this case the complete event. 
		 * */
        public static var INSERT_FUNCTION_MEASURE_DOCUMENT:String =
            "document.insertScript = function ()" +
            "{ " +
                "if (document." + FUNCTION_MEASURE_DOCUMENT + "==null)" +
                "{" +
                    FUNCTION_MEASURE_DOCUMENT + " = function (elementID)" +
                    "{ " +
						"var docBody = elementID==null ? document.body:document.getElementById(elementID);" +
						"var docElement = elementID==null ? document.documentElement:document.getElementById(elementID);" +
						"if (docBody==null && docElement==null) {" +
							"var result = JSON.stringify({method:'" + FUNCTION_MEASURE_DOCUMENT + "',error:'" + FUNCTION_ERROR + "', message:'" + ELEMENT_NOT_FOUND + ":'+elementID});" +
							"document.location = result;" +
							"return;" + 
						"}" + 
						"var theHeight = Math.max(" +
							"Math.max(docBody.scrollHeight, docElement.scrollHeight)," +
							"Math.max(docBody.offsetHeight, docElement.offsetHeight)," +
							"Math.max(docBody.clientHeight, docElement.clientHeight));" +
						"var theWidth = Math.max(" +
							"Math.max(docBody.scrollWidth, docElement.scrollWidth)," +
							"Math.max(docBody.offsetWidth, docElement.offsetWidth)," +
							"Math.max(docBody.clientWidth, docElement.clientWidth));" +
						"var result = JSON.stringify({method:'" + FUNCTION_MEASURE_DOCUMENT + "',width:theWidth, height:theHeight, elementID:elementID});" +
						"document.location = result;" +
                    "}" +
                "}" +
            "}";


        /**
		* The name of the Javascript function that setups the 'resize' event listener.
		*/
        public static var FUNCTION_SETUP_RESIZE_EVENT_LISTENER:String = "setupResizeEventListener";
        
        /**
		* The Javascript code to call to insert the function that setups the 'resize' event
		* listener.
		*
		* When a 'resize' event is received, it is queued and the Flex application is not notified
		* unless there is no new 'resize' event in the next 10 milliseconds. This is to prevent
		* unexpected behaviours with *beloved* Internet Explorer sending bursts of events.
		*/
        public static function INSERT_FUNCTION_SETUP_RESIZE_EVENT_LISTENER(frameId:String):String
        {
            return "document.insertScript = function ()" +
                   "{ " +
                       "if (document." + FUNCTION_SETUP_RESIZE_EVENT_LISTENER + "==null)" +
                       "{ " +
                           FUNCTION_SETUP_RESIZE_EVENT_LISTENER + " = function() " +
                           "{ " +
                               "if (window.addEventListener) { " +
                                   "window.addEventListener(\"resize\", on" + frameId + "Resize, false); " +
                               "} else if (window.attachEvent) { " +
                                   "window.attachEvent(\"onresize\", on" + frameId + "Resize); " +
                               "} " +
                           "} " +
                       "} " +
                       "if (document.on" + frameId + "Resize==null)" +
                       "{ " +
                            "var resizeTimeout" + frameId + "; " +
                            "function on" + frameId + "Resize(e) " +
                            "{ " +
								"window.clearTimeout(resizeTimeout" + frameId + ");" +
								"resizeTimeout" + frameId + " = window.setTimeout('notify" + frameId + "Resize();', 10); " +
							"} " +
                       "} " +
                       "if (document.notify" + frameId + "Resize==null)" +
                       "{ " +
                           "notify" + frameId + "Resize = function() " +
                           "{ " +
						   		"alert('document resize handler!');" + 
								"var docBody = document.body;" +
								"var docElement = document.documentElement;" +
								"var theHeight = Math.max(" +
									"Math.max(docBody.scrollHeight, docElement.scrollHeight)," +
									"Math.max(docBody.offsetHeight, docElement.offsetHeight)," +
									"Math.max(docBody.clientHeight, docElement.clientHeight));" +
								"var theWidth = Math.max(" +
									"Math.max(docBody.scrollWidth, docElement.scrollWidth)," +
									"Math.max(docBody.offsetWidth, docElement.offsetWidth)," +
									"Math.max(docBody.clientWidth, docElement.clientWidth));" +
								"var result = JSON.stringify({method:'" + FUNCTION_MEASURE_DOCUMENT + "',width:theWidth, height:theHeight, pageResize:'resizeHandler'});" +
								"document.location = result;" +
                           "} " +
                       "} " +
                   "} ";
        }


        /**
		* The name of the Javascript function that prints the document.
		*/
        public static var FUNCTION_PRINT_ELEMENT:String = "printElement";

        /**
		* The Javascript code to call to insert the function that prints the document.
		*/
        public static var INSERT_FUNCTION_PRINT_ELEMENT:String =
           "document." + FUNCTION_INSERT_SCRIPT + " = function ()" +
           "{" +
               "if (document." + FUNCTION_PRINT_ELEMENT + "==null)" +
               "{" +
                   FUNCTION_PRINT_ELEMENT + " = function ()" +
                   "{" +
                       "try" +
                       "{" +
                           "if (navigator.appName.indexOf('Microsoft') != -1)" +
                           "{" +
                               "document.focus();" +
                               "document.print();" +
                           "}" +
                           "else" +
                           "{" +
                               "window.focus();" +
                               "window.print();" +
                           "}" +
                       "}" +
                       "catch(e)" +
                       "{" +
                           "alert(e.name + ': ' + e.message);" +
                       "}" +
                   "}" +
                "}" +
            "}";

		
		/**
		* The name of the JavaScript function that hides a Div.
		*/
		public static var FUNCTION_GET_SOURCE:String = "getSource";
		
		
		/**
		* The Javascript code to call to insert the function that returns the element's source.
		*/
		public static var INSERT_FUNCTION_GET_SOURCE:String =
			"document.insertScript = function () " +
			"{ " +
				"if (document." + FUNCTION_GET_SOURCE + "==null) " +
				"{ " +
					FUNCTION_GET_SOURCE + " = function(elementID) " +
					"{ " +
						"if (elementID==null) {" +
							"document.location = JSON.stringify({event:'getSource',method:'" + FUNCTION_GET_SOURCE + "',value:document.body.contentDocument.URL}); " +
						"} " +
						"else " +
						"{" +
							"document.location = JSON.stringify({event:'getSource',method:'" + FUNCTION_GET_SOURCE + "',value:document.getElementById(elementID).contentDocument.URL}); " +
						"} " +
					"} " +
				"} " +
			"}";
		
        /**
		* The name of the Javascript function that gets the browser measured width.
		*/
        public static var FUNCTION_GET_BROWSER_MEASURED_WIDTH:String = "getBrowserMeasuredWidth";
                
        /**
		* The Javascript code to call to insert the function that gets the browser measured width.
		*/
        public static var INSERT_FUNCTION_GET_BROWSER_MEASURED_WIDTH:String =
            "document.insertScript = function () " +
            "{ " +
                "if (document." + FUNCTION_GET_BROWSER_MEASURED_WIDTH + "==null) " +
                "{ " +
                    FUNCTION_GET_BROWSER_MEASURED_WIDTH + " = function(objectID) " +
                    "{ " +
                        "document.location = JSON.stringify({method:'"+FUNCTION_GET_BROWSER_MEASURED_WIDTH+"',width:document.getElementById(objectID).offsetWidth}); " +
                    "} " +
                "} " +
            "}";
	}
}