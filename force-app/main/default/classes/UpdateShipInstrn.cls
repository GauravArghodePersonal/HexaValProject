public class UpdateShipInstrn
{
    private final Shipping_Instruction__c shipInstrn;
    
    public Shipping_Instruction__c sh;
       
    public UpdateShipInstrn(ApexPages.StandardController stdController) 
    {
        this.shipInstrn = (Shipping_Instruction__c) stdController.getRecord();
        
        sh = [Select Id, Name, Primary_Contact__c, Primary_Contact_Phone__c, Secondary_Contact__c, Secondary_Contact_Phone__c, Account__c, Address_Line_1__c, Address_Line_2__c, Address_Line_3__c, Address_Line_4__c, City__c, State__c, Postal_Code__c, Country__c, Customer_Prospect_Number__c, Status__c, RecordTypeId from Shipping_Instruction__c where Id =: shipInstrn.Id];

    }
    
    public PageReference updateAccCon()
    {
        
        String accNumber;
                        
        sh.Primary_Contact_Phone__c = [Select Id, Name, Phone from Contact where Id =: sh.Primary_Contact__c].Phone;
        
        if (sh.Secondary_Contact__c != null)
        {
            sh.Secondary_Contact_Phone__c = [Select Id, Name, Phone from Contact where Id =: sh.Secondary_Contact__c].Phone;
        }
                
        Account acc = [Select Id, Name, RecordTypeId, RecordType.Name, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_StreetSuppl3__c, SAP_City__c, SAP_State__c, SAP_Zip_Code__c, SAP_Country__c, SAP_Customer_Number__c, CIS_Prospect_Number__c, Type from Account where Id =: sh.Account__c];
        sh.Address_Line_1__c = acc.SAP_Street__c;
        sh.Address_Line_2__c = acc.SAP_StreetSuppl1__c;
        sh.Address_Line_3__c = acc.SAP_StreetSuppl2__c;
        sh.Address_Line_4__c = acc.SAP_StreetSuppl3__c;
        sh.City__c = acc.SAP_City__c;
        sh.State__c = acc.SAP_State__c;
        sh.Postal_Code__c = acc.SAP_Zip_Code__c;
        sh.Country__c = acc.SAP_Country__c;
        
        if(acc.RecordType.Name.indexOf('Customer')>-1)
        accNumber = acc.SAP_Customer_Number__c;
        else if(acc.RecordType.Name.indexOf('Prospect')>-1)
        accNumber = acc.CIS_Prospect_Number__c;
        else accNumber = acc.SAP_Customer_Number__c;
        
        sh.Customer_Prospect_Number__c = accNumber;
        update sh;
        return null;
    }
    
    public PageReference updateStatus()
    {
        //Map<String, Schema.RecordTypeInfo> rtMapByNameShipInstrn = Shipping_Instruction__c.sObjectType.getDescribe().getRecordTypeInfosByName();
        //Id shipInstrnRecordTypeId = rtMapByNameShipInstrn.get('Current').getRecordTypeId();
        Id shipInstrnRecordTypeId = RecordType_Functions.LookupRecordTypeId('Current', 'Shipping_Instruction__c');

        List<Shipping_Instruction_Product__c> prodsList = new List<Shipping_Instruction_Product__c>();
        
        for(Shipping_Instruction_Product__c prods : [Select Id, Name, Status__c from Shipping_Instruction_Product__c where Shipping_Instruction__c =: shipInstrn.Id])
        {
            prods.Status__c = 'Current';
            prodsList.add(prods);
            
            if(prodsList.size()>1000)
            {
                update prodsList;
                prodsList.clear();
            }
        }
        
        update prodsList;
        
        sh.Status__c = 'Current';
        sh.RecordTypeId = shipInstrnRecordTypeId;
        update sh;
        
        return null;
    }
    
    public String getFormattedDate()
    {
        Date today = Date.today();
        
        Integer day = today.day();
        Integer month = today.month();
        Integer year = today.year();
        String formattedDate = month + '/' + day + '/' + year;
        
        return formattedDate;
    }
    
    public Shipping_Instruction_Product__c[] getShipInsProd()
    {
        List<String> recordTypeNameList = new List<String>{'Pro-Serv', 'Bulk (3rd-Party)', 'Bulk (Regular)', 'Ultra-Serv', 'Packaged Goods', 'Packaged Goods (3rd-Party)'};
                            
        Shipping_Instruction_Product__c[] shipInsProd = [Select Id, Name, Account__c, Additional_Product_Delivery_Information__c, Additional_Program_Delivery_Information__c, Any_low_narrow_clearances__c, CIS_Materials__r.Name, CIS_Materials__r.Material_Number__c, Desc_spcl_labels_codes_on_BOL_pckg_list__c, Desc_special_labels_codes_on_containers__c, Desc_special_labels_codes_on_the_invoice__c, Describe_any_low_narrow_clearances__c, DREW_weight_ticket_required__c, Fill_line_connection_size__c, Fill_line_fitting__c, Forklift_on_site__c, Hose_length_size_required__c, Is_hydraulic_liftgate_delivery_required__c, Multiple_drops_of_the_same_product_req_d__c, On_site_scaling_required__c, Other_safety_equipment__c, Palletizing_required__c, Program__c, Req_driver_personal_protect_safety_equip__c, Safety_shower_eyewash_w_in_75_of_del__c, Shipping_Instruction__c, Special_labels_codes_on_BOL_pckg_list__c, Special_labels_codes_on_containers__c, Special_labels_codes_on_the_invoice__c,  Status__c, Stretch_wrapping_required__c, Trailer_type__c, Transfer_method__c, RecordTypeId, RecordType.Name from Shipping_Instruction_Product__c where Shipping_Instruction__c =: sh.Id AND RecordType.Name IN: recordTypeNameList];
                       
        return shipInsProd;        
    }
                  
}