public with sharing class VIPromotionMaterial {

    public String  material          {get; set;}
    public Double  quantity          {get; set;}
    public Boolean selected          {get; set;}
    public String  warehouseSKU      {get; set;}
    
    public VIPromotionMaterial(String mat, String sku) {
        material = mat; warehouseSKU = sku;
        init();
    }
    
    private void init() {
        selected = false; quantity = 0.0;
    }

}