public class workorderlineitemtask
{
    public  static void checkWOLI(List<WorkOrderLineItem > newwoli)
    {    
        List<WorkOrderLineItem> insertWOLI = new List<WorkOrderLineItem>();
        //String sBreak = '</br></br>';
        String sBreak ='\n';
        String contact = '';
        for(WorkOrderLineItem w :newwoli)
        {
            if(w.Region__c == 'NA'){
                contact = 'Wade Ballantyne';   
            }
            //WorkOrderLineItem w=[select WorkOrder.id,Tank_properly_grounded_flame_arresters__c,Fill_line_tag_visible_during_delivery__c,Does_the_tank_have_a_fill_line_installed__c,Any_defects_to_the_containment_area__c,Customer_Prospect__c,id,Is_there_any_evidence_of_tank_bulging__c,Any_discoloration_of_the_tank_exterior__c,Any_defects_with_tank_hose_assembly__c,Are_there_any_leaks_to_the_tank_piping__c,Is_a_level_gauge_installed_on_the_tank__c,If_Yes_has_Cust_registered_with_State__c,Does_Manway_Cover_include_Safe_Surge_Lid__c,Is_HMIS_sign_product_label_visible__c,Any_cracks_dents_spider_cracks_to_tank__c,Has_tank_insulation_been_compromised__c,Is_the_tank_stand_deteriorating__c,Does_heat_trace_thermostat_operate__c,Is_vent_in_place_and_checked__c,Vent_Size__c,Vent_Size_Picklist__c from WorkOrderLineItem where id=:wo.id];
            id wid=w.WorkOrder.id;
            system.debug('&&& Is_there_any_evidence_of_tank_bulging__c'+ w.Is_there_any_evidence_of_tank_bulging__c );
            system.debug('&&& Any_discoloration_of_the_tank_exterior__c'+ w.Any_discoloration_of_the_tank_exterior__c );
            System.debug('w.Vent_Size__c'+w.Vent_Size__c);
            
            if( w.Is_there_any_evidence_of_tank_bulging__c  =='Yes')
            { 
                String des=  'Action Required: Tank needs all leaks repaired immediately for Account '+w.Customer_Prospect__c+'.' +sBreak + 'Corrective Action: Contact '+contact+' to discuss the tank bulging solution.';
                insertWOLI.add(createWOLI(des ,30,wid,1));
            }
            if(w.Any_discoloration_of_the_tank_exterior__c=='Yes')
            {
                String des=  ' Action Required:Contact '+contact+' to discuss defects of the containment basin at Account '+w.Customer_Prospect__c+'.'+ sBreak +'Corrective Action: Contact '+contact+' to discuss situation. ';
                insertWOLI.add(createWOLI(des ,30,wid,2)); 
            }
            if(w.Any_defects_to_the_containment_area__c=='Yes')
            {
                String des=  ' Action Required:Contact '+contact+' to discuss tank discoloration for Account '+w.Customer_Prospect__c+'.'+sBreak +'Corrective Action: Contact '+contact+' to discuss defects of the containment basin.';
                insertWOLI.add(createWOLI(des ,30,wid,3)); 
            }
            if(w.Does_the_tank_have_a_fill_line_installed__c=='No')
            {
                String des=  ' Action Required: contact '+contact+' to discuss fill line on tank at Account '+w.Customer_Prospect__c+'.'+sBreak+ 'Corrective Action: We recommend all tanks have fill lines, but please contact '+contact+' to discuss details around this tank situation.';
                insertWOLI.add(createWOLI(des ,30,wid,4)); 
            }  
            if(w.Fill_line_tag_visible_during_delivery__c=='No')
            {
                String des=  ' Action Required: Order new fill line tag on SFDC for Account  '+w.Customer_Prospect__c+'.'+ sBreak+ 'Corrective Action: Order new fill line tag on SFDC via Create Label Request. Upon receipt, post fill line tag where visible. ';
                insertWOLI.add(createWOLI(des ,30,wid,5)); 
            }   
            if(w.Tank_properly_grounded_flame_arresters__c=='Yes')
            {
                String des=  ' Action Required: Have tank properly grounded and flame arresters installed at Account  '+w.Customer_Prospect__c+'.'+ sBreak + 'Corrective Action: Please discuss with customer and have tank properly grounded and flame arresters installed.     ';
                insertWOLI.add(createWOLI(des ,30,wid,6)); 
            }  
            if(w.Any_defects_with_tank_hose_assembly__c=='Yes')
            {
                String des=  ' Action Required: Hose tank assembly must be replaced at Account '+w.Customer_Prospect__c+'.'+ sBreak + 'Corrective Action: Hose tank assembly must be replaced to avoid leaks and safety concerns.     ';
                insertWOLI.add(createWOLI(des ,30,wid,7)); 
            } 
            if(w.Are_there_any_leaks_to_the_tank_piping__c=='Yes')
            {
                String des=  ' Action Required: Tank needs to be relocated onto a concrete pad for Account '+w.Customer_Prospect__c+'.'+ sBreak + 'Corrective Action: All leaks must be repaired immediately.      ';
                insertWOLI.add(createWOLI(des ,30,wid,8)); 
            }  
            if(w.Is_a_level_gauge_installed_on_the_tank__c=='No')
            {
            system.debug('wid>>>>'+wid);
                String des=  ' Action Required: Level gauge needs to be replaced at Account '+w.Customer_Prospect__c+'.'+ sBreak + 'Corrective Action: Level gauge needs to be replaced.      ';
                insertWOLI.add(createWOLI(des ,30,wid,9)); 
            }
            if(w.If_Yes_has_Cust_registered_with_State__c=='No')
            {
                String des=  ' Action Required:Discuss tank registration with Customer at Account '+w.Customer_Prospect__c+'.' + sBreak + 'Corrective Action: Discuss tank registration with Customer. Customer is required to register tank with the State. ';
                insertWOLI.add(createWOLI(des ,30,wid,10)); 
            }
            if(w.Does_Manway_Cover_include_Safe_Surge_Lid__c=='No')
            {
                String des=  ' Action Required: No Safe Surge Lid at Account '+w.Customer_Prospect__c+'.'+sBreak + 'Corrective Action:       ';
                insertWOLI.add(createWOLI(des ,30,wid,11)); 
            }
            if(w.Is_HMIS_sign_product_label_visible__c=='No')
            {
                String des=  ' Action Required: Order new HMIS sign and product label on SFDC for Account '+w.Customer_Prospect__c+'.' + sBreak + 'Corrective Action: Order new HMIS sign and product label on SFDC via Create Label Request. Upon receipt, post signs where visible.      ';
                insertWOLI.add(createWOLI(des ,30,wid,12)); 
            }
            if(w.Any_cracks_dents_spider_cracks_to_tank__c=='Yes')
            {
                String des=  ' Action Required: A new tank must be ordered for Account '+w.Customer_Prospect__c+'.'+ sBreak + 'Corrective Action:Tanks with cracks/dents/spider cracks needs to be replaced - A new tank needs to be ordered ASAP. Discuss with Customer and contact '+contact+'. ';
                insertWOLI.add(createWOLI(des ,30,wid,13)); 
            }
            if(w.Has_tank_insulation_been_compromised__c=='Yes')
            {
                String des=  ' Action Required: Tank insulation needs to be replaced or repaired at Account '+w.Customer_Prospect__c+'.' + sBreak + 'Corrective Action:Tank insulation needs to be replaced or repaired.  ';
                insertWOLI.add(createWOLI(des ,30,wid,14)); 
            }
            if(w.Is_the_tank_stand_deteriorating__c=='Yes')
            {
                String des=  ' Action Required:Contact '+contact+' to discuss tank stand replacement for Account  '+w.Customer_Prospect__c+'.'+ sBreak + 'Corrective Action:Tank stand needs to be replaced. Contact '+contact+' to order stand replacement.  ';
                insertWOLI.add(createWOLI(des ,30,wid,15)); 
            }
            if(w.Does_heat_trace_thermostat_operate__c=='No')
            {
                String des=  ' Action Required:Heat trace thermostat needs to be replaced at Account  '+w.Customer_Prospect__c+'.' + sBreak  +'Corrective Action:Heat trace thermostat needs to be replaced.  ';
                insertWOLI.add(createWOLI(des ,30,wid,16)); 
            }
            if(w.Is_vent_in_place_and_checked__c=='No')
            {
                String des=  ' Action Required:Contact '+contact+' ASAP to discuss to how to vent tank at Account  '+w.Customer_Prospect__c+'.'+ sBreak  +'Corrective Action:ALL TANKS REQUIRE VENTILATION - You must contact '+contact+' ASAP to discuss to how to vent tank in present situation.   ';
                insertWOLI.add(createWOLI(des ,30,wid,17)); 
            }
            if(w.Vent_Size_Picklist__c=='5'||w.Vent_Size_Picklist__c=='4'||w.Vent_Size_Picklist__c=='3'||w.Vent_Size_Picklist__c=='2'||w.Vent_Size_Picklist__c=='1')
            {    
                System.debug('w.Vent_Size__c'+w.Vent_Size__c);
                String des=  ' Action Required: Vent Size: {!WorkOrderLineItem.Vent_Size__c} at  '+w.Customer_Prospect__c+'.' + sBreak + 'Corrective Action:All tanks require proper ventilation. Anything less than a 6" vent size requries that a safe surge manway Lid be ordered and installed.   ';
                insertWOLI.add(createWOLI(des ,30,wid,18)); 
            }
        }
        if(insertWOLI.size()>0 && !insertWOLI.isEmpty()){
            if(!Test.isRunningTest()){
            insert insertWOLI; 
            }
        }
    }
    
