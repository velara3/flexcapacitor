

package com.flexcapacitor.effects.database {
	
	import com.flexcapacitor.effects.database.supportClasses.GetDatabaseInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.data.SQLConnection;
	import flash.net.Responder;
	import flash.utils.ByteArray;
	
	import mx.effects.IEffect;
	
	/**
	 * Event dispatched on close event
	 * */
	[Event(name="close", type="flash.events.Event")]
	
	/**
	 * Event dispatched on progress event
	 * */
	[Event(name="progress", type="flash.events.Event")]
	
	/**
	 * Event dispatched on output progress event
	 * */
	[Event(name="outputProgress", type="flash.events.Event")]
	
	/**
	 * Event dispatched when file is successfully open
	 * */
	[Event(name="success", type="flash.events.Event")]
	
	/**
	 * Event dispatched when file opening is unsuccessful
	 * */
	[Event(name="fault", type="flash.events.Event")]
	
	/**
	 * Event dispatched when file not found
	 * */
	[Event(name="fileNotFound", type="flash.events.Event")]
	
	/**
	 * Event dispatched when the backup file was not found
	 * */
	[Event(name="backupFileNotFound", type="flash.events.Event")]
	
	/**
	 * Event dispatched when the backup file was used
	 * */
	[Event(name="backupFileUsed", type="flash.events.Event")]
	
	/**
	 * Event dispatched when the database has not been created yet
	 * */
	[Event(name="notCreated", type="flash.events.Event")]
	
	/**
	 * Event dispatched when an error occurs while opening the database
	 * */
	[Event(name="error", type="flash.events.Event")]
	
	/**
	 * Get a database file. 
	 * AIR ONLY
	 * 

<pre>
 
	&lt;database:SQLConnection id="connection"/>
 
	&lt;db:GetDatabase id="database" fileName="myData.db" connection="{connection}">
		&lt;db:notCreatedEffect>
			&lt;db:CreateTable connection="{connection}" tableName="notes" >
				&lt;db:fields>
					&lt;database:SQLColumn name="id" 
										 autoIncrement="true" 
										 dataType="INTEGER" 
										 primaryKey="true"/>
					&lt;database:SQLColumn name="title"  
										 dataType="TEXT" />
					&lt;database:SQLColumn name="content"  
										 dataType="TEXT" />
					&lt;database:SQLColumn name="creationDate"  
										dataType="TEXT" />
					&lt;database:SQLColumn name="modifyDate"  
										dataType="TEXT" />
				&lt;/db:fields>
			&lt;/db:CreateTable>
		&lt;/db:notCreatedEffect>
	&lt;/db:GetDatabase>

			
	&lt;db:InsertRecord tableName="notes" connection="{connection}">
		&lt;db:fields>
			&lt;database:SQLColumnData name="title" value="USA" />
			&lt;database:SQLColumnData name="content" value="Minneapolis" />
		&lt;/db:fields>
	&lt;/db:InsertRecord>
	
	&lt;db:InsertRecord tableName="notes" connection="{connection}">
		&lt;db:fields>
			&lt;database:SQLColumnData name="title" value="UK" />
			&lt;database:SQLColumnData name="content" value="London" />
		&lt;/db:fields>
	&lt;/db:InsertRecord>
	
	&lt;db:SelectRecords id="select" 
					  tableName="notes" 
					  connection="{connection}"
					  itemClass="{Note}"
					  >
	&lt;/db:SelectRecords>
</pre>
 * 
 	 * <b>Notes</b>:
	 * Error #3125: Unable to open the database file.
	 * */
	public class GetDatabase extends ActionEffect {
		
		public static const APPLICATION_STORAGE:String = "applicationStorage";
		public static const APPLICATION:String = "application";
		public static const DESKTOP:String = "desktop";
		public static const DOCUMENTS:String = "documents";
		public static const USER:String = "user";
		public static const ROOT:String = "root";
		
		public static const SUCCESS:String = "success";
		public static const FAULT:String = "fault";
		public static const FILE_NOT_FOUND:String = "fileNotFound";
		public static const BACKUP_FILE_NOT_FOUND:String = "backupFileNotFound";
		public static const BACKUP_FILE_USED:String = "backupFileUsed";
		public static const NOT_CREATED:String = "notCreated";
		public static const ERROR:String = "error";
		public static const PROGRESS:String = "progress";
		public static const OUTPUT_PROGRESS:String = "outputProgress";
		public static const CLOSE:String = "close";
		
		/**
		 *  Constructor.
		 * */
		public function GetDatabase(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target) {
				target = new Object();
			}
			
			super(target);
			
			instanceClass = GetDatabaseInstance;
			
		}
		
		/**
		 * Name of file, such as "myData" or "myData.db", or directory and file name, "assets/myData.db".
		 * If the directory property is set it is prepended to the file name.
		 * 
		 * @see directory
		 * @see fileExtension
		 * */
		public var fileName:String;
		
		/**
		 * @copy flash.data.SQLConnection
		 * */
		[Bindable]
		public var connection:SQLConnection;
		
		/**
		 * 
		 * @copy flash.data.SQLConnection#async
		 * */
		public var async:Boolean;
		
		/**
		 * Directory of the file. Optional.
		 * The file name property can include the file path.
		 * */
		public var directory:String;
		
		/**
		 * Create the file if it doesn't exist. Default is false
		 * 
		 * @see createFromBackup
		 * @see backupPath
		 * */
		public var createFile:Boolean;
		
		/**
		 * Copies a database file from the backup location
		 * 
		 * @see backupPath
		 * */
		public var createFromBackup:Boolean;
		
		/**
		 * Location of backup file if database does not exist in target location.
		 * Create from backup must be set to true.
		 * 
		 * @see createFromBackup
		 * */
		public var backupPath:String;
		
		/**
		 * File extension.
		 * */
		public var fileExtension:String = "";
		
		/**
		 * Location of path that other files will be relative to if not specified.
		 * Includes applicationStorageDirectory, applicationDirectory, userDirectory,
		 * desktopDirectory, documentsDirectory or root directory.
		 * Default is applicationStorage
		 * */
		[Inspectable(enumeration="application,applicationStorage,user,desktop,documents,root")]
		public var baseFilePath:String = APPLICATION_STORAGE;
		
		/**
		 * Prints the file URL to the console.
		 * */
		public var traceFilePaths:Boolean;
		
		/**
		 * Prints the errors to the console.
		 * */
		public var traceErrors:Boolean;
		
		/**
		 * Reference to the file. You do not set this. 
		 * */
		[Bindable]
		public var file:Object;
		
		/**
		 * @copy flash.filesystem.FileMode
		 * */
		[Inspectable(enumeration="create,read,write,append,update")]
		public var fileMode:String = "create";
		
		/**
		 * @copy flash.data.SQLConnection.open()
		 * */
		public var autoCompact:Boolean;
		
		/**
		 * @copy flash.data.SQLConnection.open()
		 * */
		public var pageSize:int = 1024;
		
		/**
		 * @copy flash.data.SQLConnection.openAsync()
		 * */
		public var responder:Responder;
		
		/**
		 * @copy flash.data.SQLConnection.open()
		 * */
		[Bindable]
		public var encryptionKey:ByteArray;
		
		/**
		 * Effect played if file open is successful.  
		 * */
		public var successEffect:IEffect;
		
		/**
		 * Effect played if file open is unsuccessful.  
		 * */
		public var faultEffect:IEffect;
		
		/**
		 * Effect played if database has not been created not found. 
		 * */
		public var notCreatedEffect:IEffect;
		
		/**
		 * Effect played if file is not found. 
		 * */
		public var fileNotFoundEffect:IEffect;
		
		/**
		 * Effect played if backup file is not found. 
		 * */
		public var backupFileNotFoundEffect:IEffect;
		
		/**
		 * Effect played if backup file was used. 
		 * */
		public var backupFileUsedEffect:IEffect;
		
		/**
		 * Effect played on progress event  
		 * */
		public var progressEffect:IEffect;
		
		/**
		 * Effect played on output progress event  
		 * */
		public var outputProgressEffect:IEffect;
		
		/**
		 * Effect played on close event
		 * */
		public var closeEffect:IEffect;
		
		/**
		 * Effect played on error during opening of database
		 * */
		public var errorEffect:IEffect;
		
		/**
		 * Reference to the error event
		 * */
		[Bindable]
		public var errorEvent:Error;
		
		/**
		 * Path to saved file. You do not set this. 
		 * It is set after file is retrieved. 
		 * */
		[Bindable]
		public var filePath:String;
		
		/**
		 * Path to saved file
		 * */
		[Bindable]
		public var nativeFilePath:String;
		
		/**
		 * Relative path to saved file
		 * */
		[Bindable]
		public var relativeFilePath:String;
	}
}