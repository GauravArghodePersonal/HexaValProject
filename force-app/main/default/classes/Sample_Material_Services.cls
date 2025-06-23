global class Sample_Material_Services {
/*
    static final Integer MAX_RECS = 10;
    
    global class SampleMaterial {
        webservice String accountName;
        webservice String accountNumber;
        webservice String accountOwnerEmail;
        webservice String accountOwnerName;
        webservice String actualShipDate;
        webservice String businessUnit;
        webservice String carrierAccount;
        webservice String carrierName;
        webservice String deliveryDate;
        webservice String enteredByEmail;
        webservice String enteredByName;
        webservice String enteredDate;
        webservice String lotNumber;
        webservice String materialName;
        webservice String materialNumber;
        webservice String materialStatus;
        webservice String message;
        webservice String notes;
        webservice String recordId;
        webservice String recordStatus;
        webservice String requestStatus;
        webservice String sampleCenter;
        webservice String sampleMaterialId;
        webservice String sampleQuantity;
        webservice String sampleRequestId;
        webservice String sampleSize;
        webservice String sampleUOM;
        webservice String shipToAddress1;
        webservice String shipToAddress2;
        webservice String shipToAddress3;
        webservice String shipToCity;
        webservice String shipToCountry;
        webservice String shipToFirstName;
        webservice String shipToLastName;
        webservice String shipToPhone;
        webservice String shipToPostalCode;
        webservice String shipToStateProv;
        webservice String shipToTitle;
        webservice String specialSize;
        webservice String trackingNumber;
        webservice String vcpRating;

    	public SampleMaterial(Sample_Material_CMC__c m) {
            accountName       = m.Account_Name__c;
            accountNumber     = m.Account_Number__c;
            accountOwnerEmail = m.Account_Owner_Email__c;
            accountOwnerName  = m.Account_Owner_Name__c;
            actualShipDate    = getString(m.Actual_Ship_Date__c);
            businessUnit      = m.Business_Unit__c;
            carrierAccount    = m.Carrier_Account__c;
            carrierName       = m.Carrier_Name__c;
            deliveryDate      = getString(m.Delivery_Date__c);
            enteredByEmail    = m.EnteredBy_Email__c;
            enteredByName     = m.EnteredBy_Name__c;
            enteredDate       = getString(m.CreatedDate);
            lotNumber         = m.Lot_Number__c;
            materialName      = m.Material_Name__c;
            materialNumber    = m.Material_Number__c;
            materialStatus    = m.Material_Status__c;
            message           = '';
            notes             = m.Notes__c;
            recordId          = m.Id;
            recordStatus      = m.Record_Status__c;
            requestStatus     = m.Request_Status__c;
            sampleCenter      = m.Sample_Center__c;
            sampleMaterialId  = m.Sample_Material__c;
            sampleQuantity    = getString(m.Sample_Quantity__c);
            sampleRequestId   = m.Sample_Request__c;
            sampleSize        = getString(m.Sample_Size__c);
            sampleUOM         = m.Sample_UOM__c;
            shipToAddress1    = m.ShipTo_Address1__c;
            shipToAddress2    = m.ShipTo_Address2__c;
            shipToAddress3    = m.ShipTo_Address3__c;
            shipToCity        = m.ShipTo_City__c;
            shipToCountry     = m.ShipTo_Country__c;
            shipToFirstName   = m.ShipTo_FirstName__c;
            shipToLastName    = m.ShipTo_LastName__c;
            shipToPhone       = m.ShipTo_Phone__c;
            shipToPostalCode  = m.ShipTo_PostalCode__c;
            shipToStateProv   = m.ShipTo_StateProv__c;
            shipToTitle       = m.ShipTo_Title__c;
            specialSize       = m.Special_Size__c;
            trackingNumber    = m.Tracking_Number__c;
            vcpRating         = m.VCP_Rating__c;
    	}
    }
    
    public static final String SQRY1 = ''
        + 'select Id, Name, CreatedDate,'
        + '       Account_Name__c, Account_Number__c,'
        + '       Account_Owner_Email__c, Account_Owner_Name__c,'
        + '       Actual_Ship_Date__c, Business_Unit__c,'
        + '       Carrier_Account__c, Carrier_Name__c,'
        + '       Delivery_Date__c, EnteredBy_Email__c, EnteredBy_Name__c,'
        + '       Lot_Number__c, Material_Name__c, Material_Number__c,'
        + '       Material_Status__c, Notes__c, Record_Status__c,'
        + '       Request_Status__c, Sample_Center__c, Sample_Material__c,'
        + '       Sample_Quantity__c, Sample_Request__c, Sample_Size__c,'
        + '       Sample_UOM__c, ShipTo_Address1__c, ShipTo_Address2__c,'
        + '       ShipTo_Address3__c, ShipTo_City__c, ShipTo_Country__c,'
        + '       ShipTo_FirstName__c, ShipTo_LastName__c, ShipTo_Phone__c,'
        + '       ShipTo_PostalCode__c, ShipTo_StateProv__c, ShipTo_Title__c,'
        + '       Special_Size__c, Tracking_Number__c, VCP_Rating__c'
        + '  from Sample_Material_CMC__c ';
    
    webservice static List<SampleMaterial> getApprovedMaterials() {
    	return getSampleMaterials(null, null);
    }
    
    webservice static List<SampleMaterial> updateMaterials(List<SampleMaterial> materials) {
   		materials[0].message = 'Success'; materials[1].message = 'Error';
    	return materials;
    }
    
    private static String getString(Date d) {
    	return d != null ? d.format() : '';
    }
    
    private static String getString(DateTime t) {
        return t != null ? getString(t.date()) : '';
    }
    
    private static String getString(Decimal d) {
        return d != null ? d.toPlainString() : '';
    }
    
    public static List<SampleMaterial> getSampleMaterials(Set<String> recordStatusSet, 
                                                          Set<String> sampleCenterSet) {
    	List<SampleMaterial> alist = new List<SampleMaterial>(); SampleMaterial a;
    	String q = SQRY1 + ' limit ' + MAX_RECS;
    	List<Sample_Material_CMC__c> mlist = Database.query(q);
    	if (mlist == null || mlist.isEmpty()) {return alist;}
    	for (Sample_Material_CMC__c m : mlist) {
    		a = new SampleMaterial(m); alist.add(a);
    	}
    	return alist;
    }

    public static List<String> updateMaterialStatus(List<String> materialIds, 
                                                    String materialStatus) {
        return materialIds;
    }
*/    
}