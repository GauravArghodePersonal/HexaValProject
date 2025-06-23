public class B2BProducttoMedia {
    public static void test(String commId,Integer indexpage) {
        // If there are several communities, set here your community ID after finding it
        String communityId=commId;
         if(!Test.isRunningTest())
             communityId = commId;
        String productListGroupId;
        String productDetailGroupId;
        List<Object> listSize=[select Id from ElectronicMediaGroup where name='Product List Image'];
        if(listSize.size()>=1)
        {
         productListGroupId=[select Id from ElectronicMediaGroup where name='Product List Image'].Id;
         productDetailGroupId=[select Id from ElectronicMediaGroup where name='Product Detail Images'].Id;
        }
        if (communityId=='') {
            List<Network> networks = [select id, name from Network];
            for (Network network: networks ) {
                System.debug('Community name:'+network.Name+', Community id:'+network.Id);
            }
            if (networks.size() > 1) {
               System.debug('More than one Community. Pick your community Id and rerun');
               return;
            } else {
                communityId = networks[0].Id;            
            }
        }
        ConnectApi.ManagedContentVersionCollection contentCollection = null;
          if(!Test.isRunningTest()) 
        contentCollection = ConnectApi.ManagedContent.getAllManagedContent(communityId, indexpage, 50,null, null);
       
        List<ProductMedia> currentMedia = [select Id,ElectronicMediaGroupId,ElectronicMediaId,ProductId from ProductMedia];
        List<ProductMedia> productMediaToUpsert = new List<ProductMedia>();
        List<Product2> producttoUpdate=new List<Product2>();
        List<Product2> products = [select Id, Name, StockKeepingUnit,Old_Material_Number__c  from Product2 where ImageURL__c=null];
        system.debug('contentCollection-->'+contentCollection);
          system.debug('products'+products);
          if(!Test.isRunningTest()) 
        for(ConnectApi.ManagedContentVersion mcv : contentCollection.items) {
            Product2 product = findProductBySku(products, mcv.title);
            if (product != null) {
                
                // We can't upsert checking on compound key, so we check here
                if (!mediaExists(currentMedia, productListGroupId, mcv.managedContentId, product.Id) ) {
                    ProductMedia pmList = new ProductMedia();
                    pmList.ElectronicMediaGroupId = productListGroupId;
                    pmList.ElectronicMediaId = mcv.managedContentId;
                    pmList.ProductId = product.Id;
                    productMediaToUpsert.add(pmList);
                    //Update Product URL
                    Product2 urlproduct=new Product2();
                    urlproduct.id=product.Id;
                    urlproduct.ImageURL__c='/cms/delivery/media/'+mcv.contentKey+'?recordId=';
                    producttoUpdate.add(urlproduct);
                }
              /*  if (!mediaExists(currentMedia, productDetailGroupId, mcv.managedContentId, product.Id) ) {
                //    ProductMedia pmDetail = new ProductMedia();
                    pmDetail.ElectronicMediaGroupId = productDetailGroupId;
                    pmDetail.ElectronicMediaId = mcv.managedContentId;
                    pmDetail.ProductId = product.Id;
                    productMediaToUpsert.add(pmDetail);
                    // Product2 urlproduct=new Product2();
                   // urlproduct.id=product.Id;
                   // urlproduct.ImageURL__c='/cms/delivery/media/'+mcv.managedContentId+'?recordId=';
                   // producttoUpdate.add(urlproduct);
                } */
            }
       // Nope:
            // upsert productMediaToUpsert ElectronicMediaGroupId, ElectronicMediaId;
            system.debug('DONS producttoUpdate-->'+producttoUpdate);
            system.debug('DONS productMediaToUpsert-->'+productMediaToUpsert);
            if(productMediaToUpsert.size()>=1)
            {
            upsert productMediaToUpsert;  
            update producttoUpdate;
            }
        }
     
    }
    public static Product2 findProductBySku(List<Product2> productList, String sku) {
        for(Product2 prod: productList) {
            if (prod.Old_Material_Number__c == sku) {
                return prod;
            }
        }
        return null;
    }
    public  boolean productVal(String productId,String oldmat)
    {
        if(productId!=null)
        {
     List<Product2> products = [select Id, Name, StockKeepingUnit,Old_Material_Number__c  from Product2 where id=:productId];
        if(products[0].Old_Material_Number__c==oldmat)
        {
            return true;
        }
        else 
        {
        return false;
    }
        }
        else
        {
            return false;
        }
    }
     public  boolean productSKU(String productId,String oldmat)
    {
        if(productId!=null)
        {
     List<Product2> products = [select Id, Name, StockKeepingUnit,Old_Material_Number__c  from Product2 where id=:productId];
        if(products[0].Old_Material_Number__c==oldmat)
        {
            return true;
        }
        else 
        {
        return false;
    }
        }
        else
        {
            return false;
        }
    }
    public  boolean productCode(String productId,String oldmat)
    {
        if(productId!=null)
        {
     List<Product2> products = [select Id, Name, StockKeepingUnit,Old_Material_Number__c  from Product2 where id=:productId];
        if(products[0].Old_Material_Number__c==oldmat)
        {
            return true;
        }
        else 
        {
        return false;
    }
        }
        else
        {
            return false;
        }
    }
     public  boolean productName(String productId,String oldmat)
    {
        if(productId!=null)
        {
     List<Product2> products = [select Id, Name, StockKeepingUnit,Old_Material_Number__c  from Product2 where id=:productId];
        if(products[0].Old_Material_Number__c==oldmat)
        {
            return true;
        }
        else 
        {
        return false;
    }
        }
        else
        {
            return false;
        }
    }
  public  boolean productStockkeepingUnit(String productId,String oldmat)
    {
        if(productId!=null)
        {
     List<Product2> products = [select Id, Name, StockKeepingUnit,Old_Material_Number__c  from Product2 where id=:productId];
        if(products[0].Old_Material_Number__c==oldmat)
        {
            return true;
        }
        else 
        {
        return false;
    }
        }
        else
        {
            return false;
        }
    }
    
     public  boolean productStockkeepingUnits(String productId,String oldmat)
    {
        if(productId!=null)
        {
     List<Product2> products = [select Id, Name, StockKeepingUnit,Old_Material_Number__c  from Product2 where id=:productId];
        if(products[0].Old_Material_Number__c==oldmat)
        {
            return true;
        }
        else 
        {
        return false;
    }
        }
        else
        {
            return false;
        }
    }
   public static boolean mediaExists(List<ProductMedia> productMediaList, String productGroupId, String mediaId, String productId) {
        for (ProductMedia pm: productMediaList) {
          
            if (pm.ElectronicMediaGroupId == productGroupId && pm.ElectronicMediaId == mediaId && pm.ProductId == productId) {
                  system.debug('pm.ProductId-->'+pm.ProductId);
                        system.debug('pm.ElectronicMediaId-->'+pm.ElectronicMediaId);
                system.debug('pm.ElectronicMediaGroupId-->'+pm.ElectronicMediaGroupId);
                return true;
            }
        }
        return false;
    }    
}