public class LWRConstants {
    
    public static final String STATUS_NOT_SUBMITTED			 = 'Not Submitted';
    public static final String STATUS_PENDING_LAB_ACCEPTANCE = 'Pending Lab Acceptance';
    public static final String STATUS_WAITING_FOR_APPROVAL   = 'Waiting for Approval';
    public static final String STATUS_ACCEPTED_IN_PROGRESS   = 'Accepted/In Progress';
    public static final String STATUS_COMPLETED 			 = 'Completed';
    public static final String STATUS_CANCELLED              = 'Cancelled';
    public static final String STATUS_REJECTED               = 'Rejected';
    
    public static final Set<String> READ_ONLY_STATUS_GROUP = new Set<String>{STATUS_PENDING_LAB_ACCEPTANCE
                                                                            ,STATUS_WAITING_FOR_APPROVAL
        																	,STATUS_ACCEPTED_IN_PROGRESS
                                                                            ,STATUS_COMPLETED
                                                                            ,STATUS_CANCELLED
                                                                            };
    
   public static final Set<String> APPROVAL_SUBMISSION_STATUS_GROUP = new Set<String>{ STATUS_PENDING_LAB_ACCEPTANCE
                                                                           		      ,STATUS_WAITING_FOR_APPROVAL
                                                                                     };
                                                                                         
   public static final String LWR_SETTINGS_METADATA_NAME 	               = 'LWR_Setting__mdt';  
   public static final String PROFILES_CAN_EDIT_UNDER_APPROVAL_LWR         = 'Edit_Under_Approval_LWRs';  
   public static final String PROFILES_CAN_DELETE_FILES_UNDER_APPROVAL_LWR = 'Delete_Under_Approval_LWR_Files';
  
   public static final String PROFILE_NAME_SOLENIS_LWR_PLATFORM = 'Solenis LWR Platform';
    
   public static final String LAB_NAME_KREFELD_PAL_BD_M9 			= 'KTC - Krefeld Technical Center (PAL Bd. M9)';
   public static final String LAB_NAME_KREFELD_WAL_BD_F7 			= 'KTC - Krefeld Technical Center (WAL Bd. F7)';
   public static final String LAB_NAME_PAULINIA 					= 'PTC - Paulinia Technical Center';
   public static final String LAB_NAME_SHANGHAI 					= 'STC - Shanghai Technical Center';
   public static final String LAB_NAME_NA_PAPER_APPLICATIONS 		= 'NA Paper Applications Laboratory';
   public static final String LAB_NAME_NA_PAPER_TESTING 			= 'NA Paper Testing Laboratory';
   public static final String LAB_NAME_NA_PAPER_MAKING 				= 'NA Paper Making Laboratory';
   public static final String LAB_NAME_NA_CUSTOMER_ANALYTICAL 		= 'NA Customer Analytical Services';
   public static final String LAB_NAME_NA_WATER_APPLICATIONS 		= 'NA Water Applications Laboratory';
   public static final String LAB_NAME_NA_COLORANTS_APPLICATIONS 	= 'NA Colorants Applications Laboratory';
   public static final String LAB_NAME_ITC 							= 'ITC - Indonesia Technical Center';
   public static final String LAB_NAME_TECHNICAL_APPLICATION_LAB 	= 'Technical Application Laboratory';
   public static final String LAB_NAME_PAL_BD_M9 					= 'Paper Applications Laboratory (PAL Bd. M9)';
   public static final String LAB_NAME_WAL_BD_F7 					= 'Water Applications Laboratory (WAL Bd. F7)';
   public static final String LAB_NAME_WAS 							= 'WAS - Water Analytical Services';
   public static final String LAB_NAME_CAS_BD_M9 					= 'Customer Analytical Services (CAS Bd. M9)';
   public static final String LAB_NAME_NA_PAPER_MAKING_LAB 			= 'NA Paper Making Laboratory';
   public static final String LAB_NAME_SOLENIS_TECHNOLOGIES_GERMANY	= 'Solenis Technologies Germany GmbH';
    
   public static final String TECHNICAL_CENTER_WILMINGTION	= 'Wilmington';
   public static final String TECHNICAL_CENTER_PAULINIA	    = 'Paulinia'; 
   public static final String TECHNICAL_CENTER_SHANGHAI   	= 'Shanghai';
   public static final String TECHNICAL_CENTER_INDIA   		= 'India';
   public static final String TECHNICAL_CENTER_INDONESIA	= 'Indonesia';
   public static final String TECHNICAL_CENTER_KREFELD  	= 'Krefeld';
   public static final String TECHNICAL_CENTER_BARENDRECHT	= 'Barendrecht';
    
   public static final String SECTION_NAME_ANALYTICAL    = 'Analytical';
   public static final String SECTION_NAME_PAPER_MAKING  = 'Paper Making';
   public static final String SECTION_NAME_PAPER_TESTING = 'Paper Testing';
   public static final String SECTION_NAME_APPLICATIONS  = 'Applications';
   public static final String SECTION_NAME_COLORANTS     = 'Colorants';
    
   public static final String REQUEST_TYPE_WTR = 'WTR';
   public static final String REQUEST_TYPE_PPD = 'PPD';
    
   public static final String REQUEST_NAME_WRAP   = 'New Routine Analytical Request (WRAP)';
   public static final String REQUEST_NAME_COUPON = 'Coupon Ordering'; 

}