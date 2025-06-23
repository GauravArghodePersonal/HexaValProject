@isTest
private class Account_Sales_Info_Controller_Test{
    @isTest static void Account_Sales_Info_Controllermethod (){
    Boolean show_Data = true;
    String materialName ='test';
    String rpsView = 'test';
    String gmgpLabel = 'test1';
    Account_Sales_Info_Controller controller = new Account_Sales_Info_Controller();
    controller.getAccId();
    controller.getRpsViewLabel();
    controller.searchByMaterialName();
    controller.pc1Size();
    controller.pc1Frst();
    controller.pc1Prev();
    controller.pc1Next();
    controller.pc1Last();
    controller.pc1Goto();
    controller.setRpsView();
    System.assertEquals(show_Data,true);
    System.assertEquals(materialName,'test');
    System.assertEquals(rpsView,'test');
    System.assertEquals(gmgpLabel,'test1');
    }
}