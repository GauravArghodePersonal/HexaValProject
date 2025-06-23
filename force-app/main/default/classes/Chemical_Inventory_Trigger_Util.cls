public with sharing class Chemical_Inventory_Trigger_Util {

    private static Set<Id> updatedAsSibling;
    public static Boolean executedFromInventoryTrigger;

    static {
        System.debug('--->Init static context');
        updatedAsSibling = new Set<Id>();
        executedFromInventoryTrigger = false;
    }

    private static List<Chemical_Inventory__c> getNonRecursiveInventories(List<Chemical_Inventory__c> newInventories) {
        System.debug('---> getNonRecursiveInventories');
        System.debug(updatedAsSibling);
        List<Chemical_Inventory__c> inventoriesSaveToWork = new List<Chemical_Inventory__c>();

        for (Chemical_Inventory__c inventory : newInventories) {
            if(!updatedAsSibling.contains(inventory.Id)) {
                inventoriesSaveToWork.add(inventory);
            }
        }

        return inventoriesSaveToWork;
    }

    //Method to verify that incoming Inventory doesn´t have the same Inventory Date as another sibiling Inventory
    public static void checkInventoryDate(List<Chemical_Inventory__c> newInventories){
        List<Chemical_Inventory__c> inventories = Trigger.isUpdate ? getNonRecursiveInventories(newInventories) : newInventories;
        if(inventories.isEmpty()) { return; }

        System.debug('---> 1 : ' + (Trigger.isInsert ? 'INSERT' : 'UPDATE'));

        Set<Id> chemContainersIds = new Set<Id>();

        for(Chemical_Inventory__c inventory : inventories){
            chemContainersIds.add(inventory.Chemical_Container__c);
        }

        //Get Chemical Containers and its childs(By most recent date).
        List<Chemical_Container__c> parentChemContainers = getParentChemicalContainers(chemContainersIds);

        //Get inventories of each Chemical Container
        Map<Id, List<Chemical_Inventory__c>> inventoriesByContainer = getInventoriesByContainerId(parentChemContainers);

        //Check that incoming inventory doesn´t have the same Inventory Date than other sibiling Inventory
        checkInventoriesDate(inventories, inventoriesByContainer);
    }

    //Method to calculate Consumption field for the Inventory
    public static void calculateConsumption(List<Chemical_Inventory__c> newInventories){
        List<Chemical_Inventory__c> inventories = Trigger.isUpdate ? getNonRecursiveInventories(newInventories) : newInventories;
        if(inventories.isEmpty()) { return; }

        System.debug('---> 2 : '  + (Trigger.isInsert ? 'INSERT': 'UPDATE'));

		Set<Id> chemContainIds = new Set<Id>();

        for(Chemical_Inventory__c inventory : inventories){
            chemContainIds.add(inventory.Chemical_Container__c);
        }

        //Get Chemical Containers and its childs(By most recent date).
        List<Chemical_Container__c> parentChemContain = getParentChemicalContainers(chemContainIds);

        //Get inventories of each Chemical Container
        Map<Id, List<Chemical_Inventory__c>> inventByContainer = getInventoriesByContainerId(parentChemContain);

        //Do calculations to get Consumption
        getConsumption(inventories, inventByContainer);
    }

    //Method to set values for Total Inventory, Total Usage, Inventory Date, Duration Days and Runout Days for Chemical Container
    public static void setChemicalContainerCalculations(List<Chemical_Inventory__c> newInventories){
        System.debug('--> Trigger.new size: ' + newInventories.size());
        List<Chemical_Inventory__c> inventories = Trigger.isUpdate ? getNonRecursiveInventories(newInventories) : newInventories;
        if(inventories.isEmpty()) { return; }

        System.debug('---> 3 : '  + (Trigger.isInsert ? 'INSERT': 'UPDATE'));

        Set<Id> containersIds = new Set<Id>();

        for(Chemical_Inventory__c inventory : inventories) {
            containersIds.add(inventory.Chemical_Container__c);
        }

        //Get Chemical Containers and its childs(By most recent date).
        List<Chemical_Container__c> parentChemicalContainers = getParentChemicalContainers(containersIds);

        //Get inventories of each Chemical Container that are less than 45 days apart from the most recent one
        Map<Id, List<Chemical_Inventory__c>> inventoriesWithLessThan45Days = getListOfChildInventories(parentChemicalContainers);

        //Do calculations to get desire values
        doCalculations(parentChemicalContainers, inventoriesWithLessThan45Days);
    }

    //Method to make sure the consumption of a recent sibling Inventory is done when inserting an inventory in the middle
    public static void updateFirstYoungerSiblingConsumption(List<Chemical_Inventory__c> newInventories){
        List<Chemical_Inventory__c> inventories = Trigger.isUpdate ? getNonRecursiveInventories(newInventories) : newInventories;
        if(inventories.isEmpty()) { return; }

        System.debug('---> 4 : '  + (Trigger.isInsert ? 'INSERT': 'UPDATE'));

        Set<Id> parentContainIds = new Set<Id>();

        for(Chemical_Inventory__c inventory : inventories){
            parentContainIds.add(inventory.Chemical_Container__c);
        }

        //Get Chemical Containers and its childs(By most recent date).
        List<Chemical_Container__c> listOfChemContainers = getParentChemicalContainers(parentContainIds);

        //Get all inventories of each Chemical container
        Map<Id, List<Chemical_Inventory__c>> inventoriesOfEachChemCont = getInventoriesByContainerId(listOfChemContainers);

        //Do the update of the needed inventories
        doUpdateOfInventories(inventories, inventoriesOfEachChemCont);
    }

    //Method to update parent Chemical Containers after an Inventory is deleted
    public static void updateChemicalContainer(List<Chemical_Inventory__c> Inventories){
        Set<Id> containIds = new Set<Id>();

        for(Chemical_Inventory__c inventory : Inventories){
            containIds.add(inventory.Chemical_Container__c);
        }

        //Get Chemical Containers and its childs(By most recent date).
        List<Chemical_Container__c> listChemicalContain = getParentChemicalContainers(containIds);

        //Get inventories of each Chemical Container
        Map<Id, List<Chemical_Inventory__c>> inventByChemContain = getInventoriesByContainerId(listChemicalContain);

        updateInventoryToGetCalcultations(Inventories, inventByChemContain);
    }

	//*************************************************************************************************************************************************************************//

    private static List<Chemical_Container__c> getParentChemicalContainers(Set<Id> containersIds){
        //Get fields needed and the inventories of each Chemical Container order by the most recent inventory
        List<Chemical_Container__c> parentContainers = new List<Chemical_Container__c>([
                SELECT Id, Total_Inventory__c, Tank_Heel__c, (
                        SELECT Id, Inventory_Date__c, Total_Inventory__c, Deliveries__c
                        FROM Chemical_Inventories__r
                        ORDER BY Inventory_Date__c DESC
                )
                FROM Chemical_Container__c
                WHERE Id IN :containersIds
        ]);

        return parentContainers;
    }

    private static Map<Id, List<Chemical_Inventory__c>> getInventoriesByContainerId(List<Chemical_Container__c> parentContain){
        //Map the inventories each Chemical Container has by the Id of the Container
        Map<Id, List<Chemical_Inventory__c>> inventByContainersIds = new Map<Id, List<Chemical_Inventory__c>>();

        for(Chemical_Container__c containers : parentContain) {
			List<Chemical_Inventory__c> childInven = containers.Chemical_Inventories__r;

            inventByContainersIds.put(containers.Id, childInven);
        }

        return inventByContainersIds;
    }

    private static void checkInventoriesDate(List<Chemical_Inventory__c> incomingIn, Map<Id, List<Chemical_Inventory__c>> inventoriesByContainer){
        //Check if any sibiling Inventory has the same Inventory date and if TRUE then show error to user
        for(Chemical_Inventory__c inven : incomingIn) {

            List<Chemical_Inventory__c> invenToCheck = inventoriesByContainer.get(inven.Chemical_Container__c);

            if(invenToCheck == null || invenToCheck.isEmpty()) {
                continue;
            }

            for(Chemical_Inventory__c inv : invenToCheck) {
                if(inven.Inventory_Date__c == inv.Inventory_Date__c) {
                    if (inven.Id == null || inven.Id != inv.Id) {
                        inven.addError('Inventory_Date__c', 'There can´t be two inventories with the same Inventory Date');
                    }
                }
            }
        }
    }

    private static Map<Id, List<Chemical_Inventory__c>> getListOfChildInventories(List<Chemical_Container__c> parentContainers){
        //Map the inventories each Chemical Container has
        Map<Id, List<Chemical_Inventory__c>> inventoriesByContainersIds = new Map<Id, List<Chemical_Inventory__c>>();

        for(Chemical_Container__c container : parentContainers) {
			List<Chemical_Inventory__c> childInventories = container.Chemical_Inventories__r;

            //From the list, get the inventories that are less than 45 days apart from the most recent inventory
            List<Chemical_Inventory__c> inventWithLessThan45Days = getInventoriesWithLessThan45Days(childInventories);

            inventoriesByContainersIds.put(container.Id, inventWithLessThan45Days);
        }

        return inventoriesByContainersIds;
    }

    private static List<Chemical_Inventory__c> getInventoriesWithLessThan45Days(List<Chemical_Inventory__c> childChemInven){
        //Get date of most recent Inventory for reference
        Date mostRecentInventory = childChemInven[0].Inventory_Date__c;

        List<Chemical_Inventory__c> childInventWithLessThan45Days = new List<Chemical_Inventory__c>();

        //Compare each inventory date with the most recent one and if its less than 45 days apart then save it.
        for(Chemical_Inventory__c inven : childChemInven){
            Date invenDate = inven.Inventory_Date__c;
            Integer numOfDays = invenDate.daysBetween(mostRecentInventory);
            if(numOfDays <= 45){
                childInventWithLessThan45Days.add(inven);
            }
        }

        return childInventWithLessThan45Days;
    }

    private static void getConsumption(List<Chemical_Inventory__c> newInventories, Map<Id, List<Chemical_Inventory__c>> inventByContain){

        //Iterate through the trigger.new incoming Inventories
        for(Chemical_Inventory__c newInven : newInventories){
            Date dateOfIncomingInventory = newInven.Inventory_Date__c;

            //List of sibilings Inventories the incoming Inventory has
            List<Chemical_Inventory__c> inventoriesToCheck = inventByContain.get(newInven.Chemical_Container__c);

            if(inventoriesToCheck == null || inventoriesToCheck.isEmpty()) {
                newInven.Consumption__c = 0;
                continue;
            }

            //List to save the Inventories that have an Inventory_Date__c before the one inserting or updating
            List<Chemical_Inventory__c> listOfPreviousInventories = new List<Chemical_Inventory__c>();

            //Calculate which sibiling Inventories were created before the incoming Inventory
            for(Chemical_Inventory__c checkInven : inventoriesToCheck){
                Date dateOfInventoryToCheck = checkInven.Inventory_Date__c;
                Integer daysApart = dateOfInventoryToCheck.daysBetween(dateOfIncomingInventory);

                //If daysApart is positive it means the sibiling Inventory has a previous date than the incoming one
                if(daysApart > 0){
                    listOfPreviousInventories.add(checkInven);
                }
            }

            //If there is at least one sibiling Inventory with a previous date then calculate Consumption with the nearest one
            if(!listOfPreviousInventories.isEmpty()){
                Decimal inventoryConsumption;
                Decimal previousTotalInventory = listOfPreviousInventories[0].Total_Inventory__c;

                if(newInven.Deliveries__c != null) {
                    inventoryConsumption = previousTotalInventory + newInven.Deliveries__c - newInven.Total_Inventory__c;
                } else {
                    inventoryConsumption = previousTotalInventory - newInven.Total_Inventory__c;
                }

                newInven.Consumption__c = inventoryConsumption;
            }
        }
    }

    private static void doCalculations(List<Chemical_Container__c> parentContainers, Map<Id, List<Chemical_Inventory__c>> inventoriesByContainer){
        //List to update all the Chemical Containers and its fields
        Map<Id, Chemical_Container__c> updateChemicalContainers = new Map<Id, Chemical_Container__c>();

        for(Chemical_Container__c chemContainer : parentContainers){
            List<Chemical_Inventory__c> inventoryList = inventoriesByContainer.get(chemContainer.Id);

            if(inventoryList == null || inventoryList.isEmpty()) {
                continue;
            }

            //Update Total Inventory field of the Container with total inventory of the most recent Inventory
            chemContainer.Total_Inventory__c = inventoryList[0].Total_Inventory__c;

            //Get Inventory_Date__c of most recent inventory
            Date firstChildDate = inventoryList[0].Inventory_Date__c;

            //Get Inventory_Date__c of last inventory
            Integer indexOfLastElement = inventoryList.size() - 1;
            Date lastChildDate = inventoryList[indexOfLastElement].Inventory_Date__c;

            //Update Duration Days field value of the Container with the difference of days between the first and last inventory
            Integer durationDays = lastChildDate.daysBetween(firstChildDate);
            chemContainer.Duration_Days__c = durationDays;

            Double deliveries = getDeliveries(inventoryList);

            //Calculate Total Usage (Total Usage = Previous Inventory + Total Deliveries - Total Inventory) and update field in Container
            Double totalUsage = inventoryList[indexOfLastElement].Total_Inventory__c + deliveries - inventoryList[0].Total_Inventory__c;
            chemContainer.Total_Usage_Including_Deliveries__c = totalUsage;

            //Calculte Usage Rate (Usage Rate = Total Usage / Duration Days) and update field in Container
            Double usageRate = durationDays != 0 ? totalUsage / durationDays : 0;
            chemContainer.Usage_Rate__c = usageRate;

            //Calculate Estimated Run out days
            Double runOutDays = usageRate != 0 ? (inventoryList[0].Total_Inventory__c - chemContainer.Tank_Heel__c) / usageRate : 0;
            chemContainer.Estimated_Runout_Days__c = runOutDays;

            //Calculate the Runout Date (RunoutDate = Most Recent Inventory Date + Runout Days)
			Date runOutDate = runOutDays != 0 ? firstChildDate + runOutDays.intValue() : Date.today();
            chemContainer.Runout_Date__c = runOutDate;

            updateChemicalContainers.put(chemContainer.Id, chemContainer);
        }


        //Update all changes on Chemical Containers fields
        if(!updateChemicalContainers.isEmpty()) {
            System.debug('---> Executing UPDATE DML SIZE: ' + updateChemicalContainers.size());
            executedFromInventoryTrigger = true;
            update updateChemicalContainers.values();
        }

    }

    private static Double getDeliveries(List<Chemical_Inventory__c> inventoriesDeli){
        //Get total deliveries between the first and last inventory
        Double totDeliveries = 0;
        //Flag to avoid adding the Deliveries of the last Inventory
        Integer flag = 0;

        for(Chemical_Inventory__c deliInven : inventoriesDeli){
            if(deliInven.Deliveries__c != null && flag < inventoriesDeli.size() - 1){
                totDeliveries += deliInven.Deliveries__c;
                //totDeliveries = totDeliveries + deliInven.Deliveries__c;
            }
            flag++;
        }

        return totDeliveries;
    }

    private static void doUpdateOfInventories(List<Chemical_Inventory__c> updateInven, Map<Id, List<Chemical_Inventory__c>> invenOfCont){
        List<Chemical_Inventory__c> youngerSiblingToUpdate = new List<Chemical_Inventory__c>();

        for(Chemical_Inventory__c upInven : updateInven){
            //Get sibling inventories of the incoming inventory, including the records of the Trigger.new
            List<Chemical_Inventory__c> siblingInventories = invenOfCont.get(upInven.Chemical_Container__c);

            if(siblingInventories == null || siblingInventories.isEmpty()) {
                continue;
            }

            Date dateOfIncomingInven = upInven.Inventory_Date__c;

            //List to save the Inventories that are more recent than the one incoming
            List<Chemical_Inventory__c> recentInven = new List<Chemical_Inventory__c>();

            //Calculate which sibling Inventories were created recently than the incoming Inventory
            for(Chemical_Inventory__c sibIn : siblingInventories){
                Date dateOfSibInven = sibIn.Inventory_Date__c;
                Integer daysDifference = dateOfSibInven.daysBetween(dateOfIncomingInven);

                //If daysDifference is negative it means the sibiling Inventory has a more recent date than the incoming one
                if(daysDifference < 0){
                    recentInven.add(sibIn);
                }
            }

            //If there is at least one more recent sibiling Inventory, then calculate the consumption of the one closest to the incoming and add it to the list to update
            if(!recentInven.isEmpty()){
                Integer lastIndex = recentInven.size() - 1;
                Chemical_Inventory__c previousRecentSibling = recentInven[lastIndex];
                Double updateConsump;

                if(previousRecentSibling.Deliveries__c != null){
                    updateConsump = upInven.Total_Inventory__c + previousRecentSibling.Deliveries__c - previousRecentSibling.Total_Inventory__c;
                } else {
                    updateConsump = upInven.Total_Inventory__c - previousRecentSibling.Total_Inventory__c;
                }

                previousRecentSibling.Consumption__c = updateConsump;
                youngerSiblingToUpdate.add(previousRecentSibling);
            }
        }

        if(!youngerSiblingToUpdate.isEmpty()) {
            for (Chemical_Inventory__c inventory : youngerSiblingToUpdate) {
                updatedAsSibling.add(inventory.Id);
            }
            System.debug('right before the udate dml, size: ' + youngerSiblingToUpdate.size());
            update youngerSiblingToUpdate;
        }
    }

    private static void updateInventoryToGetCalcultations(List<Chemical_Inventory__c> incomingInventories, Map<Id, List<Chemical_Inventory__c>> inventorByContainer){
        List<Chemical_Inventory__c> updateListInven = new List<Chemical_Inventory__c>();

        for(Chemical_Inventory__c incomingIn : incomingInventories){
            List<Chemical_Inventory__c> listInven = inventorByContainer.get(incomingIn.Chemical_Container__c);

            if(listInven != null && !listInven.isEmpty()) {
                updateListInven.addAll(listInven);
            }
        }

        update updateListInven;
    }
}