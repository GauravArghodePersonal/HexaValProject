public class SalesOrderRequestJson {
    public SalesOrderRequestJson(){}
	public String PI_CONVERT_PARVW_AUART;
    public String PI_LANGUAGE_KEY;
    public String PI_SDFC_REFNUM;
    
    public List<PI_ORDER_HEADER_IN> PI_ORDER_HEADER_IN;
    public class PI_ORDER_HEADER_IN{
        public String COLLECT_NO;
        public String DATE_TYPE;
        public String DISTR_CHAN;
        public String DIVISION;
        public String DLV_BLOCK;
        public String DOC_TYPE;
        public String NAME;
        public String PO_METHOD;
        public String PO_SUPPLEM;
        public String PURCH_DATE;
        public String PURCH_NO;
        public String REQ_DATE_H;
        public String SALES_ORG;
    }
    
    public List<PT_ORDER_ITEMS_IN> PT_ORDER_ITEMS_IN;
    public class PT_ORDER_ITEMS_IN{
        public String COND_TYPE;
        public String CURRENCY_CODE;
        public String CUST_MAT;
        public String ITM_NUMBER;
        public String MATERIAL;
        public String PO_ITM_NO;
        public String REQ_DATE;
        public String REQ_QTY;
        public String SALES_UNIT;
        public String ITEM_CATEG;
        public String PLANT;
    }
    
    public List<PT_ORDER_PARTNERS> PT_ORDER_PARTNERS;
    public class PT_ORDER_PARTNERS{
        public String PARTN_NUMB;
        public String PARTN_ROLE;
    }
    
    public List<PT_ECOM_ORDER_COMMENTS> PT_ECOM_ORDER_COMMENTS;
    public class PT_ECOM_ORDER_COMMENTS{
        public String TEXT_LINE;
    }
    
    public static SalesOrderRequestJson parse(String json){
        return (SalesOrderRequestJson) System.JSON.deserialize(json, SalesOrderRequestJson.class);
    }
}