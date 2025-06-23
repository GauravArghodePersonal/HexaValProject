public class PriceBookViewController {
 
    private static final String ALL = 'All';
    private static final String BR = '<br/>';
    private static final String COMMA = ',';
    private static final String OBJECT_NAME = 'Price_Book__c';
    private static final Integer PAGE_SIZE = 200;
    private static final Integer MAX_ROWS = 10000;
    private static final String PB_SORG_EXTEND_PAGE = '/apex/PriceBookSalesOrgExtendPage';
    private static final String SHARING_URL = CustomSettings__c.getInstance().Sharing_URL__c;

    private static final String SELECT_QRY_1 = 'select Active__c, Bulk_Minimum_Order_Quantity__c, ' + 
        'CurrencyIsoCode, Id, GPPct__c, Material_Name__c, Material_Number__c, Material_Sales_Data2__c, ' +
        'Name,Material_Sales_Data2__r.PH1__c,Material_Sales_Data2__r.Ph2__c, PH5_Family_Code__c, PH6_Segment_Code__c, Plant_Notes__c, Price_Book__c, ' +
        'Sales_Org_Desc__c, Selling_UOM__c, Volume_UOM__c, (select ' +
            'CurrencyIsoCode, Floor_Price__c, Id, Maximum_Volume__c, Minimum_Volume__c, ' +
            'Name, Price_Book_Entry__c, Price_Book__c, Pricing_UOM__c, Selling_Price__c, ' +
            'Surcharge__c, Volume_UOM__c from Price_Book_Entries_Scaled_Pricing__r ' +
            'order by Minimum_Volume__c) ' + 
        'from Price_Book_Entry__c where Price_Book__c = :priceBookId ';

    public Boolean renderPbes {get; set;}
    
    private final Price_Book__c priceBook;
    public String priceBookId {get; set;} 
    public String families {get; set;}
    public String productLines {get; set;}
    public String regions {get; set;}
    public String salesOrgs {get; set;}
    public String customerGroups {get; set;}
    public String userLocale {get; set;}
    public String priceBookTabUrl {get; set;}

    public String productFmly {get; set;}
    public String productLine {get; set;}
    public List<SelectOption> pfmlySelOpts {get; private set;}
    public List<SelectOption> plineSelOpts {get; private set;}

    public Boolean renderDeletePriceBookButton {get; set;}
    public Boolean renderExpirePriceBookButton {get; set;}
    public Boolean renderExtendPriceBookButton {get; set;}
    public Boolean renderEditPriceBookButton {get; set;}
    public Boolean renderExpiredBy {get; set;}

    public Boolean renderPriceBookDetails {get; private set;}
    public Boolean renderApprovalHistory {get; private set;}
    public Boolean renderOwnerEditBlock {get; private set;}
    public Boolean sendOwnerChangeEmail {get; set;}
    
    public PageReference returnPage {get; set;}
    public PageReference priceBookTabPage {get; set;}

    public PaginationController pc {get; private set;}

    List<Price_Book_Family__c> pbfmlist;
    List<Price_Book_Product_Line__c> pbpllist;
    
    public Contact tempObject {get; set;}

    public PriceBookViewController(ApexPages.StandardController c) {
        userLocale = UserInfo.getLocale(); Id userId = UserInfo.getUserId();
        priceBookTabUrl = PriceBookFunctions.getPriceBookTabUrl();
        priceBookTabPage = new PageReference(priceBookTabUrl);
        priceBookId = ApexPages.currentPage().getParameters().get('id');
        List<Price_Book__c> pbs = PriceBookFunctions.getPriceBooks(priceBookId);
        if (pbs != null && !pbs.isEmpty()) {
            priceBook = pbs[0];
            UserRecordAccess ura = UserRecordAccess_Functions.getUserRecordAccess(userId, priceBook.Id);
            //renderEditPriceBookButton = (Schema_Services.isObjectCreatable(OBJECT_NAME));
            renderEditPriceBookButton = ura.HasEditAccess;
            renderDeletePriceBookButton = (Pricing_Security__c.getInstance().Allowed_to_Delete_Price_Book__c &&
                                           priceBook.Record_Status__c == 'Expired' && renderEditPriceBookButton);
            renderExpirePriceBookButton = (Pricing_Security__c.getInstance().Allowed_to_Expire_Price_Book__c &&
                                           priceBook.Record_Status__c != 'Expired' && renderEditPriceBookButton);
            renderExtendPriceBookButton = (Pricing_Security__c.getInstance().Allowed_to_Extend_Price_Book__c &&
                                           priceBook.Record_Status__c != 'Expired');
            renderExpiredBy = (priceBook.Record_Status__c == 'Expired');
            customerGroups = PriceBookCustGroupFunctions.getCustomerGroupString(priceBookId, BR);
            pbfmlist = PriceBookFamilyFunctions.getPriceBookFamilies(priceBookId);
            families = PriceBookFamilyFunctions.getFamilyString(pbfmlist, BR);
            setPfmlySelOpts();
            pbpllist = PriceBookProductLineFunctions.getPriceBookProductLines(priceBookId);
            productLines = PriceBookProductLineFunctions.getProductLineString(pbpllist, BR);
            setPlineSelOpts();
            regions = PriceBookRegionFunctions.getRegionString(priceBookId, BR);
            salesOrgs = PriceBookSalesOrgFunctions.getSalesOrgString(priceBookId, BR);
            renderPriceBookDetails = true; renderApprovalHistory = renderEditPriceBookButton; 
            renderOwnerEditBlock = false;
        }
        setStandardSetController();
    }
    
    private void setPfmlySelOpts() {
        productFmly = ALL;
        pfmlySelOpts = new List<SelectOption>();
        pfmlySelOpts.add(new SelectOption(ALL, '-- All --'));
        if (pbfmlist == null || pbfmlist.isEmpty()) {return;}
        for (Price_Book_Family__c f : pbfmlist) {
            pfmlySelOpts.add(new SelectOption(f.Family_Code__c, f.Family_Desc__c + ' - ' + f.Family_Code__c));
        }
    }
    
    private void setPlineSelOpts() {
        productLine = ALL;
        plineSelOpts = new List<SelectOption>();
        plineSelOpts.add(new SelectOption(ALL, '-- All --'));
        if (pbpllist == null || pbpllist.isEmpty()) {return;}
        for (Price_Book_Product_Line__c l : pbpllist) {
            plineSelOpts.add(new SelectOption(l.Product_Line_Code__c, l.Product_Line_Desc__c + ' - ' + l.Product_Line_Code__c));
        }
    }
    
    private void setStandardSetController() {
        Database.Querylocator ql = getQueryLocator();
        pc = new PaginationController(ql, PAGE_SIZE);
    }
    
    private Database.Querylocator getQueryLocator() {
        Database.Querylocator ql;
        Date currentDate = Date.today();
        String qry = SELECT_QRY_1;
        if (ALL != productFmly) {qry += ' and Material_Sales_Data2__r.PH1__c= :productFmly';}
        if (ALL != productLine) {qry += ' and Material_Sales_Data2__r.PH2__C= :productLine';}
        qry += ' order by Material_Name__c limit ' + MAX_ROWS;
        ql = Database.getQueryLocator(qry);
        return ql;
    }
    
    /* private Database.Querylocator getQueryLocator() {
        Database.Querylocator ql;
        Date currentDate = Date.today();
        String qry = SELECT_QRY_1;
        if (ALL != productFmly) {qry += ' and PH5_Family_Code__c = :productFmly';}
        if (ALL != productLine) {qry += ' and PH6_Segment_Code__c = :productLine';}
        qry += ' order by Material_Name__c limit ' + MAX_ROWS;
        ql = Database.getQueryLocator(qry);
        return ql;
    }*/
    
    public void changeProductFamily() {setStandardSetController();}

    public void changeProductLine() {setStandardSetController();}
    
    public List<Price_Book_Entry> getPriceBookEntries() {
        //List<Price_Book_Entry__c> pbes = (List<Price_Book_Entry__c>) ssc.getRecords();
        List<Price_Book_Entry__c> pbes = (List<Price_Book_Entry__c>) pc.getRecords();
        if (pbes == null || pbes.isEmpty()) {return null;}
        renderPbes = (pbes.size() > 0);
        Integer n = pc.recordFrom;
        List<Price_Book_Entry> pbelist = new List<Price_Book_Entry>();
        for (Price_Book_Entry__c p : pbes) {
            Price_Book_Entry pbe = new Price_Book_Entry(p, n++);
            pbelist.add(pbe);
        }
        if (pbelist.isEmpty()) {
            return null;
        }
        return pbelist;
    }

    public class Price_Book_Service {
        public Price_Book_Service__c priceBookService {get; set;}
        public Price_Book_Service(Price_Book_Service__c p) {
            priceBookService = p;
        }
    }
    
    public List<Price_Book_Service> getPriceBookServices() {
        String pbid = priceBook.Id;
        List<Price_Book_Service__c> pbss = PriceBookServiceFunctions.getPriceBookServices(pbid);
        if (pbss == null || pbss.isEmpty()) {
            return null;
        }
        List<Price_Book_Service> pbslist = new List<Price_Book_Service>();
        for (Price_Book_Service__c p : pbss) {
            Price_Book_Service pbs = new Price_Book_Service(p);
            pbslist.add(pbs);
        }
        if (pbslist.isEmpty()) {
            return null;
        }
        return pbslist;
    }
    
    public Boolean renderPBMaterialSection {
        get {return (priceBook != null && 
                     priceBook.Number_of_Materials_on_Price_Book__c > 0);}
    }
    
    public Boolean renderPBServiceSection {
        get {return (priceBook != null && 
                     priceBook.Number_of_Services__c > 0);}
    }
    
    public PageReference gotoPriceBookEditPage() {
        return Page.Price_Books_Edit_Existing_Price_Book;
    }

    public PageReference getPageRef(String url) {
        return new PageReference(url);
    }
    
    public PageReference gotoAddNewPage() {
        return null;
    }
    
    public PageReference deletePriceBook() {
        try {
            delete priceBook;
        } catch(Exception e) {}
        return priceBookTabPage;
    }
    
    public PageReference expirePriceBook() {
        try {
            priceBook.Active__c = false;
            priceBook.Current_State__c = 'Expired';
            priceBook.Record_Status__c = 'Expired';
            update priceBook;
        } catch(Exception e) {}
        return priceBookTabPage;
    }
    
    public PageReference extendPriceBook() {
        String s = PB_SORG_EXTEND_PAGE+'?pbId='+priceBook.Id+'&pbn='+priceBook.Name;
        PageReference pr = new PageReference(s);
        return pr;
    }
    
    public PageReference gotoChangeOwnerPage() {
        renderPriceBookDetails = false; renderApprovalHistory = false; 
        renderOwnerEditBlock = true; sendOwnerChangeEmail = false;
        tempObject = new Contact();
        tempObject.OwnerId = priceBook.OwnerId;
        return null;
    }
    
    public PageReference changeOwner() {
        ApexPages.Message msg;
        try {
            priceBook.OwnerId = tempObject.OwnerId;
            update priceBook;
            if (sendOwnerChangeEmail) {
                PriceBookListController.sendOwnerChangeEmail(priceBook, tempObject.OwnerId);
            }
            return gotoPriceBookTabPage();
        } catch(Exception e) {
            msg = new ApexPages.Message(
                      ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(msg);
        }
        return null;
    }
    
    public PageReference gotoPriceBookTabPage() {
        String s = PriceBookFunctions.getPriceBookTabUrl();
        PageReference pr = new PageReference(s);
        return pr;
    }

    public PageReference gotoSharingPage() {
        String s = SHARING_URL+priceBook.Id;
        PageReference pr = new PageReference(s);
        return pr;
    }
    
/*
 **********************************************************
 Test Methods are in PriceBookFunctions_Test class
 ********************************************************** 
 */    

}