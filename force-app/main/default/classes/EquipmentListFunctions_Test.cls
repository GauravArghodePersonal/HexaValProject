@isTest
private class EquipmentListFunctions_Test {

    static Product2 equip1;
    static List<EquipmentListController.Equipment> eqplist; 

    static testMethod void test01() {
    	createTestData();
    	EquipmentListController c = new EquipmentListController();
    	c.newEquip = new EquipmentListController.Equipment(equip1);
    	c.createEquipment();
        c.createEquipment(); // to test upsert
        c.initEquipList();
        eqplist = c.getEquipList();
        c.getEquipsToDeactivate();
        c.getEquipsToDelete();
        if (eqplist != null && !eqplist.isEmpty()) {
	        eqplist[0].selected = true;
	        c.getEquipsToDeactivate();
            c.getEquipsToDelete();
	        c.updateEquips();
        }
    }
    
    static void createTestData() {
    	equip1 = new Product2();
    	equip1.Make__c = 'Test Make';
    	equip1.Model__c = 'Test Model';
    	equip1.Name = 'Test Equipment';
    	equip1.Key__c = 'Test Equipment Key';
    	//insert equip1;
    }
    static void getEquipmentPC(){
        
    }
}