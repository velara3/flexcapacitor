

package com.flexcapacitor.effects.database {
	
	import com.flexcapacitor.data.database.SQLColumnFilter;
	import com.flexcapacitor.effects.database.supportClasses.DeleteRecordInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	
	import mx.effects.IEffect;
	
	/**
	 * Event dispatched when a row is successfully deleted.
	 * */
	[Event(name="success", type="flash.events.Event")]
	
	/**
	 * Event dispatched when a row could not be deleted.
	 * */
	[Event(name="fault", type="flash.events.Event")]
	
	/**
	 * Deletes a record into the database. AIR Only. 
	 * Set the traceSQLError property to true to check for errors (see below).   
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

	
	&lt;db:DeleteRecord tableName="notes" connection="{connection}" 
						fault="trace(sqlError.message)" traceSQLError="true">
		&lt;database:SQLColumnFilter name="id" 
					  operation="="
					  value="1"/>
		&lt;database:SQLColumnFilter name="id" 
					  operation="& lt;"
					  value="5"
					  join="AND"
					  />
	&lt;/db:DeleteRecord>
	
</pre>
	 * 
 	 * <b>Notes</b>:<br/>
	 * <b>Error #3122: Attempt to write a readonly database.</b><br/>
	 * Set the fileMode to create. <br/><br/>
	 * 
	 * <b>Error #3114: An invalid open mode was specified.</b><br/>
	 * Set a different fileMode. The database may need to be copied out to the 
	 * application directory.<br/><br/>
	 * 
	 * <b>Record is not inserted and no error.</b><br/>
	 * You may be checking the incorrect database. Since the database is copied
	 * out of the application directory then you need to check the database 
	 * in the application storage directory not the application directory.<br/><br/>
	 * */
	public class DeleteRecord extends ActionEffect {
		
		public static const SUCCESS:String = "success";
		public static const FAULT:String = "fault";
		public static const ERROR:String = "error";
		
		/**
		 *  Constructor.
		 * */
		public function DeleteRecord(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target) {
				target = new Object();
			}
			
			super(target);
			
			instanceClass = DeleteRecordInstance;
			
		}
		
		/**
		 * The SQL Connection
		 * @see GetDatabase
		 * */
		[Bindable]
		public var connection:SQLConnection;
		
		/**
		 * Effect played if delete is successful.  
		 * */
		public var successEffect:IEffect;
		
		/**
		 * Effect played if delete is unsuccessful.  
		 * */
		public var faultEffect:IEffect;
		
		/**
		 * Name of table
		 * */
		public var tableName:String;
		
		/**
		 * ID of the last row inserted. 
		 * */
		public var lastInsertRowID:uint;
		
		/**
		 * Fields used to filter the delete clause
		 * */
		public var filterFields:Vector.<SQLColumnFilter>;
		
		/**
		 * This value indicates how many rows are returned at one time by the statement. 
		 * The default value is -1, indicating that all the result rows are returned at one time.
		 * */
		public var prefetch:int = -1;
		
		/**
		 * @copy flash.data.SQLStatement#itemClass
		 * */
		public var itemClass:Class;
		
		/**
		 * @copy flash.data.SQLResult
		 * */
		[Bindable]
		public var result:SQLResult;
		
		/**
		 * @copy flash.data.SQLStatement#text
		 * */
		[Bindable]
		public var SQL:String;
		
		/**
		 * @copy flash.data.SQLResult#data
		 * */
		[Bindable]
		public var data:Array;
		
		/**
		 * @copy flash.data.SQLResult#rowsAffected
		 * */
		[Bindable]
		public var rowsAffected:int;
		
		/**
		 * @copy flash.data.SQLResult#complete
		 * */
		[Bindable]
		public var complete:Boolean;
		
		/**
		 * Traces the generated SQL 
		 * */
		public var traceSQLStatement:Boolean;
		
		/**
		 * Traces the error message 
		 * */
		public var traceErrorMessage:Boolean;
		
		/**
		 * Effect played on error
		 * */
		public var errorEffect:IEffect;
		
		/**
		public var traceSQLStatement:Boolean;
		 * Reference to the error event
		 * */
		[Bindable]
		public var errorEvent:Error;
		
	}
}