

package com.flexcapacitor.effects.database {
	
	import com.flexcapacitor.data.database.SQLColumnData;
	import com.flexcapacitor.data.database.SQLColumnFilter;
	import com.flexcapacitor.effects.database.supportClasses.SelectRecordsInstance;
	import com.flexcapacitor.effects.supportClasses.ActionEffect;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	
	import mx.effects.IEffect;
	
	/**
	 * Event dispatched when select is successful
	 * */
	[Event(name="success", type="flash.events.Event")]
	
	/**
	 * Event dispatched when select is unsuccessful
	 * */
	[Event(name="fault", type="flash.events.Event")]
	
	/**
	 * Event dispatched when an error occurs
	 * */
	[Event(name="error", type="flash.events.Event")]
	
	
	/**
	 * Selects records from the database. AIR Only<br/><br/>
	 * 
Passing in a SQL statement
<pre>
&lt;db:SelectRecords id="select" 
	  connection="{connection}"
	  SQL="Select * from items"
	  >
&lt;/db:SelectRecords>
</pre>
	
Selecting all records from the notes table: 
<pre>
&lt;db:SelectRecords id="select" 
	  tableName="notes" 
	  connection="{connection}"
	  >
&lt;/db:SelectRecords>
</pre>
	
Selecting all records from the notes table and convert the results to objects of type Note
<pre>
&lt;db:SelectRecords id="select" 
	  tableName="notes" 
	  connection="{connection}"
	  itemClass="{Note}"
	  >
&lt;/db:SelectRecords>
</pre>
	
Selecting columns name and id where id is greater than 1 and less than 5 
<pre>
&lt;db:SelectRecords id="selectCategories" 
		  tableName="categories" 
		  connection="{connection}"
		  traceErrorMessage="true"
		  traceSQLStatement="true"
		  >
	&lt;db:fields>
		&lt;database:SQLColumnData name="name" />
		&lt;database:SQLColumnData name="id" />
	&lt;/db:fields>
	&lt;db:filterFields>
		&lt;database:SQLColumnFilter name="id" 
					  operation=">"
					  value="1"/>
		&lt;database:SQLColumnFilter name="id" 
					  operation="& lt;"
					  value="5"
					  join="AND"
					  />
	&lt;/db:filterFields>
&lt;/db:SelectRecords>
</pre>
	
Using a custom SQL query and tracing error messages
<pre>
&lt;db:SelectRecords id="selectCategories" 
	  tableName="categories" 
	  connection="{connection}"
	  SQL="select * from categories c where c.id in (select i.categoryID from items i);"
	  traceErrorMessage="true"
	  >
&lt;/db:SelectRecords>
</pre>
	
Creating a connection, collection, database and table and 
selecting records from it
<pre>
&lt;s:ArrayCollection id="notes" source="{select.data}"/>
 
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


&lt;db:SelectRecords id="select" 
	  tableName="notes" 
	  connection="{connection}"
	  itemClass="{Note}"
	  >
&lt;/db:SelectRecords>
</pre>
	 *
 	 * <b>Notes</b>:<br/>
	 * Error #3115: SQL Error. <br/>
	 * No such column: 'items.categoryID'. <br/><br/>
	 * 
	 * <b>No changes appear to be made</b><br/>
	 * You may need to refresh any collections bound to the SQL results data. 
	 * */
	public class SelectRecords extends ActionEffect {
		
		public static const SUCCESS:String = "success";
		public static const FAULT:String = "fault";
		public static const ERROR:String = "error";
		
		/**
		 *  Constructor.
		 * */
		public function SelectRecords(target:Object = null) {
			// Effect requires non-null targets, so if they didn't give us one
			// we will create a dummy object to serve in its place. If the effect
			// is being used to listen to events, then they will supply a real
			// target of type IEventDispatcher instead, either here or separately
			// in the target attribute
			if (!target) {
				target = new Object();
			}
			
			super(target);
			
			instanceClass = SelectRecordsInstance;
			
		}
		
		
		/**
		 * The SQL Connection
		 * @see GetDatabase
		 * */
		[Bindable]
		public var connection:SQLConnection;
		
		/**
		 * Effect played if file open is successful.  
		 * */
		public var successEffect:IEffect;
		
		/**
		 * Effect played if file open is unsuccessful.  
		 * */
		public var faultEffect:IEffect;
		
		/**
		 * Name of table
		 * */
		public var tableName:String;
		
		/**
		 * Array of columns and values to select
		 * */
		public var fields:Vector.<SQLColumnData>;
		
		/**
		 * ID of the last row inserted. 
		 * */
		public var lastInsertRowID:uint;
		
		/**
		 * Fields used to filter the select clause
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
		 * Traces the SQL results
		 * */
		public var traceResults:Boolean;
		
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