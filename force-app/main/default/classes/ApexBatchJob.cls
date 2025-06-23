public with sharing class ApexBatchJob {
    private final static Set<String> COMPLETE_STATUS = new Set<String>{
        'Aborted', 'Completed', 'Failed' 
    };

    @AuraEnabled
    public DateTime CreatedDate { get; set; }
    @AuraEnabled
    public DateTime CompletedDate { get; set; }
    @AuraEnabled
    public Decimal Percent { get; set; }
    @AuraEnabled
    public Integer TotalRecords { get; set; }
    @AuraEnabled
    public Integer NumberOfErrors { get; set; }
    @AuraEnabled
    public Integer RecordsProcessed  { get; set; }
    @AuraEnabled
    public String Name { get; set; }
    @AuraEnabled
    public String Status { get; set; }
    @AuraEnabled
    public String ClassId { get; set; }
    @AuraEnabled
    public String JobType { get; set; }
    @AuraEnabled
    public String ClassName { get; set; }
    @AuraEnabled
    public String CreatedBy { get; set; }
    @AuraEnabled
    public String MethodName { get; set; }

    public ApexBatchJob() {

    }
    
    public ApexBatchJob(AsyncApexJob asyncApexJob) {
        this.ClassId = asyncApexJob.ApexClassId;
        this.ClassName = asyncApexJob.ApexClass.Name;
        this.CompletedDate = asyncApexJob.CompletedDate;
        this.CreatedBy = asyncApexJob.CreatedBy.Name;
        this.CreatedDate = asyncApexJob.CreatedDate;
        this.JobType = asyncApexJob.JobType;
        this.MethodName = asyncApexJob.MethodName;
        this.Name = asyncApexJob.Id;
        this.NumberOfErrors = asyncApexJob.NumberOfErrors;
        this.RecordsProcessed = asyncApexJob.JobItemsProcessed;
        this.Status = asyncApexJob.Status;
        this.TotalRecords = asyncApexJob.TotalJobItems;

        setPercent();
    }

    private void setPercent() {
        if (this.RecordsProcessed > 0 && this.TotalRecords > 0) {
            Decimal calculatedPercentage = this.RecordsProcessed;
            this.Percent = (calculatedPercentage.Divide(this.TotalRecords, 2)).intValue();
            return;
        }

        this.Percent = (this.Status == 'Completed') ? 100 : 1;
        return;
    }
    
    @AuraEnabled
    public Boolean GetIsJobCompleted() {
        return COMPLETE_STATUS.contains(this.Status);
    }

    @AuraEnabled
    public String GetFormattedCreatedDate() {
        return this.CreatedDate.format();
    }

    @AuraEnabled
    public String GetFormattedCompletedDate() {
        try {
            return this.CompletedDate.format();
        } catch (Exception e) {
            return '';
        }
    }

    @AuraEnabled
    public String GetEstimatedCompletionDateTime() {
        String result = '';
        
        DateTime currentDateTime = datetime.now();
        
        Decimal percentageComplete = 1;
        Decimal decimalRecordsCompleted = Decimal.valueOf(this.RecordsProcessed);

        if (this.TotalRecords != 0) {
            decimalRecordsCompleted = decimalRecordsCompleted.Divide(
                    Decimal.valueOf(this.TotalRecords), 6
                );
        }

        if (this.TotalRecords != 0) {
            percentageComplete = decimalRecordsCompleted;
        }

        if (percentageComplete != 0) {
            Long dateDifference = System.now().getTime() - this.CreatedDate.getTime();
            Decimal minutesLeft = 0;
            DateTime completionDateTime = System.now();
            Integer minutesLeftValue = minutesLeft.intValue();
            
            minutesLeft = ((dateDifference/percentageComplete) - dateDifference)/(1000*60);
            completionDateTime = completionDateTime.addMinutes(minutesLeftValue);

            result = minutesLeftValue + ' minutes left. ';

            if (minutesLeftValue > 60) {
                Integer hoursLeftValue = minutesLeftValue / 60;
                minutesLeftValue -= hoursLeftValue * 60;

                result = hoursLeftValue + ' hour(s)' +  minutesLeftValue + ' minute(s) left.';
            }


            result += ' ' + completionDateTime.format();
        }

        return result;
    }
}