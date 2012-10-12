package com.flexcapacitor.utils
{
	import flash.external.ExternalInterface;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * Allows Flash to take part in password storage and retrieval systems.<br/><br/>
	 * 
	 * Add this to your HTML page:
	 * 
	 * 
	 * <pre>
       		&lt;form id="bridgeForm" action="#">
			&lt;input id="username">
			&lt;input id="password" type="password">
		&lt;/form>
		</pre>
	 **/
	public class StoreLogin
	{
		
		/**
		 * ID of the form element
		 **/
		public static var FORM_ID:String = "bridgeForm";
		
		/**
		 * ID of the username element
		 **/
		public static var USERNAME_ID:String = "username";
		
		/**
		 * ID of the password element
		 **/
		public static var PASSWORD_ID:String = "password";
		
		/**
		 * Message when script was not written to the page
		 * */
		public static const SCRIPT_ERROR:String = "The script was not written to the page. See notes.";
		
		/**
		 * Message when form was not found on the page
		 * */
		public static const FORM_ERROR:String = "The form is not on the page. Make sure there is a form on the page with the same ID as in FORM_ID. See notes.";
		
		public function StoreLogin()
		{
			
		}
		
		/**
		 * Gives a moment to set flash back to focus 
		 **/
		private var timeout:int;
		
		/**
		 * If true the script and the form are both on the page
		 **/
		[Bindable]
		public static var initialized:Boolean;
		
		/**
		 * If true the form is found on the page
		 **/
		[Bindable]
		public static var formExists:Boolean;
		
		/**
		 * If true script was written to the page
		 **/
		[Bindable]
		public static var scriptExists:Boolean;
		
		/**
		 * Returns true if able to read and write to the HTML page
		 **/
		public function get enabled():Boolean {
			return ExternalInterface.available;
		}
		
		/**
		 * Sets the form username and password inputs. You typically call this
		 * right before submitting the form
		 **/
		public function setFormValues(username:String, password:String):Boolean
		{
			var results:Boolean = ExternalInterface.call("setFormValues", username, password);
			return results;
		}
		
		/**
		 * Clears the form
		 **/
		public function clearFormValues():Boolean
		{
			var results:Boolean = ExternalInterface.call("clearFormValues");
			return results;
		}
		
		/**
		 * Gets the username and password or empty array if not set
		 **/
		public function getFormValues():Array
		{
			var results:Array = ExternalInterface.call("getFormValues");
			return results;
		}
		
		/**
		 * Gets the username or null if not set
		 **/
		public function getUsername():String
		{
			var value:String = ExternalInterface.call("getUsername");
			return value;
		}
		
		/**
		 * Gets the password value or null if not set
		 **/
		public function getPassword():String
		{
			var value:String = ExternalInterface.call("getPassword");
			return value;
		}
		
		/**
		 * Has username value
		 **/
		public function isUsernameSet():Boolean
		{
			var value:String = ExternalInterface.call("getUsername");
			return value!=null && value!="";
		}
		
		/**
		 * Has password value
		 **/
		public function isPasswordSet():Boolean
		{
			var value:String = ExternalInterface.call("getPassword");
			return value!=null && value!="";
		}
		
		/**
		 * Submits an non-directing form request causing the browser 
		 * to show the prompt to save the login info
		 **/
		public function submitForm():Boolean
		{
			var value:String = ExternalInterface.call("submitForm", FORM_ID);
			return value!=null;
		}
		
		/**
		 * Shows the form. For testing purposes
		 **/
		public function showForm():Boolean
		{
			var value:String = ExternalInterface.call("showForm", FORM_ID);
			return value!=null;
		}
		
		/**
		 * Submits an non-directing form request causing the browser to prompt to save the login info
		 **/
		public function invokeSavePasswordPrompt():String
		{
			var value:String = ExternalInterface.call("submitForm", FORM_ID);
			return value;
		}
		
		/**
		 * The same as if a user typed their name in the username field and pressed tab. 
		 * This is used when there are multiple users saved by the browser. 
		 * Triggers the browser to fill in the password field given the username.
		 **/
		public function checkForPassword(username:String = ""):String
		{
			var value:String = ExternalInterface.call("checkForPassword", username);
			return value;
		}
		
		/**
		 * Sets the focus to the Flash application. 
		 * Some functions take focus away. This sets it back. 
		 * 
		 * @see checkForPassword
		 **/
		public function setFocusOnFlash():Boolean
		{
			clearTimeout(timeout);
			var value:Boolean = ExternalInterface.call("setFocusOnFlash", ExternalInterface.objectID);
			return value;
		}
		
		/**
		 * Sets the focus to the Flash application. 
		 * Some functions take focus away. This sets it back. 
		 * 
		 * @see setFocusOnFlash
		 * @see checkForPassword
		 **/
		public function delayedSetFocusOnFlash(delay:int = 100):void
		{
			timeout = setTimeout(setFocusOnFlash, delay);
		}
		
		/**
		 * Inserts the form into the HTML page dynamically. This does not autofill if the page 
		 * has been created. But it will cause the the page to prompt to save password. 
		 * 
		 * It remains for testing
		 **/
		public function insertForm():Boolean
		{
			var value:Boolean = ExternalInterface.call("insertForm");
			return value;
		}
		
		/**
		 * Writes our JavaScript functions to the page
		 * 
		 * Script error 
		 * - If the script is not on the page it could be that ExternalInterface is not available.
		 * - JavaScript is disabled?
		 * - Page is hosted on another domain so read / write is not allowed
		 * - The savePasswordJavaScript code contains errors 
		 * 
		 * Form Error
		 * - The form is not on the HTML page
		 * - Check that a form with name that matches the value in FORM_ID is on the page
		 **/
		public function initialize():Boolean
		{
			if (!initialized) {
				var script:String = savePasswordScript;
				ExternalInterface.call("eval", script);
				formExists = confirmFormExists();
				scriptExists = confirmScriptWritten();
				initialized = scriptExists && formExists;
				
				if (!scriptExists) {
					throw new Error(SCRIPT_ERROR);
				}
				else if (!formExists) {
					// make sure there is a form on the page with the same ID as in FORM_ID
					throw new Error(FORM_ERROR);
				}
			}
			
			return initialized;
		}
		
		/**
		 * If true confirms the script was written to the page
		 **/
		public function confirmScriptWritten():Boolean
		{
			var value:Boolean = ExternalInterface.call("scriptConfirmation");
			return value;
		}
		
		/**
		 * If true confirms then the form exists on the page
		 **/
		public function confirmFormExists():Boolean
		{
			var value:Boolean = ExternalInterface.call("formExists", FORM_ID);
			return value;
		}
		
		/**
		 * Resizes the application to the height specified. 
		 * For testing purposes. May be removed.
		 * 
		 * Typical values are 500px or 70%. 
		 **/
		public function resizeApplication(value:String = "75%"):Boolean
		{
			var result:Boolean = ExternalInterface.call("resizeApplication", ExternalInterface.objectID, value);
			return result;
		}
		
		/**
		 * This is written to the HTML page on load
		 * Note: wherever we have linebreaks we have to escape them - \n -> \\n
		 * 
		 * Getting error in Firefox Firebug console:
		 * 
		 * SyntaxError: syntax error 	
		 *    var DocumentManager = {
		 *  --^
		 * 
		 * Must convert to string first. 
		 * var string:String = LoginPrompt.loginPromptHTML;
		 * 
		 * ExternalInterface.call("eval", string);
		 * 
		 * DocumentManager source
		 * http://www.dustindiaz.com/add-remove-elements-reprise/
		 * */
		public static var savePasswordScript:XML = <root><![CDATA[
				var DocumentManager = {
					get: function(el) {
						if (typeof el === 'string') {
							return document.getElementById(el);
						} else {
							return el;
						}
					},
					add: function(el, dest) {
						var el = this.get(el);
						var dest = this.get(dest);
						if (!dest) dest = document.body;
						dest.appendChild(el);
					},
					remove: function(el) {
						var el = this.get(el);
						el.parentNode.removeChild(el);
					}
				};
			
				var EventManager = {
					add: function() {
						if (window.addEventListener) {
							return function(el, type, fn) {
								DocumentManager.get(el).addEventListener(type, fn, false);
							};
						} else if (window.attachEvent) {
							return function(el, type, fn) {
								var f = function() {
									fn.call(DocumentManager.get(el), window.event);
								};
								DocumentManager.get(el).attachEvent('on' + type, f);
							};
						}
					}()
				};
			
				function resizeApplication(id, value) {
					var el = DocumentManager.get(id);
					el.style.height = value;
					return true;
				}
				
				function insertForm(id) {
					var form 		= document.createElement('form');
					var textinput 	= document.createElement('input');
					var password 	= document.createElement('input');
			
					form.id 		= id;
					textinput.id 	= "username";
					password.id 	= "password";
					password.type 	= "password";
			
					form.appendChild(textinput);
					form.appendChild(password);
					DocumentManager.add(form);
			
					return true;
				}
				
				function setFormValues(username, password) {
					var usernameInput = DocumentManager.get('username');
					var passwordInput = DocumentManager.get('password');
					usernameInput.value = username;
					passwordInput.value = password;
					return true;
				}
				
				function getFormValues() {
					var usernameInput = DocumentManager.get('username');
					var passwordInput = DocumentManager.get('password');
					return [usernameInput.value, passwordInput.value];
				}
				
				function clearFormValues() {
					var usernameInput = DocumentManager.get('username');
					var passwordInput = DocumentManager.get('password');
					usernameInput.value = "";
					passwordInput.value = "";
					return true;
				}
			
				function getUsername() {
					var usernameInput = DocumentManager.get('username');
					return usernameInput.value;
				}
				
				function getPassword() {
					var passwordInput = DocumentManager.get('password');
					return passwordInput.value;
				}
				
				function submitForm(id) {
					var form = DocumentManager.get(id);
					form.submit();
					form.submit();// chrome
					return true;
				}
			
				function noDirectLogin(){
					return false;
				}

				function checkForPassword(username) {
					var usernameInput = DocumentManager.get('username');
					var passwordInput = DocumentManager.get('password');
					usernameInput.value = username;
					if (username!="") {
						usernameInput.focus();
						usernameInput.blur();
					}
					else {
						passwordInput.value = "";
					}
					//passwordInput.focus();
					return passwordInput.value;
				}
				
				function setFocusOnFlash(id) {
					var application = DocumentManager.get(id);
					application.tabIndex = 0;
					application.focus();
					return true;
				}
			
				function formExists(id) {
					var form = DocumentManager.get(id);
					return form!=null;
				}
				
				function showForm(id) {
					var form = DocumentManager.get(id);
					form.style.display = "block";
					return true;
				}
			
				function scriptConfirmation() {
					return true;
				}
				]]></root>;
		
	}
}