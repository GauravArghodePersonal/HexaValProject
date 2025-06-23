public class UpdateReqTraffServ
{
    private final Request_for_Traffic_Service__c reqTraffServ;
    
    public Request_for_Traffic_Service__c rts;
    
    public UpdateReqTraffServ(ApexPages.StandardController stdController)
    {
        this.reqTraffServ = (Request_for_Traffic_Service__c) stdController.getRecord();
        
        rts = [Select Id, Name, Ship_From_Account__c, Ship_From_Address_Line_1__c, Ship_From_Address_Line_2__c, Ship_From_Address_Line_3__c, Ship_From_Address_Line_4__c, Ship_From_City__c, Ship_From_State__c, Ship_From_Postal_Code__c, Ship_From_Country__c, Ship_From_Account_Number__c, Ship_From_Contact__c, Ship_From_Contact_Phone__c, Ship_To_Account__c, Ship_To_Address_Line_1__c, Ship_To_Address_Line_2__c, Ship_To_Address_Line_3__c, Ship_To_Address_Line_4__c, Ship_To_City__c, Ship_To_State__c, Ship_To_Zip__c, Ship_To_Customer_Number__c, Ship_To_Contact__c, Ship_To_Contact_Phone__c, Request_for_Traffic_Service_Carrier__c, Carrier_Ship_To_Address__c, Carrier_Ship_To_City__c, Carrier_Ship_To_State__c, Carrier_Ship_To_Zip__c, Carrier_Ship_To_Contact_Name__c, Carrier_Ship_To_Contact_Phone__c, Carrier_Ship_To_Vendor_Number__c from Request_for_Traffic_Service__c where Id =: reqTraffServ.Id];
    }
    
    public PageReference updateAllInfo()
    {
        String shipFromAccNumber;
        
        Account shipFromAcc = [Select Id, Name, RecordTypeId, RecordType.Name, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_StreetSuppl3__c, SAP_City__c, SAP_State__c, SAP_Zip_Code__c, SAP_Country__c, SAP_Customer_Number__c, CIS_Prospect_Number__c, Type from Account where Id =: rts.Ship_From_Account__c];
        rts.Ship_From_Address_Line_1__c = shipFromAcc.SAP_Street__c;
        rts.Ship_From_Address_Line_2__c = shipFromAcc.SAP_StreetSuppl1__c;
        rts.Ship_From_Address_Line_3__c = shipFromAcc.SAP_StreetSuppl2__c;
        rts.Ship_From_Address_Line_4__c = shipFromAcc.SAP_StreetSuppl3__c;
        rts.Ship_From_City__c = shipFromAcc.SAP_City__c;
        rts.Ship_From_State__c = shipFromAcc.SAP_State__c;
        rts.Ship_From_Postal_Code__c = shipFromAcc.SAP_Zip_Code__c;
        rts.Ship_From_Country__c = shipFromAcc.SAP_Country__c;
        
        if(shipFromAcc.RecordType.Name.indexOf('Customer')>-1)
        shipFromAccNumber = shipFromAcc.SAP_Customer_Number__c;
        else if(shipFromAcc.RecordType.Name.indexOf('Prospect')>-1)
        shipFromAccNumber = shipFromAcc.CIS_Prospect_Number__c;
        else shipFromAccNumber = shipFromAcc.SAP_Customer_Number__c;
        
        rts.Ship_From_Account_Number__c = shipFromAccNumber;
        
        rts.Ship_From_Contact_Phone__c = [Select Id, Name, Phone from Contact where Id =: rts.Ship_From_Contact__c].Phone;
        
        String shipToAccNumber;
        
        if(rts.Ship_To_Account__c != null)
        {
            Account shipToAcc = [Select Id, Name, RecordTypeId, RecordType.Name, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_StreetSuppl3__c, SAP_City__c, SAP_State__c, SAP_Zip_Code__c, SAP_Country__c, SAP_Customer_Number__c, CIS_Prospect_Number__c, Type from Account where Id =: rts.Ship_To_Account__c];
            rts.Ship_To_Address_Line_1__c = shipToAcc.SAP_Street__c;
            rts.Ship_To_Address_Line_2__c = shipToAcc.SAP_StreetSuppl1__c;
            rts.Ship_To_Address_Line_3__c = shipToAcc.SAP_StreetSuppl2__c;
            rts.Ship_To_Address_Line_4__c = shipToAcc.SAP_StreetSuppl3__c;
            rts.Ship_To_City__c = shipToAcc.SAP_City__c;
            rts.Ship_To_State__c = shipToAcc.SAP_State__c;
            rts.Ship_To_Zip__c = shipToAcc.SAP_Zip_Code__c;
                
            if(shipToAcc.RecordType.Name.indexOf('Customer')>-1)
            shipToAccNumber = shipToAcc.SAP_Customer_Number__c;
            else if(shipToAcc.RecordType.Name.indexOf('Prospect')>-1)
            shipToAccNumber = shipToAcc.CIS_Prospect_Number__c;
            else shipToAccNumber = shipToAcc.SAP_Customer_Number__c;
        
            rts.Ship_To_Customer_Number__c = shipToAccNumber;
        }
        
        if(rts.Ship_To_Contact__c != null)
        {
            rts.Ship_To_Contact_Phone__c = [Select Id, Name, Phone from Contact where Id =: rts.Ship_To_Contact__c].Phone;
        }
        
        if(rts.Request_for_Traffic_Service_Carrier__c != null)
        {
            Request_for_Traffic_Service_Carrier__c reqTraffServCar = [Select Id, Name, Address__c, City__c, Contact_First_Name__c, Contact_Last_Name__c, Contact_Phone_Number__c, Postal_Code__c, State__c, Vendor_Number__c from Request_for_Traffic_Service_Carrier__c where Id =: rts.Request_for_Traffic_Service_Carrier__c];
            rts.Carrier_Ship_To_Address__c = reqTraffServCar.Address__c;
            rts.Carrier_Ship_To_City__c = reqTraffServCar.City__c;
            rts.Carrier_Ship_To_State__c = reqTraffServCar.State__c;
            rts.Carrier_Ship_To_Zip__c = reqTraffServCar.Postal_Code__c;
            rts.Carrier_Ship_To_Contact_Name__c = reqTraffServCar.Contact_First_Name__c + reqTraffServCar.Contact_Last_Name__c;
            rts.Carrier_Ship_To_Contact_Phone__c = reqTraffServCar.Contact_Phone_Number__c;
            rts.Carrier_Ship_To_Vendor_Number__c = reqTraffServCar.Vendor_Number__c;
        }
        
        update rts;
        return null;
        
    }
    
    public PageReference updateStatus()
    {
        //Map<String, Schema.RecordTypeInfo> rtMapByNameReqTraffServ = Request_for_Traffic_Service__c.sObjectType.getDescribe().getRecordTypeInfosByName();
        //Id reqTraffServRecordTypeId = rtMapByNameReqTraffServ.get('Carrier Notified').getRecordTypeId();
        Id reqTraffServRecordTypeId = RecordType_Functions.LookupRecordTypeId('Carrier Notified', 'Request_for_Traffic_Service__c');
        
        rts.Status__c = 'Carrier Notified';
        rts.RecordTypeId = reqTraffServRecordTypeId;
        
        update rts;
        return null;

    }
}