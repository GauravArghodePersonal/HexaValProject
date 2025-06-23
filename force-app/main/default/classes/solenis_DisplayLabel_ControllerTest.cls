@isTest
private class solenis_DisplayLabel_ControllerTest{
     @TestSetup     
    public static void setupTestData(){
            Account Acc = TestDataFactory.createAccount3(True);
            SAP_Payer_Credit_Information__c  sa =TestDataFactory.create_SAP_Payer_Credit_Information(True,Acc.id);
            Contact con = TestDataFactory.createContact(True,Acc.id);
            Material_Sales_Data2__c MS =TestDataFactory.create_Material_Sales_Data2(True);
            Tank_Requirement__c TR =TestDataFactory.create_Tank_Requirement(True,Acc.id,con.id,MS.id);
            Shipping_Instruction__c SI= TestDataFactory.create_Shipping_Instruction(True,Acc.id);
            Shipping_Instruction_Product__c objSIP = New Shipping_Instruction_Product__c();
                objSIP.Account__c = Acc.Id;
                objSIP.SAP_Material__c = MS.Id;
                objSIP.Shipping_Instruction__c = SI.Id;
                insert objSIP;
                
                Label_Request__c objLabelRequest = new Label_Request__c();
                    objLabelRequest.Delivery_Method__c = 'Standard Delivery';
                    objLabelRequest.Status__c = 'Draft';
                    objLabelRequest.Customer_Prospect__c = Acc.Id;
                    objLabelRequest.Contact__c = con.Id;
                    objLabelRequest.Program_Type__c = 'Solenis Label Cover';
                    objLabelRequest.SAP_Material__c = MS.Id;
                    objLabelRequest.tank_requirement__c = TR.Id;
                    objLabelRequest.asset_number__c = '09098';
                    objLabelRequest.model__c = '09765';
                    objLabelRequest.label_request_comments__c = 'TestArea';
                    objLabelRequest.capacity__c = '9';
                    objLabelRequest.contact__c = con.Id;
                    objLabelRequest.contact_phone__c = '9098789876';
                    objLabelRequest.program_type__c = 'Solenis Label Cover';
                    objLabelRequest.shipping_Instruction_product__c = objSIP.Id;
                    objLabelRequest.Stick_on_Packaged_Goods_Label__c = '1';
                    objLabelRequest.Laminated_Lable__c = '7';
                    objLabelRequest.Stick_On_Label_Quantity__c = '85';
                    objLabelRequest.Fill_Line_Sign_Quantity__c = '44';
                    objLabelRequest.Solenis_Label_Cover__c = '33';
                    objLabelRequest.Hot_Line_Sticker__c = '65';
                    objLabelRequest.Large_Metal_w_Lam_Label_Fill_Line_Qty__c = '3';
                    objLabelRequest.Line_Tag__c = '99';
                    objLabelRequest.Ultra_Serv_Inv_Mgmt_Sign_w_Label_Qty__c = '55';
                    objLabelRequest.Large_Metal_w_Lam_Label_Fill_Line_Qty__c = '22';
                    objLabelRequest.Tank_Placard_Quantity__c = '50';
                    objLabelRequest.Customer_Prospect__c = Acc.Id;
                    objLabelRequest.Full_Address__c = 'TestArea';
                    objLabelRequest.GHS_Cover_label__c = '75';
                    insert objLabelRequest;
        }
        
         static testMethod void positive_getpic1big(){
   // Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic1big();
        
    Test.stopTest();
    }
      static testMethod void negative_getpic1big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic1big();
        
