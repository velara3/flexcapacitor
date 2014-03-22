
package com.flexcapacitor.services {
	
	
	import flash.events.IEventDispatcher;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	/**
	 * An adapter class and service to get and save data to WordPress. <br/><br/>
	 * 
	 * This class works with the JSON API for WordPress. <br/><br/>
	 * 
	 * Notes:<br/><br/>
	 * 
	 * Be sure WordPress auto formatting is off - this automatically adds Paragraph tags around your content. This is called wpautop. <br/>
	 * Also be sure fancy quotes is off - it automatically adds curly quotes when it encounters them in your content.<br/>
	 * There are plugins out there that will remove WP autoformatting<br/>
	 * There are plugins that will interfere with the JSON results as well<br/><br/>
	 * 
	 * Error #1132: Invalid JSON parse input.<br/>
	 * - check the text property of the event to see the original source. <br/><br/>
	 * 
	 * If you can't update or create posts be sure that the user is 
	 * logged in with Editor or Author permissions
	 * and check if the Posts option is enabled in the JSON-API settings page. <br/><br/>
	 * 
	 * Updates to JSON-API<br/><br/>
	 * 
	 * Add these to the controllers folder: <br/>
	 * controllers/attachments.php<br/>
	 * controllers/user.php<br/>
	 * controllers/projects.php<br/><br/>
	 * 
	 * And in models/post.php after this code:<br/><br/>
	 * 
<pre>
if (isset($wp_values['ID'])) {
	$this->id = wp_update_post($wp_values);
} else {
	$this->id = wp_insert_post($wp_values);
}
</pre>
add:
 
<pre>
// add custom fields  
if ( !empty($values["custom"]) ) {
	foreach ($values["custom"] as $metakey => $metavalue) {
		update_post_meta($this->id,$metakey, $metavalue);
	}
}
</pre>
	 * https://github.com/monkeypunch3/JSON-API-Plus<br/>
	 * http://wordpress.org/support/topic/update-custom-fields-of-post?replies=2#post-4991303<br/>
	 * 
	 * @see WPServiceBase
	 * @see WPAttachmentService
	 * */
	public class WPService extends WPServiceBase {
		
		/**
		 * Constructor
		 * */
		public function WPService(target:IEventDispatcher=null) {
			super(target);
		}
		
		/**
		 * Constants
		 * */
		public static const RESULT:String = "result";
		public static const FAULT:String = "fault";
		public static const STATUS_ALL:String = "all";
		public static const STATUS_ANY:String = "any";
		public static const STATUS_PUBLISH:String = "publish";
		public static const STATUS_DRAFT:String = "draft";
		public static const STATUS_TRASH:String = "trash";

		public var getAPIInfoURL:String = "core/info";
		
		/**
		 * Attachments URL
		 * Options parent
		 * */
		public var getAttachmentsURL:String = "attachments/get_attachments";
		
		/**
		 * Delete attachment URL
		 * */
		public var deleteAttachmentURL:String = "attachments/delete_attachment";
		
		public var getPostURL:String = "core/get_post";
		
		public var getPostsURL:String = "core/get_posts";
		
		public var getSearchURL:String = "core/get_search_results";
		
		public var logoutUserURL:String = "user/logout";
		
		public var loginUserURL:String = "user/login";
		
		public var registerUserURL:String = "user/register";
		
		public var registerSiteURL:String = "user/register_site";
		
		public var registerUserAndSiteURL:String = "user/register_user_and_site";
		
		public var lostPasswordURL:String = "user/lost_password";
		
		public var resetPasswordURL:String = "user/reset_password";
		
		public var isUserLoggedInURL:String = "user/is_user_logged_in";
		
		public var getLoggedInUserURL:String = "user/get_logged_in_user";
		
		public var isSubDomainInstallURL:String = "user/is_subdomain_install";
		
		public var isMultisiteURL:String = "user/is_multisite";
		
		public var isMainsiteURL:String = "user/is_mainsite";
		
		public var getCurrentSiteURL:String = "user/get_current_site";
		
		public var getProjectsURL:String = "projects/get_projects";
		
		public var getProjectsByUserURL:String = "projects/get_projects_by_user";
		
		public var getProjectByIdURL:String = "projects/get_project_by_id";
		
		public var getCategoriesURL:String = "categories/get_categories";
		
		public var getCategoryURL:String = "categories/get_category";
		
		public var getCategoryBySlugURL:String = "categories/get_category_by_slug";
		
		public var getCategoryByIdURL:String = "categories/get_category_by_id";

		public var createCategoryURL:String = "categories/create_category";
		
		public var getPostsByCategoryURL:String = "posts/get_posts_by_category";

		public var createTokenURL:String = "core/get_nonce?controller=posts&method=create_post";
		
		public var updateTokenURL:String = "core/get_nonce?controller=posts&method=update_post";

		public var uploadTokenURL:String = "core/get_nonce?controller=posts&method=update_post";

		public var deleteTokenURL:String = "core/get_nonce?controller=posts&method=delete_post";
		
		public var createPostURL:String = "posts/create_post";
		
		public var updatePostURL:String = "posts/update_post";
		
		public var deletePostURL:String = "posts/delete_post";
		
		/**
		 * Save the document. If the document doesn't
		 * have an ID a new document is created on the server
		 * for the user that is logged in. 
		 * */
		override public function save(object:URLVariables = null):void {
			if (object) parameters = object;
			
			if (host==null) {
				throw new Error("You must specify a host.");
			}
			
			// if no id is set then call createPost
			if (id==null && (parameters && parameters.id==null && parameters.post_id==null)) {
				createPost();
			}
			else {
				updatePost();
			}
		}
	
		//----------------------------------
		//
		//  Service Calls
		// 
		//----------------------------------
		
		
		/**
		 * Calls create post
		 * */
		override public function createPost(currentToken:String = null):void {
			
			// get creation token if it doesn't exist yet
			if (currentToken==null) {
				createPending = true;
				getCreateToken();
				return;
			}
			
			createPending = false;
			
			url = createPostURL;
			call = WPServiceEvent.CREATE_POST;
			parameters.nonce = currentToken;
			request.method = URLRequestMethod.POST;
			request.data = parameters;
			request.url = url;
			load(request);
		}
		
		/**
		 * Get create token
		 * */
		public function getCreateToken():void {
			//trace("Get creation token");
			url = createTokenURL;
			call = WPServiceEvent.GET_CREATE_POST_TOKEN;
			request.method = URLRequestMethod.GET;
			request.data = null;
			load(request);
		}
	
		/**
		 * Get update token
		 * */
		public function getUpdateToken():void {
			url = updateTokenURL;
			call = WPServiceEvent.GET_UPDATE_POST_TOKEN;
			request.method = URLRequestMethod.GET;
			request.data = null;
			load(request);
		}
	
		/**
		 * Get upload token (same url as update token)
		 * */
		public function getUploadToken():void {
			url = uploadTokenURL;
			call = WPServiceEvent.GET_UPLOAD_POST_TOKEN;
			request.method = URLRequestMethod.GET;
			request.data = null;
			load(request);
		}
		
		/**
		 * Get delete token
		 * */
		public function getDeleteToken():void {
			url = deleteTokenURL;
			call = WPServiceEvent.GET_DELETE_POST_TOKEN;
			request.method = URLRequestMethod.GET;
			request.data = null;
			load(request);
		}
		
		/**
		 * Calls update post
		 * */
		override public function updatePost(currentToken:String = null):void {
			
			// get update token if it doesn't exist yet
			if (currentToken==null) {
				updatePending = true;
				getUpdateToken();
				return;
			}
			
			updatePending = false;
			
			url = updatePostURL;
			call = WPServiceEvent.UPDATE_POST;
			parameters.nonce = currentToken;
			request.method = URLRequestMethod.POST;
			request.data = parameters;
			request.url = url;
			load(request);
		}
		
		/**
		 * Calls delete post
		 * */
		override public function deletePost(currentToken:String = null):void {
			
			// get update token if it doesn't exist yet
			if (currentToken==null) {
				deletePending = true;
				getDeleteToken();
				return;
			}
			
			deletePending = false;
			
			url = deletePostURL;
			call = WPServiceEvent.DELETE_POST;
			if (parameters==null) {
				parameters = new URLVariables();
			}
			parameters.nonce = currentToken;
			parameters.id = id;
			request.data = parameters;
			request.url = url;
			request.method = URLRequestMethod.POST;
			load(request);
		}
		
		/**
		 * Get attachments. If id is not set then returns all attachments. 
		 * */
		public function getAttachments(id:int = 0):void {
			url = getAttachmentsURL + "&parent=" + id;
			call = WPServiceEvent.GET_ATTACHMENTS;
			request.method = URLRequestMethod.GET;
			request.data = null;
			load(request);
		}
		
		/**
		 * Delete attachment. 
		 * */
		public function deleteAttachment(id:int = 0, forceDelete:Boolean = true):void {
			url = deleteAttachmentURL + "&id=" + id + "&force_delete=" + forceDelete;
			call = WPServiceEvent.DELETE_ATTACHMENT;
			request.method = URLRequestMethod.GET;
			request.data = null;
			load(request);
		}
		
		/**
		 * Get posts
		 * */
		public function getPosts(query:String = "", form:URLVariables = null, count:int = 10):void {
			url = getPostsURL + "&count=" + count + query;
			call = WPServiceEvent.GET_POSTS;
			request.method = URLRequestMethod.POST;
			request.data = form;
			request.url = url;
			load(request);
		}
		
		/**
		 * Get post by ID
		 * */
		public function getPostById(id:String, count:int = 10):void {
			url = getPostURL + "&id=" + id;
			call = WPServiceEvent.GET_POST;
			request.method = URLRequestMethod.GET;
			request.data = null;
			load(request);
		}
		
		/**
		 * Get post by ID
		 * */
		public function open(id:String):void {
			getPostById(id);
		}
		
		/**
		 * Get posts by search query
		 * */
		public function getPostsBySearch(search:String, count:int = 10):void {
			url = getSearchURL + "&count=" + count + "&search=" + search;
			call = WPServiceEvent.SEARCH_POSTS;
			request.method = URLRequestMethod.GET;
			request.data = null;
			load(request);
		}
		
		/**
		 * Get posts by categories
		 * */
		public function getPostsByCategory(category:String, count:int = 10):void {
			url = getPostsByCategoryURL + "&count=" + count + "&slug=" + category;
			call = WPServiceEvent.GET_POSTS_BY_CATEGORY;
			request.method = URLRequestMethod.GET;
			request.data = null;
			load(request);
		}
		
		/**
		 * Get categories
		 * */
		public function getCategories(category:String = "", count:int = 10):void {
			url = getCategoriesURL + "&count=" + count + "&slug=" + category;
			call = WPServiceEvent.GET_CATEGORIES;
			request.method = URLRequestMethod.GET;
			request.data = null;
			load(request);
		}
		
		/**
		 * Get category by name
		 * */
		public function getCategory(name:String, parent:int = 0):void {
			url = getCategoryURL + "&name=" + name + "&parent=" + parent;
			call = WPServiceEvent.GET_CATEGORY;
			request.method = URLRequestMethod.GET;
			request.data = null;
			load(request);
		}
		
		/**
		 * Get category by slug
		 * */
		public function getCategoryBySlug(slug:String = ""):void {
			url = getCategoryBySlugURL + "&slug=" + slug;
			call = WPServiceEvent.GET_CATEGORY_BY_SLUG;
			request.method = URLRequestMethod.GET;
			request.data = null;
			load(request);
		}
		
		/**
		 * Get category by id
		 * */
		public function getCategoryById(id:String = ""):void {
			url = getCategoryByIdURL + "&id=" + id;
			call = WPServiceEvent.GET_CATEGORY_BY_ID;
			request.method = URLRequestMethod.GET;
			request.data = null;
			load(request);
		}
		
		/**
		 * Create category
		 * */
		public function createCategory(name:String, parent:int = 0):void {
			url = createCategoryURL + "&name=" + name + "&parent=" + parent;
			call = WPServiceEvent.CREATE_CATEGORY;
			request.method = URLRequestMethod.GET;
			request.data = null;
			load(request);
		}
		
		/**
		 * Gets a list of projects. Publish status can be "draft", "publish", "trash", "any" and "all". 
		 * */
		public function getProjects(publishStatus:String=STATUS_ANY, count:int = 10):void {
			var category:String = "project";
			url = getProjectsURL + "&count=" + count + "&category=" + category + "&status=" + publishStatus;
			call = WPServiceEvent.GET_PROJECTS;
			request.method = URLRequestMethod.GET;
			request.data = null;
			load(request);
		}
		
		/**
		 * Get projects by user. Publish status can be all, any, draft or publish, trash
		 * */
		public function getProjectsByUser(userID:int, publishStatus:String=STATUS_ANY, count:int = 10):void {
			var category:String = "project";
			url = getProjectsByUserURL + "&user_id=" + userID + "&count=" + count + "&category=" + category + "&status=" + publishStatus;
			call = WPServiceEvent.GET_PROJECTS_BY_USER;
			request.method = URLRequestMethod.GET;
			request.data = null;
			load(request);
		}
		
		/**
		 * Get projects by user. Publish status can be all, any, draft or publish, trash
		 * */
		public function getPostsByUser(userID:int, publishStatus:String=STATUS_ANY, count:int = 10):void {
			url = getProjectsByUserURL + "&user_id=" + userID + "&count=" + count + "&status=" + publishStatus;
			call = WPServiceEvent.GET_POSTS_BY_USER;
			request.method = URLRequestMethod.GET;
			request.data = null;
			load(request);
		}
		
		/**
		 * Get project by id. TODO include parameter to include sub posts.
		 * */
		public function getProjectByID(id:int, publishStatus:String=STATUS_ANY, includeSubPosts:Boolean = false, count:int = 10):void {
			var category:String = "project";
			url = getProjectByIdURL + "&id=" + id + "&count=" + count + "&category=" + category + "&status=" + publishStatus + "&subPosts=" + includeSubPosts;
			call = WPServiceEvent.GET_PROJECT_BY_ID;
			request.method = URLRequestMethod.GET;
			request.data = null;
			load(request);
		}
		
		/**
		 * Get is user logged in
		 * */
		public function isUserLoggedIn():void {
			url = isUserLoggedInURL;
			call = WPServiceEvent.IS_USER_LOGGED_IN;
			request.method = URLRequestMethod.GET;
			request.data = null;
			load(request);
		}
		
		/**
		 * Get logged in user
		 * */
		public function getLoggedInUser():void {
			url = getLoggedInUserURL;
			call = WPServiceEvent.GET_LOGGED_IN_USER;
			request.data = null;
			request.method = URLRequestMethod.GET;
			load(request);
		}
		
		/**
		 * Register user
		 * */
		public function registerUser(username:String, email:String):void {
			url = registerUserURL;
			call = WPServiceEvent.REGISTER_USER;
			var variables:URLVariables = new URLVariables();
			variables.user_name = username;
			variables.user_email = email;
			request.method = URLRequestMethod.POST;
			request.data = variables;
			load(request);
		}
		
		/**
		 * Register site
		 * */
		public function registerSite(blogName:String = "", blogTitle:String = "", blogPublic:Boolean = true):void {
			url = registerSiteURL;
			call = WPServiceEvent.REGISTER_SITE;
			var variables:URLVariables = new URLVariables();
			variables.blogname = blogName;
			variables.blog_title = blogTitle;
			variables.blog_public = blogPublic ? 1 : 0;
			request.method = URLRequestMethod.POST;
			request.data = variables;
			load(request);
		}
		
		/**
		 * Register user and site
		 * */
		public function registerUserAndSite(username:String, email:String, blogName:String = "", blogTitle:String = "", blogPublic:Boolean = true):void {
			url = registerUserAndSiteURL;
			call = WPServiceEvent.REGISTER_USER_AND_SITE;
			var variables:URLVariables = new URLVariables();
			variables.user_name = username;
			variables.user_email = email;
			variables.blogname = blogName;
			variables.blog_title = blogTitle;
			variables.blog_public = blogPublic ? 1 : 0;
			request.method = URLRequestMethod.POST;
			request.data = variables;
			load(request);
		}
		
		/**
		 * Is multisite
		 * */
		public function isMultiSite():void {
			url = isMultisiteURL;
			call = WPServiceEvent.IS_MULTISITE;
			request.method = URLRequestMethod.GET;
			load(request);
		}
		
		/**
		 * Is mainsite
		 * */
		public function isMainSite():void {
			url = isMainsiteURL;
			call = WPServiceEvent.IS_MAIN_SITE;
			request.method = URLRequestMethod.GET;
			load(request);
		}
		
		/**
		 * Is sub domain insatll
		 * */
		public function isSubDomainInstall():void {
			url = isSubDomainInstallURL;
			call = WPServiceEvent.IS_SUB_DOMAIN_INSTALL;
			request.method = URLRequestMethod.GET;
			load(request);
		}
		
		/**
		 * Get current site
		 * */
		public function getCurrentSite():void {
			url = getCurrentSiteURL;
			call = WPServiceEvent.GET_CURRENT_SITE;
			request.method = URLRequestMethod.GET;
			load(request);
		}
		
		/**
		 * Login user
		 * */
		public function loginUser(username:String, password:String, remember:Boolean = false):void {
			url = loginUserURL;
			call = WPServiceEvent.LOGIN_USER;
			var variables:URLVariables = new URLVariables();
			variables.log = username;
			variables.pwd = password;
			variables.rememberme = remember;
			request.method = URLRequestMethod.POST;
			request.data = variables;
			load(request);
		}
		
		/**
		 * Lost password
		 * */
		public function lostPassword(username:String):void {
			url = lostPasswordURL;
			call = WPServiceEvent.LOST_PASSWORD;
			var variables:URLVariables = new URLVariables();
			variables.username = username;
			request.method = URLRequestMethod.POST;
			request.data = variables;
			load(request);
		}
		
		/**
		 * Reset password
		 * */
		public function resetPassword(key:String, username:String, password:String, password2:String):void {
			url = resetPasswordURL + "&action=resetpass&key=" + key + "&login=" + username;
			call = WPServiceEvent.RESET_PASSWORD;
			var variables:URLVariables = new URLVariables();
			variables.pass1 = password;
			variables.pass2 = password2;
			request.method = URLRequestMethod.POST;
			request.data = variables;
			load(request);
		}
		
		/**
		 * Logout user
		 * */
		public function logoutUser():void {
			url = logoutUserURL;
			call = WPServiceEvent.LOGOUT_USER;
			request.method = URLRequestMethod.GET;
			request.data = null;
			load(request);
		}
		
		/**
		 * Get API info
		 * */
		public function getAPIInfo():void {
			url = getAPIInfoURL;
			call = WPServiceEvent.GET_API_INFO;
			request.data = null;
			request.method = URLRequestMethod.GET;
			load(request);
		}
		
	}
}
