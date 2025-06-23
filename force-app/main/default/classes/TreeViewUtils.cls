public with sharing class TreeViewUtils {

    private static JSONGenerator gen {get; set;}

    public class TreeNode {
   
        public TreeNode(){
            hasChildren = false;
        }

        public String key {get; set;}
        public String parentKey {get; set;}
        public String ultimateParentId {get; set;}
        public String targetId {get; set;}
		public String targetObjectType {get; set;}
        public String name {get; set;}
        public String itemType {get; set;}
        public Boolean unselectable {get; set;}
        public Boolean selected {get; set;}
        public Boolean expand {get; set;}
        public Boolean isFolder {get; set;}
        public SObject item {get; set;}
        
       
        public Boolean hasChildren {get; set;}
        public Boolean isLeafNode {get; set;}
        public List<TreeNode> childNodes {get; set;}
    }	
	
	public class TreeSourceRec {
		public String key {get; set;}
		public String parentKey {get; set;}
		public String targetId {get; set;}
		public String ultimateParentId {get; set;}
		public String targetObjectType {get; set;}
		public String itemType {get; set;}
        public String name {get; set;}
        public Boolean unselectable {get; set;}
        public Boolean selected {get; set;}
        public Boolean expand {get; set;}
        public Boolean isFolder {get; set;}
        public SObject item {get; set;}
		
		public TreeSourceRec() {
			key = '';
			targetId = '';
			targetObjectType = '';
			itemType = '';
			name = '';
			unselectable = false;
			selected = false;
			expand = true;
			isFolder = true;
			parentKey = '';
			ultimateParentId = '';
		}
		
	}

	public class TreeSourceRecs {
		
		public TreeSourceRecs(List<TreeSourceRec> treeSourceRecs) {
			this.recs = treeSourceRecs;
			init();
		}
		
		public List<TreeSourceRec> recs {get; set;}

		private Map<String,TreeSourceRec> recMap; 
    	private Map<String,List<TreeSourceRec>> parentToChildMap;
		
		private void init() {
	        parentToChildMap = new Map<String, List<TreeSourceRec>>();
	        recMap = new Map<String,TreeSourceRec>();   
	    
	        for (TreeSourceRec rec : recs) {
	        	
	        	recMap.put(rec.key,rec);
	        	
	            List<TreeSourceRec> childRecs;
	            if (!parentToChildMap.containsKey(rec.parentKey)){
	                childRecs = new List<TreeSourceRec>();
	                childRecs.Add(rec);
	                parentToChildMap.put(rec.parentKey, childRecs);
	            }
	            else {
	                childRecs = (List<TreeSourceRec>) parentToChildMap.get(rec.parentKey);
	                childRecs.add(rec);
	                parentToChildMap.put(rec.parentKey, childRecs);
	            }
	        }
		}

		public TreeNode createTreeNode(String startingId) {
	        TreeNode treeNode = new TreeNode();
			TreeSourceRec mainRec = recMap.get(startingId);

			//Populate TreeNode from mainRec
			treeNode.key = mainRec.key;
			treeNode.ultimateParentId = mainRec.ultimateParentId;
			treeNode.targetId = mainRec.targetId;
			treeNode.targetObjectType = mainRec.targetObjectType;
			treeNode.name = mainRec.name;
			treeNode.itemType = mainRec.itemType;
			treeNode.item = mainRec.item;
			treeNode.unselectable = mainRec.unselectable;
			treeNode.selected = mainRec.selected;
			treeNode.expand = mainRec.expand;
			treeNode.isFolder = mainRec.isFolder;
			treeNode.parentKey = mainRec.parentKey;
			
			List<TreeSourceRec> children = parentToChildMap.get(startingId);	
	
			if (children != null) {
	            treeNode.isLeafNode = false;
				treeNode.hasChildren = true;
				treeNode.childNodes = new List<TreeNode>();
				for (TreeSourceRec r : children) {
	                treeNode.childNodes.add(createTreeNode(r.key));
	            }          
				
			}	
			else {
				treeNode.isLeafNode = true;
				treeNode.hasChildren = false;
			}	

	        return treeNode;
	    }


		
		public String getTreeJSONfromTreeSourceData(String startingKey) {
	        List<String> keysToProcess = new List<String>();
	        keysToProcess.add(startingKey);
	        return getTreeJSONfromTreeSourceData(keysToProcess);
		}

	
		public String getTreeJSONfromTreeSourceData(List<String> startingKeys) {
	        TreeViewUtils.gen = JSON.createGenerator(true);
	        
	        TreeViewUtils.gen.writeStartArray();
 	        for (String keyToProcess : startingKeys) {
		        TreeNode node = createTreeNode(keyToProcess);
	            convertNodeToJSON(node);
 	        }
	        TreeViewUtils.gen.writeEndArray();
 	        
	        return TreeViewUtils.gen.getAsString();
	    }

/*	
		public String getTreeJSONfromTreeSourceData(String startingKey) {
	        TreeViewUtils.gen = JSON.createGenerator(true);
	        TreeNode node = createTreeNode(startingKey);
	        TreeViewUtils.gen.writeStartArray();
	            convertNodeToJSON(node);
	        TreeViewUtils.gen.writeEndArray();
	        return TreeViewUtils.gen.getAsString();
	    }
*/	
	    private void convertNodeToJSON(TreeNode treeNode){
	        TreeViewUtils.gen.writeStartObject();
	            TreeViewUtils.gen.writeStringField( 'title', treeNode.name);
	            TreeViewUtils.gen.writeStringField( 'key', treeNode.key);
	            TreeViewUtils.gen.writeBooleanField( 'unselectable', treeNode.unselectable );
	            TreeViewUtils.gen.writeBooleanField( 'select', treeNode.selected );
	            TreeViewUtils.gen.writeBooleanField( 'expand', treeNode.expand );
//	            TreeViewUtils.gen.writeBooleanField( 'isFolder', treeNode.isFolder );
	            TreeViewUtils.gen.writeBooleanField( 'isFolder', treeNode.hasChildren );
	            if (treeNode.hasChildren)
	            {
	                TreeViewUtils.gen.writeFieldName( 'children');
	                TreeViewUtils.gen.writeStartArray();
	                if (treeNode.hasChildren) {
	                    for (TreeNode r : treeNode.childNodes) {
	                        convertNodeToJSON(r);
	                    }
	                }
	                TreeViewUtils.gen.writeEndArray();
	            }
	            TreeViewUtils.gen.writeStringField( 'targetId', treeNode.targetId);
	            TreeViewUtils.gen.writeStringField( 'ultimateParentId', treeNode.ultimateParentId);
	            TreeViewUtils.gen.writeStringField( 'targetObjectType', treeNode.targetObjectType);
	            TreeViewUtils.gen.writeStringField( 'itemType', treeNode.itemType);
	        TreeViewUtils.gen.writeEndObject();
	    }
	}
}