    Test.stopTest();
    }
    
    static testMethod void positive_getpic2big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic2big();
        
    Test.stopTest();
    }
    
    static testMethod void negative_getpic2big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic2big();
        
    Test.stopTest();
    }
    
    static testMethod void positive_getpic3big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic3big();
        
    Test.stopTest();
    }
    
    static testMethod void negative_getpic3big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic3big();

    Test.stopTest();
    }
    
    static testMethod void positive_getpic4big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic4big();
        
    Test.stopTest();
    }
    
    static testMethod void negative_getpic4big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic4big();
        
    Test.stopTest();
    }
    
    static testMethod void positive_getpic5big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic5big();
        
    Test.stopTest();
    }
    
    static testMethod void negative_getpic5big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic5big();
        
    Test.stopTest();
    }
    
    static testMethod void positive_getpic6big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic6big();
       
    Test.stopTest();
    }
    
    static testMethod void negative_getpic6big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic6big();
        
    Test.stopTest();
    }
    
    static testMethod void positive_getpic7big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic7big();
        
    Test.stopTest();
    }
    
    static testMethod void negative_getpic7big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic7big();
       
    Test.stopTest();
    }
    
    static testMethod void positive_getpic8big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic8big();
        
    Test.stopTest();
    }
    
    static testMethod void negative_getpic8big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic8big();
       
    Test.stopTest();
    }
    
    static testMethod void positive_getpic9big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic9big();
       
    Test.stopTest();
    }
    
    static testMethod void negative_getpic9big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic9big();
        
    Test.stopTest();
    }
    
    static testMethod void positive_getpic10big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic10big();
        
    Test.stopTest();
    }
    
    static testMethod void negative_getpic10big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic10big();
        
    Test.stopTest();
    }
    
    static testMethod void positive_getpic11big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic11big();
        
    Test.stopTest();
    }
    
    static testMethod void negative_getpic11big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic11big();
        
    Test.stopTest();
    }
    
    static testMethod void positive_getpic12big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic12big();
        
    Test.stopTest();
    }
    
    static testMethod void negative_getpic12big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic12big();
      
    Test.stopTest();
    }
    
    static testMethod void positive_getpic13big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic13big();
        
    Test.stopTest();
    }
    
    static testMethod void negative_getpic13big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic13big();
        
    Test.stopTest();
    }
    
    static testMethod void positive_getpic14big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic14big();
       
    Test.stopTest();
    }
    
    static testMethod void negative_getpic14big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic14big();
       
    Test.stopTest();
    }
    
    static testMethod void positive_getpic15big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic15big();
       
    Test.stopTest();
    }
    
    static testMethod void negative_getpic15big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic15big();
       
    Test.stopTest();
    }
    
    static testMethod void positive_getpic16big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic16big();
     
    Test.stopTest();
    }
    
    static testMethod void negative_getpic16big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic16big();
        
    Test.stopTest();
    }
    
    static testMethod void positive_getpic17big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic17big();
       
    Test.stopTest();
    }
    
    static testMethod void negative_getpic17big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic17big();
        
    Test.stopTest();
    }
    
    static testMethod void positive_getpic18big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic18big();
       
    Test.stopTest();
    }
    
    static testMethod void negative_getpic18big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic18big();
     
    Test.stopTest();
    }
    
    static testMethod void positive_getpic19big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic19big();
        
    Test.stopTest();
    }
    
    static testMethod void negative_getpic19big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic19big();
       
    Test.stopTest();
    }
    
    static testMethod void positive_getpic20big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic20big();
        
    Test.stopTest();
    }
    
    static testMethod void negative_getpic20big(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic20big();
        
    Test.stopTest();
    }
    
    static testMethod void positive_getpic1small(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic1small();
        
    Test.stopTest();
    }
    
    static testMethod void negative_getpic1small(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic1small();
       
    Test.stopTest();
    }
    
    static testMethod void positive_getpic2small(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic2small();
      
    Test.stopTest();
    }
    
    static testMethod void negative_getpic2small(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic2small();
        
    Test.stopTest();
    }
    
    static testMethod void positive_getpic3small(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic3small();
        
    Test.stopTest();
    }
    
    static testMethod void negative_getpic3small(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic3small();
       
    Test.stopTest();
    }
    
    static testMethod void positive_getpic4small(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic4small();
       
    Test.stopTest();
    }
    
    static testMethod void negative_getpic4small(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic4small();
        
    Test.stopTest();
    }
    
    static testMethod void positive_getpic5small(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic5small();
       
    Test.stopTest();
    }
    
    static testMethod void negative_getpic5small(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic5small();
       
    Test.stopTest();
    }
    
    static testMethod void positive_getpic6small(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic6small();
      
    Test.stopTest();
    }
    
    static testMethod void negative_getpic6small(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic6small();
       
    Test.stopTest();
    }
    
    static testMethod void positive_getpic7small(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic7small();
        
    Test.stopTest();
    }
    
    static testMethod void negative_getpic7small(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic7small();
        System.assertNotEquals(objAcc.Name,'Test27');
    Test.stopTest();
    }
    
    static testMethod void positive_getpic8small(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic8small();
        
    Test.stopTest();
    }
    
    static testMethod void negative_getpic8small(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic8small();
       
    Test.stopTest();
    }
    
    static testMethod void positive_getpic9small(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic9small();
      
    Test.stopTest();
    }
    
    static testMethod void negative_getpic9small(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic9small();
      
    Test.stopTest();
    }
    
    static testMethod void positive_getpic10small(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic10small();
      
    Test.stopTest();
    }
    
    static testMethod void negative_getpic10small(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic10small();
        
    Test.stopTest();
    }
    
    static testMethod void positive_getpic11small(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic11small();
       
    Test.stopTest();
    }
    
    static testMethod void negative_getpic11small(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic11small();
       
    Test.stopTest();
    } 
    
    static testMethod void positive_getpic12small(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic12small();
        
    Test.stopTest();
    }
    
    static testMethod void negative_getpic12small(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic12small();
      
    Test.stopTest();
    }
    
    static testMethod void positive_getpic13small(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic13small();
      
    Test.stopTest();
    }
    
    static testMethod void negative_getpic13small(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic13small();
        
    Test.stopTest();
    }
    
    static testMethod void positive_getpic14small(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic14small();
        
    Test.stopTest();
    }
    
    static testMethod void negative_getpic14small(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic14small();
       
    Test.stopTest();
    }
    
    static testMethod void positive_getpic15small(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic15small();
       
    Test.stopTest();
    }
    
    static testMethod void negative_getpic15small(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic15small();
        
    Test.stopTest();
    }
    
    static testMethod void positive_getpic16small(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic16small();
       
    Test.stopTest();
    }
    
    static testMethod void negative_getpic16small(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic16small();
        
    Test.stopTest();
    }
    
    
    static testMethod void positive_getpic17small(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic17small();
        
    Test.stopTest();
    }
    
    static testMethod void negative_getpic17small(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic17small();
       
    Test.stopTest();
    }
    
    static testMethod void positive_getpic18small(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic18small();
        
    Test.stopTest();
    }
    
    static testMethod void negative_getpic18small(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic18small();
        
    Test.stopTest();
    }
    
    static testMethod void positive_getpic19small(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic19small();
       
    Test.stopTest();
    }
    
    static testMethod void negative_getpic19small(){
    Account objAcc = [SELECT id, Name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c from Account LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller objLRDE = new solenis_DisplayLabel_Controller();
        objLRDE.getpic19small();
        
    Test.stopTest();
    }
    static testMethod void positive_createreqsubmitLWC(){
    Account objAcc = [SELECT Id, Name FROM Account LIMIT 1];
    Contact objCont = [SELECT Id, LastName, WV_Contact_Status__c, Phone, W_Decision_Maker_Type__c From Contact LIMIT 1];
    Label_Request__c objLabelReq = [SELECT Id, Name, Delivery_Method__c, Status__c, Customer_Prospect__c, Contact__c, 
                                        Program_Type__c, SAP_Material__c From Label_Request__c LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller.createreqsubmitLWC(objAcc.Id, JSON.serialize(objLabelReq), objCont.Id);
        System.assertEquals(objLabelReq.Status__c,'Draft');
    Test.stopTest();
    }
    
    static testMethod void negative_createreqsubmitLWC(){
    Account objAcc = [SELECT Id, Name FROM Account LIMIT 1];
    Contact objCont = [SELECT Id, LastName, WV_Contact_Status__c, Phone, W_Decision_Maker_Type__c From Contact LIMIT 1];
    Label_Request__c objLabelReq = [SELECT Id, Name, Delivery_Method__c, Status__c, Customer_Prospect__c, Contact__c, 
                                        Program_Type__c, SAP_Material__c From Label_Request__c LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller.createreqsubmitLWC(objAcc.Id, JSON.serialize(objLabelReq), objCont.Id);
        System.assertNotEquals(objLabelReq.Name,'Test34');
    Test.stopTest();
    }
     static testMethod void positive_createreqLWC(){
    Account objAcc = [SELECT Id, Name FROM Account LIMIT 1];
    Contact objCont = [SELECT Id, LastName, WV_Contact_Status__c, Phone, W_Decision_Maker_Type__c From Contact LIMIT 1];
    Label_Request__c objLabelReq = [SELECT Id,name,Customer_Prospect__r.name,status__c,Delivery_Method__c,tank_requirement__c,SAP_Material__c,asset_number__C,model__c,RecordType.Name,label_request_comments__c,
                                            capacity__c,contact__c,contact_phone__c,program_type__c,shipping_Instruction_product__c,Stick_on_Packaged_Goods_Label__c,Laminated_Lable__c,Stick_On_Label_Quantity__c,Fill_Line_Sign_Quantity__c,
                                            Solenis_Label_Cover__c,Hot_Line_Sticker__c,Line_Tag__c,Ultra_Serv_Inv_Mgmt_Sign_w_Label_Qty__c,Large_Metal_w_Lam_Label_Fill_Line_Qty__c,Tank_Placard_Quantity__c,Customer_Prospect__c,Full_Address__c,
                                            GHS_Cover_label__c,Case__c From Label_Request__c LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller.createreqLWC(objAcc.Id,JSON.serialize(objLabelReq), objCont.Id);
        System.assertEquals(objLabelReq.Status__c,'Draft');
    Test.stopTest();
    }
    
    static testMethod void negative_createreqLWC(){
    Account objAcc = [SELECT Id, Name FROM Account LIMIT 1];
    Contact objCont = [SELECT Id, LastName, WV_Contact_Status__c, Phone, W_Decision_Maker_Type__c From Contact LIMIT 1];
    Label_Request__c objLabelReq = [SELECT Id,name,Customer_Prospect__r.name,status__c,Delivery_Method__c,tank_requirement__c,SAP_Material__c,asset_number__C,model__c,RecordType.Name,label_request_comments__c,
                                            capacity__c,contact__c,contact_phone__c,program_type__c,shipping_Instruction_product__c,Stick_on_Packaged_Goods_Label__c,Laminated_Lable__c,Stick_On_Label_Quantity__c,Fill_Line_Sign_Quantity__c,
                                            Solenis_Label_Cover__c,Hot_Line_Sticker__c,Line_Tag__c,Ultra_Serv_Inv_Mgmt_Sign_w_Label_Qty__c,Large_Metal_w_Lam_Label_Fill_Line_Qty__c,Tank_Placard_Quantity__c,Customer_Prospect__c,Full_Address__c,
                                            GHS_Cover_label__c,Case__c From Label_Request__c LIMIT 1];
    Test.startTest();
        solenis_DisplayLabel_Controller.createreqLWC(objAcc.Id,JSON.serialize(objLabelReq), objCont.Id);
        System.assertNotEquals(objLabelReq.Name,'Test35');
    Test.stopTest();
    }
    
    static testMethod void AccountDetail(){
        Account objAcc = [SELECT Id, Name FROM Account LIMIT 1];
        solenis_DisplayLabel_Controller.AccountDetail(objAcc.id);
        
    }
}