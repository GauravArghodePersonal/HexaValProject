public class scrollingtipcontroller {

public list<Salesforce_tip__c> tips;
public Salesforce_tip__c returntip{get; set;}


public scrollingtipcontroller(){

    returntip = new salesforce_tip__c();
    tips = [select  Number_of_views__c, Number_Of_Clicks__c, link_text__c, link__c, tip_description__c, business__c from salesforce_tip__c where active__c = true limit 1000];
    
}
    public void aqtip() { 
    
    list<salesforce_tip__c> aqtips = new list<salesforce_tip__c>();
    for(salesforce_tip__c tip:tips){
        if(tip.business__c == 'Aqualon' ||
            tip.business__c == 'All'){
            aqtips.add(tip);
            
        }
    }

    double d = math.random();
    d = d * aqtips.size();
    
    if(aqtips.size() == 0){
    returntip.tip_description__c = 'No tips are active.';}
    else{
    returntip = aqtips[d.intvalue()];
    }
    countview();
    }
    
    public void pmtip() { 
    
    list<salesforce_tip__c> pmtips = new list<salesforce_tip__c>();
    for(salesforce_tip__c tip:tips){
        if(tip.business__c == 'Performance Materials' ||
            tip.business__c == 'All'){
            pmtips.add(tip);
            
        }
    }

    double d = math.random();
    d = d * pmtips.size();
    
    if(pmtips.size() == 0){
    returntip.tip_description__c = 'No tips are active.';}
    else{
    returntip = pmtips[d.intvalue()];}  
    countview();
    }
    
    public void adtip() { 
    
    list<salesforce_tip__c> adtips = new list<salesforce_tip__c>();
    for(salesforce_tip__c tip:tips){
        if(tip.business__c == 'Distribution' ||
            tip.business__c == 'All'){
            adtips.add(tip);
            
        }
    }

    double d = math.random();
    d = d * adtips.size();
    
    if(adtips.size() == 0){
    returntip.tip_description__c = 'No tips are active.';}
    else{
    
    returntip = adtips[d.intvalue()];}
    countview();
    }
    
    public void vtip() { 
    
    list<salesforce_tip__c> vtips = new list<salesforce_tip__c>();
    for(salesforce_tip__c tip:tips){
        if(tip.business__c == 'Valvoline' ||
            tip.business__c == 'All'){
            vtips.add(tip);
            
        }
    }

    double d = math.random();
    d = d * vtips.size();
    
    if(vtips.size() == 0){
    returntip.tip_description__c = 'No tips are active.';}
    else{

    returntip = vtips[d.intvalue()];}
    countview();
    }
    
    public void wtip() { 
    
    list<salesforce_tip__c> wtips = new list<salesforce_tip__c>();
    for(salesforce_tip__c tip:tips){
        if(tip.business__c == 'Water' ||
            tip.business__c == 'All'){
            wtips.add(tip);
            
        }
    }

    double d = math.random();
    d = d * wtips.size();
    
    if(wtips.size() == 0){
    returntip.tip_description__c = 'No tips are active.';}
    else{
    
    returntip = wtips[d.intvalue()];}
    countview();
    }
    
    
    public void tip() { 
    
    double d = math.random();
    d = d * tips.size();
    
    if(tips.size() == 0){
    returntip.tip_description__c = 'No tips are active.';}
    else{
    
    returntip = tips[d.intvalue()];}
    countview();
    }
    
    public void countclick(){
    
    salesforce_tip__c t = new salesforce_tip__c();
    t = returntip;
    decimal i;
    if(t.Number_Of_Clicks__c == null) {i = 0;}
    else {
    i = t.Number_of_Clicks__c; }
    
    i++;
    t.Number_of_Clicks__c = i;
    
    update t;
    }
    
    public void countview(){
    
    salesforce_tip__c t = new salesforce_tip__c();
    t = returntip;
    decimal i;
    if(t.Number_Of_views__c == null) {i = 0;}
    else {
    i = t.Number_of_views__c; }
    
    i++;
    t.Number_of_views__c = i;
    
    update t;
    }
}