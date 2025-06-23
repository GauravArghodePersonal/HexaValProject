/**
 * Allows users to request access to the ValvolineInstaller.com portal.
 */
public with sharing class VIPortalAccessRequestController {
	// Constants
	private static final String RECORD_TYPE = 'Valvoline DIFM Lead';
	private static final String QUEUE_NAME = 'Valvoline - Lead Queue';
	
	// Fields
	private Integer currentStep = -1;
	private String hasInvoice = 'Yes';
	private final VIInputField customerNumber = new VIInputField();
	private final Lead lead;
	
	/**
	 * Creates a new VIPortalAccessRequestController object.
	 */
	public VIPortalAccessRequestController() {
		lead = new Lead();
	}
	
	/**
	 * Gets the current step.
	 */
	public Integer getCurrentStep() {
		return currentStep;
	}
	
	/**
	 * Gets a value that indicates whether error have occurred.
	 */
	public Boolean getHasErrors() {
		return ApexPages.hasMessages(ApexPages.Severity.ERROR);
	}
	
	/**
	 * Gets a value which indicates whether the user has an invoice.
	 */
	public String getHasInvoice() {
		return hasInvoice;
	}
	
	/**
	 * Sets a value which indicates whether the user has an invoice.
	 */
	public void setHasInvoice(String hasInvoice) {
		this.hasInvoice = hasInvoice;
	}
	
	/**
	 * Gets the SAP customer number.
	 */
	public VIInputField getCustomerNumber(){
		return customerNumber;
	}
	
	/**
	 * Gets a value that indicates whether this is an on-book or an off-book customer.
	 */
	public boolean getIsOnBook(){
		return 'Yes'.equalsIgnoreCase(hasInvoice);
	}
	
	/**
	 * Gets a reference to the Lead object.
	 */
	public Lead getLead() {
		return lead;
	}
	
	/**
	 * Initializes the controller.
	 */
	public void init() {
		step1();
	}
	
	/**
	 * Moves to step 1 in the wizard.
	 */
	public void step1() {
		currentStep = 1;
	}
	
	/**
	 * Moves to step 2 in the wizard.
	 */
	public void step2() {
		currentStep = 2;
	}
	
	/**
	 * Moves to step 3 in the wizard.
	 */
	public void step3() {
		currentStep = 3;
	}
	
	/**
	 * Submits the portal access request.
	 */
	public void submit() {
		try {
			// Get the lead record type
			List<RecordType> recordTypes = [SELECT Id
					FROM RecordType
					WHERE Name = :RECORD_TYPE
					AND SobjectType = 'Lead'
					AND IsActive = TRUE];
			if (recordTypes.isEmpty()) {
				// Record type not found
				CustomException.throwException(
						new List<String> { 'Record type \'' + RECORD_TYPE + '\' not found.' });
			}
			
			// Save the lead
			lead.RecordTypeId = recordTypes.get(0).Id;
			if (getIsOnBook()) {
				submitOnBook();
			}
			else {
				submitOffBook();
			}
			
			// If no errors occurred, redirect to step 3
			Boolean hasErrors = getHasErrors();
			if (!hasErrors) {
				step3();
			}
		}
		catch (Exception e) {
			// Display the error
			ApexPages.addMessages(e);
		}
		
	}
	
	/**
	 * Submits the portal access request for an on-book customer.
	 */
	private void submitOnBook() {
		// Make sure customer number was entered
		if (customerNumber.getValue() == null) {
			// Customer number not entered
			customerNumber.setError('You must enter a value');
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
					'Customer Number: You must enter a value'));
			return;
		}
		
		// Get the account specified by the entered customer number. The owner of this account will
		// be used as the owner of the new lead
		List<Account> accounts = [SELECT Id, OwnerId
				FROM Account
				WHERE SAP_Customer_Number__c = :customerNumber.getValue()
				LIMIT 2];
		
		if (accounts.isEmpty()) {
			// No matching account
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
					'No account found for customer number \'' + customerNumber.getValue() + '\'.'));
			return;
		}
		else if (accounts.size() > 1) {
			// Ambigious customer number
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
					'More than one account found with customer number \'' + customerNumber.getValue() + '\'.'));
			return;
		}
		
		// Create the lead
		try {
			lead.OwnerId = accounts.get(0).OwnerId;
			lead.Distributor_Account__c = accounts.get(0).Id;
			lead.Distributor_Account_Number__c = customerNumber.getValue();
			insert lead;
		}
		catch (Exception e) {
			ApexPages.addMessages(e);
		}
	}
	
	/**
	 * Submits the portal access request for an off-book customer.
	 */
	private void submitOffBook() {
		// Get the Valvoline lead queue
		List<Group> groups = [SELECT Id
				FROM Group
				WHERE Name = :QUEUE_NAME
				AND Type = 'Queue'];
		
		if (groups.isEmpty()) {
			// Queue not found
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
					'Queue \'' + QUEUE_NAME + '\' not found.'));
			return;
		}
		
		// Create the lead
		try {
			lead.OwnerId = groups.get(0).Id;
			insert lead;
		}
		catch (Exception e) {
			ApexPages.addMessages(e);
		}
	}
	
	/**
	 * Cancels the request access and returns the user to the portal home page.
	 */
	public PageReference cancel() {
		PageReference pageRef = Page.VISiteHome;
		pageRef.setRedirect(true);
		
		return pageRef;
	}
}