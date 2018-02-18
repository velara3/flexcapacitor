function (id, objectId, eventName, callbackName, debug) {
	var application = document.getElementById(objectId);
	var useCapture = true;
	var element;

	if (id=="body") {
		element = document.body;
	}
	else if (id=="window") {
		element = window;
	}
	else {
		element = document.getElementById(id);
	}

	if (debug) {
		console.log("Adding listener for: " + eventName + " to " + element);
	}

	if (element==null) {
		if (debug) console.log("Element was not found: " + id);
		return true;
	}

	if (application==null) {
		if (debug) console.log("application was not found: " + objectId);
		return true;
	}

	var processPaste = function(pasteData) {
		if (debug) console.log("ProcessPaste called");
		return application[callbackName](pasteData);
	}
	
	// two methods = get image data from the clipboard
	// get base64 image data as string from content editable div

	var pasteFunction = function(event) {
		var isDefaultPrevented = false;
		var items = [];
		var numberOfItems = 0;
		var numberOfFiles = 0;
		var numberOfNodes = 0;
		var files;
		var fileObject;
		var reader;
		var clipboardData;
		var itemType;
		var itemKind;
		var blob;
		var types;
		var type;
		var quality = 1;
		var clipboardItems = [];
		var clipboardFiles = [];
		var useFileArray = false;
		var childNodes;
		var loadedFile;
		const PLAIN_TEXT = "text/plain";
		const IMAGE_PNG = "image/png";
		const INVALID = "invalid";
		

		if (debug) console.log("Paste event handler");
		
		clipboardData = event.clipboardData || event.originalEvent.clipboardData;
		types = clipboardData.types;

		if (clipboardData.items && clipboardData.items.length) {
			items = clipboardData.items; // DataTransferItem in DataTransferItemList
			for(var k=0;k<items.length;k++) {
				clipboardItems.push({kind:items[k].kind, type:items[k].type});
			};
			numberOfItems = items.length;
		}
		
		// if files available use them instead of clipboard
		if (clipboardData.files && clipboardData.files.length) {
			items = clipboardData.files; // File in FileList
			for(var m=0;m<items.length;m++) {
				clipboardFiles.push({name:items[m].name,type:items[m].type,size:items[m].size}); // file
			};
			numberOfFiles = items.length;
		}
		
		if (numberOfItems!=0 && numberOfFiles!=0 && useFileArray) {
			items = clipboardData.items;
		}
		
		files = {};
		fileObject = {};
		fileObject.type = INVALID;
		
		if (debug) console.log("Item count:" + items.length);
		if (debug) console.log(event);
		if (debug) console.log("Before Paste Event. CallbackName:" + callbackName);
		
		// dispatch before paste event
		fileObject.types = types;
		fileObject.eventType = "beforePaste";
		fileObject.numberOfItems = numberOfItems;
		fileObject.numberOfFiles = numberOfFiles;
		fileObject.clipboardItems = clipboardItems;
		fileObject.clipboardFiles = clipboardFiles;
		fileObject.numberOfNodes = 0;
		
		isDefaultPrevented = processPaste(fileObject);
		
		if (isDefaultPrevented) {
			if (debug) console.log("Paste prevented by Before Paste event")
			return;
		}
		
		fileObject.eventType = "paste";
		//debugger;

		// if no items in the clipboard loop through the container elements
		if (numberOfItems==0) {
			childNodes = element.childNodes;
			numberOfNodes = childNodes ? childNodes.length : 0;
			
			// we call this after a frame 
			getImageDataURI = function() {
				if (debug) console.log("GetImageDataURI");
				childNodes = element.childNodes;
				numberOfNodes = childNodes ? childNodes.length : 0;

				fileObject.numberOfNodes = numberOfNodes;
				
				for (var j = 0; j < numberOfNodes; j++) {
					var child = childNodes[j];
					var nodeType = child && "nodeType" in child ? child.nodeType : null;
					var tag = child && "tagName" in child && child.tagName ? child.tagName.toLowerCase() : "";
					var nodeName = child && "nodeName" in child && child.nodeName ? child.nodeName.toLowerCase() : "";
					
					fileObject.index = j;
					
					// type 3 is text node, 1 is html element
					if (debug) console.log("Text node:" + nodeName);

					// pasted file
					if (nodeName=="attachment" && child.file) {
						reader = new FileReader();
						reader.file = child.file;
	
						// file load handler
						reader.addEventListener("loadend", function (e) {
							var currentReader = e.target;
	
							loadedFile = currentReader.file; // our reference
	
							fileObject.origin = "fileFromContentEditable";
							fileObject.dataURI = currentReader.result;
							fileObject.name = loadedFile.name;
							fileObject.type = loadedFile.type;
							fileObject.kind = "kind" in loadedFile ? loadedFile.kind : null;
	
	
							if (debug) console.log("File loaded:" + fileObject.type);
							if (debug) console.log(loadedFile);
							if (debug) console.log(currentReader);
	
							processPaste(fileObject);
						});
	
						// file error handler
						// FileError.code is 4; FileError.NOT_READABLE_ERR = 4
						reader.addEventListener("error", function (e) {
							var currentReader = e.target;
	
							loadedFile = currentReader.file; // our reference
	
							fileObject.name = loadedFile.name;
							fileObject.error = e;
							if (debug) console.log("File loaded error:" + loadedFile.type);
							if (debug) console.log(loadedFile);
							if (debug) console.log(currentReader);
	
							processPaste(fileObject);
						});

						if (debug) console.log("Reading file as data URL");
						reader.readAsDataURL(reader.file);
					}
					else if (nodeName=="#text" || nodeType==3) {
						if (debug) console.log("Text data");
						type = PLAIN_TEXT;
						fileObject.value = child.nodeValue;
						fileObject.name = "";
						fileObject.type = type;
						fileObject.origin = "nodeValue";
						
						//fileObject.size = canvas.toBlob(callback); // convert to blob to get size

						processPaste(fileObject);
					}
					else if (tag === "img") {
						// fetching the blob via the URL - is returning TIFF on Safari
						var fetchFromURL = false;
						var image = child;
						type = IMAGE_PNG;
						
						// default is to draw to canvas. alternative is fetch from url
						if (!fetchFromURL) {

							var drawImage = function() {
								if (debug) console.log("Drawing image");
								var canvas = document.createElement("canvas");
								canvas.width = image.naturalWidth;
								canvas.height = image.naturalHeight;
								canvas.getContext("2d").drawImage(image, 0, 0);

								fileObject.dataURI = canvas.toDataURL(IMAGE_PNG, quality);
								fileObject.name = "";
								fileObject.type = type;
								fileObject.origin = "canvas";
								fileObject.width = image.naturalWidth;
								fileObject.height = image.naturalHeight;
								
								//fileObject.size = canvas.toBlob(callback); // convert to blob to get size
								if (debug) console.log("Image captured:" + type);

								processPaste(fileObject);
							}

							if (image.naturalWidth) {
								drawImage();
							} 
							else {
								image.onload = drawImage;
							}
						}
						else {
							var url = child.src;
							
							// read blob url into data uri
							if (url && url.indexOf("blob")===0) {
								if (debug) console.log("Parsing blob URL into DataURI");
								fileObject.origin = "DataURIFromBlobURI";
								
								var getDataURIFromBlobURI = function(url) {
									return fetch(url).then(function(response) {
										return response.blob();
									}).then(function (blob) {
										type = blob.type;
										size = blob.size;
										return new Promise(function(resolve, reject) {
											const reader = new FileReader();
											reader.onerror = reject;
											reader.onloadend = function(progressEvent) {
												return resolve(reader.result);
											}
											reader.readAsDataURL(blob);
										}
									)}
								)}
								
								getDataURIFromBlobURI(url).then(function(dataURI) {
									if (debug) console.log("DataURI:" + dataURI);
									fileObject.dataURI = dataURI;
									fileObject.type = type;
									fileObject.size = size;
									processPaste(fileObject);
								}, function(err) {
									if (debug) console.log("Read as URL error");
									fileObject.name = null;
									fileObject.dataURI = null;
									if (debug) console.log("CallbackName:" + callbackName);
									
									processPaste(fileObject);
								})
							}
						}
					}
				}
			}
			
			window.key = setTimeout(getImageDataURI, 1);
			return;
		}
		
		//debugger;
		
		// loop through items in the clipboard - not supported in safari osx atm
		// item in items can be DataTransferItem or File
		for (var i = 0; i < numberOfItems; i++) {
			if (items[i]==null) continue; // clipboard items may be emptied
			// when item is DataTransferItem the value is "string" or "file". when item is File value is null
			itemKind = items[i].kind;
			itemType = Object.prototype.toString.call(items[i]).slice(8, -1);
			type = items[i].type; // mime type
			if (debug) console.log("Item["+i+"]: " + type);

			// local references seem to be overwritten when in a loop for some reason
			files[i] = items[i];

			if (debug) console.log(items[i]);
			
			// if DataTransferItem and is string
			if (itemKind=="string" && "getAsString" in items[i]) {
				items[i].getAsString(function(value) {
					fileObject.origin = "stringFromClipboard";
					
					fileObject.value = value;
					//fileObject.name = name;
					fileObject.type = type;
					fileObject.kind = itemKind;

					if (debug) console.log(itemKind + " from clipboard:" + value.slice(0, 100) + "...");

					processPaste(fileObject);
				});
				
				continue;
			}
			// if not string - DataTransferItem or File 
			else if (itemKind=="file" || itemType=="File") {
				if (debug) console.log("Pasted item is not string");

				if ("getAsFile" in items[i]) {
					blob = items[i].getAsFile();
				}
				else if ("webkitGetAsEntry" in items[i]) {
					blob = items[i].webkitGetAsEntry();
				}
				else if ("getData" in items[i]) {
					blob = items[i].getData();
					// is DataTransferItem
				}
				else if (items[i] instanceof File) {
					blob = items[i];
				}

				if (debug) console.log(blob);
			}

			if (blob==null) {
				fileObject.error = "content is null";
				fileObject.type = type;
				fileObject.kind = itemKind;
				processPaste(fileObject);
				continue;
			}

			reader = new FileReader();
			reader.file = files[i];

			// file load handler
			reader.addEventListener("loadend", function (e) {
				var currentReader = e.target;
				
				loadedFile = currentReader.file; // our reference

				if (clipboardFiles.length) {
					fileObject.origin = "fileFromClipboard";
				}
				else {
					fileObject.origin = "itemFromClipboard";
				}
				fileObject.dataURI = currentReader.result;
				fileObject.name = loadedFile.name;
				fileObject.type = loadedFile.type;
				fileObject.kind = "kind" in loadedFile ? loadedFile.kind : null;
				

				if (debug) console.log("File loaded:" + fileObject.type);
				if (debug) console.log(loadedFile);
				if (debug) console.log(currentReader);

				processPaste(fileObject);
			});
			
			// file error handler
			reader.addEventListener("error", function (e) {
				var currentReader = e.target;
				
				loadedFile = currentReader.file; // our reference

				fileObject.name = loadedFile.name;
				fileObject.error = e;
				if (debug) console.log("File loaded error:" + loadedFile.type);
				if (debug) console.log(loadedFile);
				if (debug) console.log(currentReader);

				processPaste(fileObject);
			});

			// if blob found read as data URI
			// typically image/png but could also be text/rtf, text/plain, text/html
			if (blob) {
				if (debug) console.log("Reading blob as data URL");
				reader.readAsDataURL(blob);
			}
		}

		if (debug) console.log("End of paste event handler");
	}

	if (application.clipboardHandlers==null) {
		application.clipboardHandlers = {};
	}

	if (eventName=="paste") {
		if (debug) console.log("Adding paste listener");
		application.clipboardHandlers[eventName] = pasteFunction;
	}
	
	element.addEventListener(eventName, application.clipboardHandlers[eventName], useCapture);


	if (debug) console.log("End of add paste listener");
	return true;
}