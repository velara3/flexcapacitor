
package com.flexcapacitor.utils {
	import flash.filesystem.File;
	
	public class FileUtils {
		public function FileUtils()
		{
		}
		
		/**
		 * Copies a file to the folder of the destination file. 
		 * 
		 * */
		public static function copyToFolder(file:File, destinationDirectory:File, overwrite:Boolean = false):File {
			var destinationPath:String = "";
			var destinationFile:File;

			if (file==null || destinationDirectory==null) return null;
			
			if (destinationDirectory && destinationDirectory.exists) {
				if (!destinationDirectory.isDirectory) {
					destinationDirectory = destinationDirectory.parent;
				}
				
				destinationFile = new File();
				destinationPath = destinationDirectory.nativePath + "/" + file.name;
				
				// this throws error sometimes
				try {
					destinationFile = destinationFile.resolvePath(destinationPath);
				}
				catch (error1:Error) {
					trace(error1);
				}
				
				// when trying to copy to the same directory possibly:  
				//Error: Error #3014: Cannot copy or move a file or directory to overwrite a containing directory.
				//		at flash.filesystem::File/copyTo()
				if (destinationFile.exists) {
					if (overwrite) {
						file.copyTo(destinationFile, overwrite);
					}
					else {
						destinationFile = null;
					}
				}
				else {
					
					try {
						file.copyTo(destinationFile, overwrite);
					}
					catch (error2:*) {
						trace(error2);
						return null;
					}
				}
			}
			
			return destinationFile;
		}
	}
}