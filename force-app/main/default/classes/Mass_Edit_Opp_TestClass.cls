@isTest
private class Mass_Edit_Opp_TestClass
{
    static testMethod void Mass_Edit_Opp_TestMethod() 
    {
        Test.startTest();
        Account acct= new Account(Name='TestAccount');
        insert acct;
        
        List<Opportunity>  testOppty = new List<Opportunity>();
        Map<Id, List<Opportunity>> recTypeOppMap = new Map<Id, List<Opportunity>>();
         
        Map<String, String> rtmap = Schema_Functions.getRecordTypeNameMap('Opportunity');
        for(String rtid : rtmap.values())
        {
            for(integer i = 0 ; i < 1 ; i++) {
                testOppty.add(new Opportunity(Name = 'testing' + i, StageName = 'Prospecting', CloseDate  = System.today() + 7, 
                                            AccountId = acct.Id, RecordTypeId  = rtid));                
            }
            break;
        }                
        
        insert testOppty; 
        
        List<Id> opptyIds = new List<Id>();
        
        for(Opportunity thisOpportunity : testOppty)
        {
            opptyIds.add(thisOpportunity.Id);            
        }
            
        List<Opportunity> myopty = [SELECT name,closedate, RecordType.Name FROM Opportunity where Id IN : opptyIds];
        for(Opportunity o : myopty)
        {
            if(recTypeOppMap.containsKey(o.RecordTypeId))
            {
                recTypeOppMap.get(o.RecordTypeId).add(o);
            }
            else
            {
                recTypeOppMap.put(o.RecordTypeId, new List<Opportunity>{o});
            }
        }           
        
        for(List<Opportunity> theseOpportunities : recTypeOppMap.values())
        {
            ApexPages.StandardSetController setopty = new ApexPages.StandardSetController(theseOpportunities);
            Mass_Edit_Opp masseditopptest = new Mass_Edit_Opp(setopty);
            
            setopty.setSelected(theseOpportunities);
            Mass_Edit_Opp masseditopptest1 = new Mass_Edit_Opp(setopty);
            
            if(masseditopptest1.isRenderSalesPriority != null && masseditopptest1.isRenderSalesPriority)
            {
                try{List<SelectOption> tempSalesPrrties = masseditopptest1.getSalesPriority();}catch(Exception e){System.debug(e.getMessage());}
            }
            if(masseditopptest1.isRenderAshlandSupplier != null && masseditopptest1.isRenderAshlandSupplier)
            {
                try{List<SelectOption> tempAshSup = masseditopptest1.getAshSupplier();}catch(Exception e){System.debug(e.getMessage());}
            }
            if(masseditopptest1.isRenderReasonWonLost != null && masseditopptest1.isRenderReasonWonLost)
            {
                try{List<SelectOption> tempRsnWonLst = masseditopptest1.getReasonWonLost();}catch(Exception e){System.debug(e.getMessage());}
            }
            if(masseditopptest1.isRenderCustomerMarket != null && masseditopptest1.isRenderCustomerMarket)
            {
                try{List<SelectOption>  tempCustMar = masseditopptest1.getCustomerMarket();}catch(Exception e){System.debug(e.getMessage());}
            }
            if(masseditopptest1.isRenderProductFamily != null && masseditopptest1.isRenderProductFamily)
            {
                try{List<SelectOption> tempProdFmly = masseditopptest1.getProductFamily();}catch(Exception e){System.debug(e.getMessage());}
            }
            if(masseditopptest1.isRenderSubFamily != null && masseditopptest1.isRenderSubFamily)
            {
                try{List<SelectOption> tempProdFmly1 = masseditopptest1.getProductSubFamily1();}catch(Exception e){System.debug(e.getMessage());}
                try{List<SelectOption> tempProdFmly2 = masseditopptest1.getProductSubFamily2();}catch(Exception e){System.debug(e.getMessage());}
                try{List<SelectOption> tempProdFmly3 = masseditopptest1.getProductSubFamily3();}catch(Exception e){System.debug(e.getMessage());}
                try{List<SelectOption> tempProdFmly4 = masseditopptest1.getProductSubFamily4();}catch(Exception e){System.debug(e.getMessage());}
            }
            
        }
        
        myopty = recTypeOppMap.values()[0];
        
        ApexPages.StandardSetController setopty = new ApexPages.StandardSetController(myopty);
        Mass_Edit_Opp masseditopptest = new Mass_Edit_Opp(setopty);
        
        setopty.setSelected(myopty);
        Mass_Edit_Opp masseditopptest1 = new Mass_Edit_Opp(setopty);
        
        try{List<SelectOption> tempStageOps = masseditopptest1.getStage();}catch(Exception e){System.debug(e.getMessage());}
        try{List<SelectOption> tempPrmryWnLst = masseditopptest1.getPrimaryWonLost();}catch(Exception e){System.debug(e.getMessage());}
        try{List<SelectOption> tempSecondaryWonLost = masseditopptest1.getSecondaryWonLost();}catch(Exception e){System.debug(e.getMessage());}
        
        masseditopptest1.saveUrl = '/006/o';
        
        List<Mass_Edit_Opp_WrapperClass> tempMEOWCList = masseditopptest1.getPaginationObjList();
        PageReference next = masseditopptest1.goNext();
        PageReference previous = masseditopptest1.goPrevious();
        Boolean tempnxt = masseditopptest1.getIsNext();
        Boolean tempprvs = masseditopptest1.getIsPrevious();
        PageReference first = masseditopptest1.goFirst();
        PageReference last = masseditopptest1.goLast();
        Integer ttlPgNum = masseditopptest1.getTotalPageNo();
        PageReference stgOnChng = masseditopptest1.stageOnChange();
        PageReference svSlOps = masseditopptest1.saveSelOpps();
        masseditopptest1.getAshSupplier();
        masseditopptest1.getCustomerMarket();
        masseditopptest1.getPaginationObjList();
        masseditopptest1.getPrimaryWonLost();
        masseditopptest1.getProductFamily();
        masseditopptest1.getProductSubFamily1();
        masseditopptest1.getProductSubFamily2();
        masseditopptest1.getProductSubFamily3();
        masseditopptest1.getProductSubFamily4();
        masseditopptest1.getReasonWonLost();
        masseditopptest1.getSalesPriority();
        masseditopptest1.getSecondaryWonLost();
        masseditopptest1.getStage();
        
        Mass_Edit_Opp_WrapperClass tempobj = tempMEOWCList[0];

        tempobj.setSelectedStage(tempobj.getSelectedStage());
        tempobj.setSelectedSalesPriority(tempobj.getSelectedSalesPriority());
        tempobj.setSelectedReasonWonLost(tempobj.getSelectedReasonWonLost());
        tempobj.setSelectedCustomerMarket(tempobj.getSelectedCustomerMarket());       
        tempobj.setSelectedProductFamily(tempobj.getSelectedProductFamily());       
        tempobj.setSelectedProductSubFamily(tempobj.getSelectedProductSubFamily());
        tempobj.setSelectedPrimaryWonLost(tempobj.getSelectedPrimaryWonLost());
        tempobj.setSelectedSecondaryWonLost(tempobj.getSelectedSecondaryWonLost());
        tempobj.setSelectedAshSupplier(tempobj.getSelectedAshSupplier());
        Test.stopTest();
    }
}