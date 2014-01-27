
package com.flexcapacitor.services {
	import flash.events.Event;
	
	
	/**
	 * Event dispatched when result or fault is received from a WP Service
	 * */
	public class WPServiceEvent extends Event implements IServiceEvent {
		
		/**
		 * Constructor.
		 * */
		public function WPServiceEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Dispatched when results are returned from the server
		 * */
		public static const RESULT:String 				= "result";
		
		/**
		 * Dispatched when there is a fault in the service call
		 * */
		public static const FAULT:String 				= "fault";
		
		/**
		 * Use WPAttachmentService
		 * */
		public static const UPLOAD_ATTACHMENT:String 		= "uploadAttachment";
		
		/**
		 * Name of call. Used in the event that is dispatched to know what call caused the event 
		 * */
		public static const GET_CREATE_POST_TOKEN:String 	= "getCreatePostToken";
		public static const GET_DELETE_POST_TOKEN:String 	= "getDeletePostToken";
		public static const GET_UPDATE_POST_TOKEN:String 	= "getUpdatePostToken";
		public static const GET_UPLOAD_POST_TOKEN:String 	= "getUploadPostToken";
		public static const CREATE_POST:String 				= "createPost";
		public static const UPDATE_POST:String 				= "updatePost";
		public static const DELETE_POST:String 				= "deletePost";
		public static const SEARCH_POSTS:String 			= "searchPosts";
		public static const GET_POST:String		 			= "getPost";
		public static const GET_POSTS:String 				= "getPosts";
		public static const GET_ATTACHMENTS:String 			= "getAttachments";
		public static const GET_LOGGED_IN_USER:String 		= "getLoggedInUser";
		public static const IS_USER_LOGGED_IN:String 		= "isUserLoggedIn";
		public static const REGISTER_USER:String 			= "register";
		public static const LOGIN_USER:String 				= "login";
		public static const LOGOUT_USER:String 				= "logout";
		public static const LOST_PASSWORD:String 			= "lostPassword";
		public static const RESET_PASSWORD:String 			= "resetPassword";
		public static const GET_PROJECTS:String 			= "getProjects";
		public static const GET_PROJECTS_BY_USER:String 	= "getProjectsByUser";
		public static const GET_PROJECT_BY_ID:String 		= "getProjectsByID";
		public static const GET_POSTS_BY_CATEGORY:String 	= "getPostsByCategory";
		
		private var _call:String;

		/**
		 * Call that was made
		 * */
		public function get call():String {
			return _call;
		}

		/**
		 * @private
		 */
		public function set call(value:String):void {
			_call = value;
		}

		private var _text:String;

		/**
		 * Raw text result from server
		 * */
		public function get text():String {
			return _text;
		}

		public function set text(value:String):void {
			_text = value;
		}

		private var _data:Object;

		/**
		 * JSON object
		 * */
		public function get data():Object {
			return _data;
		}

		public function set data(value:Object):void {
			_data = value;
		}

		private var _message:String;

		/**
		 * Status message about call
		 * */
		public function get message():String {
			return _message;
		}

		public function set message(value:String):void {
			_message = value;
		}

		public var resultEvent:Event;
		private var _faultEvent:Event;

		public function get faultEvent():Event {
			return _faultEvent;
		}

		public function set faultEvent(value:Event):void {
			_faultEvent = value;
		}

		public var parseError:Error;
		public var faultCode:String;
		
		override public function clone():Event {
			return new WPServiceEvent(type, bubbles, cancelable);
		}
	}
}