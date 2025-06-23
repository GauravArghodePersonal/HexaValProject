@isTest
private class CustomInputField_Test{
   public static testmethod void CustomInputFieldMethod(){ 
     CustomInputField cu = new CustomInputField();
     cu.getValue(); 
     cu.setValue('test'); 
     cu.getError(); 
     cu.setError('err'); 
     cu.getShowError(); 
     cu.getStyle();
     }
  }