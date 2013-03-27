

package com.flexcapacitor.effects.database.supportClasses {
	import com.flexcapacitor.data.database.SQLColumnData;
	import com.flexcapacitor.data.database.SQLColumnFilter;
	import com.flexcapacitor.effects.database.SelectRecords;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.Event;
	
	import mx.utils.ObjectUtil;
	
	
	/**
	 * @copy SelectRecords
	 * */  
	public class SelectRecordsInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function SelectRecordsInstance(target:Object) {
			super(target);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 * */
		override public function play():void {
			// Dispatch an effectStart event
			super.play();
			
			var action:SelectRecords = SelectRecords(effect);
			var connection:SQLConnection = action.connection;
			var tableName:String = action.tableName;
			var fields:Vector.<SQLColumnData> = action.fields;
			var filterFields:Vector.<SQLColumnFilter> = action.filterFields;
			var itemClass:Class = action.itemClass;
			var prefetch:int = action.prefetch;
			var request:String = action.SQL;
			var filterField:SQLColumnFilter;
			var SQL:String = action.SQL;
			var statement:SQLStatement;
			var field:SQLColumnData;
			var fieldsLength:int;
			var result:SQLResult;
			var successful:Boolean;
			var parameters:Object;
			var alias:String;
			
			///////////////////////////////////////////////////////////
			// Verify we have everything we need before going forward
			///////////////////////////////////////////////////////////
			
			if (validate) {
				if (!connection) {
					dispatchErrorEvent("A connection is required");
				}
				if (!tableName) {
					dispatchErrorEvent("A table name must be specified");
				}
			}
			
			
			///////////////////////////////////////////////////////////
			// Continue with action
			///////////////////////////////////////////////////////////
			
			statement = new SQLStatement();
			statement.sqlConnection = connection;
			statement.itemClass = action.itemClass;
			parameters = statement.parameters;
			
			
			if (SQL) {
				request = SQL;
			}
			else {
				// build request statement
				request = "SELECT ";
				
				fieldsLength = fields ? fields.length : 0;
				
				if (fieldsLength) {
					// get column names
					for (var i:int;i<fieldsLength;i++) {
						if (i>0) request += ",";
						field = fields[i];
						request += field.name;
					}
				}
				else {
					request += " *";
				}
				
				request += " FROM " + tableName;
				
				fieldsLength = filterFields ? filterFields.length : 0;
				
				// where clause
				if (fieldsLength>0) {
					request += " WHERE ";
					
					// get column name and value
					for (i=0;i<fieldsLength;i++) {
						filterField = filterFields[i];
						
						if (i != 0) {
							request += " " + filterField.join + " ";
						}
						
						request += filterField.tableName + filterField.name + filterField.operation;
						request += filterField.dataType=="TEXT" ? "\""+filterField.value+"\"":filterField.value;
					}
				}
			}
			
			// sql statement
			statement.text = request;
			
			if (action.traceSQLStatement) {
				traceMessage(request);
			}
			
			try {
				statement.execute(prefetch);
				result = statement.getResult();
				successful = true;
			}
			catch(error:Error) {
				successful = false;
				action.errorEvent = error;

				
				if (action.traceErrorMessage) {
					traceMessage(error.message);
					
					if ("details" in error) {
						traceMessage(error['details']);
					}
				}
				
				if (action.hasEventListener(SelectRecords.ERROR)) {
					dispatchActionEvent(new Event(SelectRecords.ERROR));
				}
				
				if (action.errorEffect) {
					playEffect(action.errorEffect);
				}
			}
			
			// sql result
			action.result = result;

			// records data
			if (result) {
				
				if (result.data) {
					action.data = result.data;
				}
				else {
					action.data = [];
				}
			}
			else {
				action.data = [];
			}
			
			if (action.traceResults) {
				if (action.data==null || action.data.length==0) {
					traceMessage("No records");
				}
				else {
					traceMessage("Results: " + ObjectUtil.toString(action.data));
				}
			}
			
			// success
			if (successful) {
				
				if (action.hasEventListener(SelectRecords.SUCCESS)) {
					dispatchActionEvent(new Event(SelectRecords.SUCCESS));
				}
				
				if (action.successEffect) {
					playEffect(action.successEffect);
				}
			}
			else {
				
				// fault
				if (action.hasEventListener(SelectRecords.FAULT)) {
					dispatchActionEvent(new Event(SelectRecords.FAULT));
				}
				
				if (action.faultEffect) {
					playEffect(action.faultEffect);
				}
			}
			
			
			
			///////////////////////////////////////////////////////////
			// Finish the effect
			///////////////////////////////////////////////////////////
			finish();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		
	}
}