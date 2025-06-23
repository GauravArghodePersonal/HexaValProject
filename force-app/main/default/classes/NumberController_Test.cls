@isTest
public class NumberController_Test{
    @isTest static void NumberControllermethod (){
       NumberClass num = new NumberClass ();
       Boolean blankZero = null;
       Integer decimals = 1;
       String locale = null;  
       Boolean required = true;   
       Boolean rendered = true;  
       Integer size = 10;      
       String style = 'style';    
       String styleClass = 'style class';
       Decimal value = 1.1;   
       NumberController controller = new NumberController();
       controller.getNumClass();
       controller.setNumClass(num);
       System.assertEquals(blankZero,null);
       System.assertEquals(decimals,1);
       System.assertEquals(locale,null);
       System.assertEquals(required,true);
       System.assertEquals(rendered,true);
       System.assertEquals(size,10);
       System.assertEquals(style,'style');
       System.assertEquals(styleClass,'style class');
       System.assertEquals(value,1.1);
       }
 }