    public static WorkOrderLineItem createWOLI(String des,integer num,id wid,integer rkey ){
        WorkOrderLineItem w=new WorkOrderLineItem();
        set<string> reckey=new set<string>();
        List<WorkOrderLineItem> wo=new list<WorkOrderLineItem>();
        system.debug('&& Wid'+wid);
        wo= [select id,WorkOrder.id,RecordKey__c from WorkOrderLineItem where WorkOrder.id=:wid ];
        for (WorkOrderLineItem wl:wo)
        {
            system.debug(' &&& RecordKey__c '+ wl.RecordKey__c + wl.id);
            
            reckey.add(string.valueOf(wl.RecordKey__c));
            
            
        }
        system.debug(' &&& num '+ rkey);
        if(!reckey.contains(string.valueOf(rkey))){
            system.debug(' &&& inside num '+ rkey);
            
            Id devRecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Work Order Tank Task Line Item').getRecordTypeId();
            system.debug('&&& Record id'+devRecordTypeId    );
            
            List<WorkOrderLineItem> wolist=new list<WorkOrderLineItem>();
            //WorkOrderLineItem w=new WorkOrderLineItem();
            w.Description=des;
            w.WorkOrderId=wid;
            Date d = system.today();
            w.RecordKey__c=rkey;
            w.Due_Date__c=d.addDays(num);
            w.RecordTypeId=devRecordTypeId;
            /*wolist.add(w);
            if(wolist.size()>0)
            {
                insert wolist;
            }*/
        }
        return w;
    }
}