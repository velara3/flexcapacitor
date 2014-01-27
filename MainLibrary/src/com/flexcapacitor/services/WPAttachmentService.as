
package com.flexcapacitor.services {
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.getTimer;
	
	import ru.inspirit.net.MultipartURLLoader;
	import ru.inspirit.net.events.MultipartURLLoaderEvent;
	
	/**
	 * Adds upload attachments
	 * */
	public class WPAttachmentService extends WPService {
		
		/**
		 * Constructor
		 * */
		public function WPAttachmentService(target:IEventDispatcher=null) {
			super(target);
		}
		
		private var multipartURLLoader:MultipartURLLoader;

		/**
		 * Indicates if call is asynchronous
		 * */
		public var asyncronous:Boolean;
		
		/**
		 * Attachments URL
		 * Options parent
		 * */
		public var uploadAttachmentsURL:String = "?json=posts/update_post";
		
		/**
		 * Files
		 * */
		public var file:FileReference;
		
		
		/**
		 * Upload attachment
		 * */
		override public function uploadAttachment(currentToken:String = null):void {
			
			if (!file || !file.data) {
				throw new Error("Please select a file before calling uploadAttachment");
				return;
			}
			
			// get update token if it doesn't exist yet
			if (currentToken==null) {
				uploadPending = true;
				getUploadToken();
				return;
			}
			
			// no support for multiple files
			// we might add this by looping through and creating a file array
			// and calling addFile
			// we might also need to add support on the server side
			
			//multipartURLLoader.addFile(testTextFileByteArray, 'text.txt', 'Filedata', 'text/plain');
			//multipartURLLoader.addFile(testBitmapJPEGByteArray, 'img.png', 'Filedata2');
			//multipartURLLoader.addFile(data1, 'test1.txt', 'Filedata[]', 'text/plain');
			//multipartURLLoader.addFile(img, 'img.png', 'Filedata[]');
			
			uploadPending = false;
			
			url = updatePostURL;
			call = WPServiceEvent.UPLOAD_ATTACHMENT;

			if (!multipartURLLoader) {
				multipartURLLoader = new MultipartURLLoader();
			}
			
			//var dataFormat:String = URLLoaderDataFormat.VARIABLES;
			//multipartURLLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			//multipartURLLoader.dataFormat = 'variables';
			multipartURLLoader.dataFormat = URLLoaderDataFormat.TEXT;
			
			multipartURLLoader.addEventListener(Event.COMPLETE, onUploadResult);
			multipartURLLoader.addEventListener(MultipartURLLoaderEvent.DATA_PREPARE_PROGRESS, onWrite, false, 0, true);
			multipartURLLoader.addEventListener(MultipartURLLoaderEvent.DATA_PREPARE_COMPLETE, onWriteEnd, false, 0, true);
			
			// TypeError: Error #2007: Parameter value must be non-null.
			if (id) {
				multipartURLLoader.addVariable("id", id);
			}
			else {
				multipartURLLoader.addVariable("id", "0");
			}
			
			multipartURLLoader.addVariable("nonce", currentToken);

			multipartURLLoader.addFile(file.data, file.name, 'attachment');
			
			// Error: Error #2101: The String passed to URLVariables.decode() must be a 
			//     URL-encoded query string containing name/value pairs.
			multipartURLLoader.load(url, asyncronous);
			
			//parameters.nonce = currentToken;
			//service.send(parameters);
		}
		
		
	
		/**
		 * On upload complete ready 
		 * */
		public function onUploadResult(event:Event):void {
			// You can access loader returned data:
			var loader:URLLoader = MultipartURLLoader(event.currentTarget).loader;
			var data:Object = loader.data;
			var result:String = (loader.data as String).toString();
			var serviceEvent:WPServiceEvent;
			var currentTime:int;
			var json:Object;
			var token:String;
			var anotherCallToGo:Boolean;
			var profile:Boolean;
			
			profile ? responseTime = getTimer() - time :-3;
			
			serviceEvent = new WPServiceEvent(WPServiceEvent.RESULT);
			serviceEvent.call = call;
			serviceEvent.text = result;
			serviceEvent.resultEvent = event;
			
			try {
				profile ? currentTime = getTimer():-0;
				json = JSON.parse(result);
				profile ? parseTime = getTimer()- currentTime:-(1);
				token = json.nonce;
				
				if (json) {
					serviceEvent.data = json;
				}
				
				if (json && json.status=="error") {
					serviceEvent.message = "Update token error";
				}
				
				dispatchEvent(serviceEvent);
				
			}
			catch (e:Error) {
				// Error #1132: Invalid JSON parse input.
				serviceEvent.resultEvent = event;
				serviceEvent.parseError = e;
				serviceEvent.data = json;
				serviceEvent.message = "Parse result error";
				dispatchEvent(serviceEvent);
			}
			
			inProgress 	= false;
			createPending = false;
			updatePending = false;
			uploadPending = false;
			deletePending = false;
			
		}

		/**
		 * On write end
		 * */
		public function onWriteEnd(e:MultipartURLLoaderEvent):void {
			
		}
		
		/**
		 * On write start
		 * */
		public function onWrite(e:MultipartURLLoaderEvent):void {
			
		}
	}
}