
package com.flexcapacitor.services {
	import flash.events.Event;
	
	
	/**
	 * Event dispatched when result or fault is received from a WP Service
	 * */
	public class WPServiceEvent extends ServiceEvent implements IServiceEvent {
		
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
		public static const GET_CATEGORIES:String 			= "getCategories";
		public static const GET_LOGGED_IN_USER:String 		= "getLoggedInUser";
		public static const IS_USER_LOGGED_IN:String 		= "isUserLoggedIn";
		public static const REGISTER_USER:String 			= "registerUser";
		public static const REGISTER_USER_AND_SITE:String 	= "registerUserAndSite";
		public static const REGISTER_SITE:String 			= "registerSite";
		public static const IS_MAIN_SITE:String 			= "isMainSite";
		public static const IS_MULTISITE:String 			= "isMultisite";
		public static const IS_SUB_DOMAIN_INSTALL:String 	= "isSubDomainInstall";
		public static const GET_CURRENT_SITE:String 		= "getCurrentSite";
		public static const LOGIN_USER:String 				= "login";
		public static const LOGOUT_USER:String 				= "logout";
		public static const LOST_PASSWORD:String 			= "lostPassword";
		public static const RESET_PASSWORD:String 			= "resetPassword";
		public static const GET_PROJECTS:String 			= "getProjects";
		public static const GET_POSTS_BY_USER:String 		= "getPostsByUser";
		public static const GET_PROJECTS_BY_USER:String 	= "getProjectsByUser";
		public static const GET_PROJECT_BY_ID:String 		= "getProjectsByID";
		public static const GET_POSTS_BY_CATEGORY:String 	= "getPostsByCategory";
		public static const GET_API_INFO:String 			= "info";
		
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


		public var parseError:Error;
		
		public var faultCode:String;
		
		override public function clone():Event {
			return new WPServiceEvent(type, bubbles, cancelable);
		}
	}
}