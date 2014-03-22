
package com.flexcapacitor.services {
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import ru.inspirit.net.MultipartURLLoader;
	import ru.inspirit.net.events.MultipartURLLoaderEvent;
	
	/**
	 * Adds upload attachment. 
	 * 
	 * Example,
	 * 
	 * <pre>
// we need to create service
var uploadAttachmentService:WPAttachmentService = new WPAttachmentService();
uploadAttachmentService.addEventListener(WPService.RESULT, uploadAttachmentResultsHandler, false, 0, true);
uploadAttachmentService.addEventListener(WPService.FAULT, uploadAttachmentFaultHandler, false, 0, true);

uploadAttachmentService.host = getWPURL();

uploadAttachmentService.id = id; // id of document to attach to

// data is file or data is byte array
if (data is FileReference) {
	uploadAttachmentService.file = data as FileReference;
	uploadAttachmentService.uploadAttachment();
}
else {
	uploadAttachmentService.fileData = data as ByteArray;
	
	if (fileName) {
		uploadAttachmentService.fileName = fileName;
	}
	
	if (dataField) {
		uploadAttachmentService.dataField = dataField;
	}
	
	if (contentType) {
		uploadAttachmentService.contentType = contentType;
	}
	
	uploadAttachmentService.uploadAttachment();
}
	</pre>
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
		 * File reference. If file is not specified then pass in byte array, file name and 
		 * other properties in the upload attachment method parameters. 
		 * @see file
		 * */
		public var file:FileReference;
		
		/**
		 * Attachments URL
		 * Options parent
		 * */
		public var uploadAttachmentsURL:String = updatePostURL;
		
		/**
		 * ByteArray of file content. If file is specified then file.data is used. 
		 * @see file
		 * */
		public var fileData:ByteArray;
		
		/**
		 * Name of file. If a file reference is specified then file.name is used. 
		 * @see file
		 * */
		public var fileName:String;
		
		/**
		 * Data field for upload. Default is "attachment".
		 * */
		public var dataField:String = "attachment";
		
		/**
		 * Content type. Default is, "application/octet-stream". 
		 * */
		public var contentType:String = "application/octet-stream";
		
		
		/**
		 * Upload attachment
		 * */
		override public function uploadAttachment(currentToken:String = null):void {
			
			if ((!file || !file.data) && fileData==null) {
				throw new Error("Please select a file or specify file content before calling uploadAttachment");
				return;
			}

			if (!multipartURLLoader) {
				multipartURLLoader = new MultipartURLLoader();
			}
			
			if (currentToken==null) {
				// clear out previous values
				//multipartURLLoader.clearFiles();
				//multipartURLLoader.clearVariables();
				//multipartURLLoader.dispose();
				
			}
			
			// get update token if it doesn't exist yet
			if (currentToken==null) {
				uploadPending = true;
				getUploadToken();
				return;
			}
			
			// we are not supporting multiple files yet - not sure if it works
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
			
			//var dataFormat:String = URLLoaderDataFormat.VARIABLES;
			//multipartURLLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			//multipartURLLoader.dataFormat = 'variables';
			multipartURLLoader.dataFormat = URLLoaderDataFormat.TEXT;
			
			addListeners();
			
			// TypeError: Error #2007: Parameter value must be non-null.
			if (id!=null) {
				multipartURLLoader.addVariable("id", id);
			}
			else {
				multipartURLLoader.addVariable("id", "0");
			}
			
			multipartURLLoader.addVariable("nonce", currentToken);

			
			// uploading byte array sometimes would result in corrupt data
			// passing a file in and getting it's bytes and leaving content type at application/octet-stream
			// seems to work
			// using other types and specifying different content type resulted in 
			// corrupt uploads. have not had time to find what the cause is
			if (file) {
				fileData = file.data;
				if (fileName==null) {
					fileName = file.name;
				}
				if (contentType==file.type) {
					//fileName = file.name;
				}
			}
			multipartURLLoader.addFile(fileData, fileName, dataField, contentType);
			
			// Error: Error #2101: The String passed to URLVariables.decode() must be a 
			//     URL-encoded query string containing name/value pairs.
			multipartURLLoader.load(url, asyncronous);
			
		}
		
	
		/**
		 * On upload complete ready 
		 * */
		public function onComplete(event:Event):void {
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
			
			// clear out previous values
			//multipartURLLoader.clearFiles();
			//multipartURLLoader.clearVariables();
			//multipartURLLoader.dispose();
		}

		/**
		 * On write end
		 * */
		public function onWriteEnd(event:MultipartURLLoaderEvent):void {
			
			if (hasEventListener(event.type)) {
				dispatchEvent(event);
			}
		}
		
		/**
		 * On write start
		 * */
		public function onWrite(event:MultipartURLLoaderEvent):void {
			if (hasEventListener(event.type)) {
				dispatchEvent(event);
			}
		}
		
		/**
		 * 
		 * */
		private function onIOError( event: IOErrorEvent ): void {
			//removeListener();
			if (hasEventListener(event.type)) {
				dispatchEvent(event);
			}
		}

		/**
		 * 
		 * */
		private function onSecurityError( event: SecurityErrorEvent ): void {
			//removeListener();
			if (hasEventListener(event.type)) {
				dispatchEvent(event);
			}
		}

		/**
		 * 
		 * */
		private function onHTTPStatus( event: HTTPStatusEvent ): void {
			if (hasEventListener(event.type)) {
				dispatchEvent(event);
			}
		}

		/**
		 * 
		 * */
		private function onProgress( event: ProgressEvent ): void {
			if (hasEventListener(event.type)) {
				dispatchEvent(event);
			}
		}


		private function addListeners(): void {
			multipartURLLoader.addEventListener(Event.COMPLETE, onComplete, false, 0, false);
			multipartURLLoader.addEventListener(ProgressEvent.PROGRESS, onProgress, false, 0, false);
			multipartURLLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, false);
			multipartURLLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus, false, 0, false);
			multipartURLLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError, false, 0, false);
			
			multipartURLLoader.addEventListener(MultipartURLLoaderEvent.DATA_PREPARE_PROGRESS, onWrite, false, 0, true);
			multipartURLLoader.addEventListener(MultipartURLLoaderEvent.DATA_PREPARE_COMPLETE, onWriteEnd, false, 0, true);
		}

		private function removeListeners(): void {
			multipartURLLoader.removeEventListener(Event.COMPLETE, onComplete);
			multipartURLLoader.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			multipartURLLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			multipartURLLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
			multipartURLLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			
			multipartURLLoader.removeEventListener(MultipartURLLoaderEvent.DATA_PREPARE_PROGRESS, onWrite);
			multipartURLLoader.removeEventListener(MultipartURLLoaderEvent.DATA_PREPARE_COMPLETE, onWriteEnd);
		}
	}
}