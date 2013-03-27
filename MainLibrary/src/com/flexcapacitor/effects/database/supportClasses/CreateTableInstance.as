

package com.flexcapacitor.effects.database.supportClasses {
	import com.flexcapacitor.data.database.SQLColumn;
	import com.flexcapacitor.effects.database.CreateTable;
	import com.flexcapacitor.effects.supportClasses.ActionEffectInstance;
	
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.events.Event;
	
	
	/**
	 * @copy CreateTable
	 * */  
	public class CreateTableInstance extends ActionEffectInstance {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * */
		public function CreateTableInstance(target:Object) {
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
			
			var action:CreateTable = CreateTable(effect);
			var connection:SQLConnection = action.connection;
			var tableName:String = action.tableName;
			var fields:Array = action.fields;
			var statement:SQLStatement;
			var request:String;
			var field:SQLColumn;
			var fieldsLength:int;
			var successful:Boolean;
			
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
			
			request = "CREATE TABLE IF NOT EXISTS ";
			
			request += tableName + " (";
			
			fieldsLength = fields.length;
			
			for (var i:int;i<fieldsLength;i++) {
				field = fields[i];
				if (i>0) request += ",";
				request += " " + field.marshall();
			}
			
			request += ")";
			
			statement.text = request;
			
			try {
				statement.execute();
				successful = true;
			} catch(error:Error) {
				trace(error.message);
				successful = false;
			}
			
			// success
			if (successful) {
				
				if (action.hasEventListener(CreateTable.SUCCESS)) {
					dispatchActionEvent(new Event(CreateTable.SUCCESS));
				}
				
				if (action.successEffect) {
					playEffect(action.successEffect);
				}
			}
			else {
				
				// fault
				if (action.hasEventListener(CreateTable.FAULT)) {
					dispatchActionEvent(new Event(CreateTable.FAULT));
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