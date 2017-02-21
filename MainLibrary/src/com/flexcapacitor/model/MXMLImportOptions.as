package com.flexcapacitor.model
{
	public class MXMLImportOptions extends ImportOptions
	{
		public function MXMLImportOptions()
		{
			super();
		}
		
		public var importChildNodes:Boolean = true;
		
		public var removeAllOnImport:Boolean;
	}
}