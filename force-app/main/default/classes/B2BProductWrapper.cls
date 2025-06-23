public class B2BProductWrapper
{
    @AuraEnabled public String productId;
    @AuraEnabled public String productName;
    @AuraEnabled public String productCode;
    @AuraEnabled public String productImageURL;
    @AuraEnabled public String productCurrency;
    @AuraEnabled public String productPrice;
    @AuraEnabled public Boolean addedCart;
    @AuraEnabled public Integer quantity;
    @AuraEnabled public String uom;
     @AuraEnabled public String oldMaterialNo;
    
    public B2BProductWrapper(String productId,
                             String productName,
                             String productCode,
                             String productImageURL,
                             String productCurrency,
                             String productPrice,
                             String uom,
                             Boolean addedCart,
                            String oldMaterialNo)
    {
        this.productId = productId;
        this.productName = productName;
        this.productCode = productCode;
        this.productImageURL = productImageURL;
        this.productCurrency = productCurrency;
        this.productPrice = productPrice;
        this.addedCart = addedCart;
        this.uom = uom;
        this.quantity = 1;
        this.oldMaterialNo=oldMaterialNo;
    }
}