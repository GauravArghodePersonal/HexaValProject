@isTest
public class SalesOrderRequestJson_Test {
    @isTest
    public static void unitTest(){
        SalesOrderRequestJson controller = new SalesOrderRequestJson();
        String json ='{"PT_ORDER_PARTNERS":[{"PARTN_ROLE":"SH","PARTN_NUMB":"0000622300"},{"PARTN_ROLE":"SP","PARTN_NUMB":"0000622300"}],"PT_ORDER_ITEMS_IN":[{"SALES_UNIT":null,"REQ_QTY":"34","REQ_DATE":"2021-05-03","PO_ITM_NO":"1","PLANT":null,"MATERIAL":"000000000000418789","ITM_NUMBER":"102196","ITEM_CATEG":"ZTAN","CUST_MAT":"","CURRENCY_CODE":"USD","COND_TYPE":""}],"PT_ECOM_ORDER_COMMENTS":[{"TEXT_LINE":null}],"PI_SDFC_REFNUM":"ORD-092078","PI_ORDER_HEADER_IN":[{"SALES_ORG":"1020","REQ_DATE_H":"2021-05-03","PURCH_NO":"34","PURCH_DATE":"2021-04-28","PO_SUPPLEM":"ZSFC","PO_METHOD":"ZSFC","NAME":"Gokul Balaji","DOC_TYPE":"ZOR","DLV_BLOCK":"","DIVISION":"11","DISTR_CHAN":"10","DATE_TYPE":"1","COLLECT_NO":""}],"PI_LANGUAGE_KEY":"E","PI_CONVERT_PARVW_AUART":"X"}' ; 
		SalesOrderRequestJson.parse(json);
    }
}