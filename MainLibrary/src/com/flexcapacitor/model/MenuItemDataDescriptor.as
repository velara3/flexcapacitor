
package com.flexcapacitor.model {
	import mx.controls.treeClasses.DefaultDataDescriptor;
	
	/**
	 * Describes how menu item data is displayed in a menu bar
	 * */
	public class MenuItemDataDescriptor extends DefaultDataDescriptor {
		
		
		public function MenuItemDataDescriptor() {
			super();
		}
		
	
	    /**
	     * We added the children property to the menu items so we need to cancel
		 * if it's a branch if there are no children
	     */
		override public function isBranch(node:Object, model:Object = null):Boolean
		{
			if (node == null) {
				return false;
			}
			
			var branch:Boolean = false;
			
			if (node is Object)
			{
				try
				{
					if (node.children && node.children.length>0)   {
						branch = true;
					}
				}
				catch(e:Error)
				{
				}
			}
			return branch;
		}

	}
}