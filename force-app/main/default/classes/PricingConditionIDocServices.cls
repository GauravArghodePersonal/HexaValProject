global class PricingConditionIDocServices {

    webservice static List<String> getUpdatedIDocs(Integer batchSize) {
        List<String> idocs;
        PricingConditionIDocFunctions.updateIDocs();
        idocs = PricingConditionIDocFunctions.getUpdatedIDocs(batchSize);
        return idocs;
    }

    webservice static void setExportStatus(List<String> idocIds, Integer batchSize) {
        PricingConditionIDocFunctions.setExportStatus(idocIds, batchSize);
    }
    
}