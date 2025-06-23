public with sharing class AdvancedDataTableRecord {
    public sObject rec {get;set;}
    
    public AdvancedDataTableRecord(sObject rec) {
        this.rec = rec;
    }
}