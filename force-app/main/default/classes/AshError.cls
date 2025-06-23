public with sharing class AshError {
		public static final String SEVERITY_CONFIRM = 'CONFIRM';		
		public static final String SEVERITY_ERROR = 'ERROR';		
		public static final String SEVERITY_FATAL = 'FATAL';		
		public static final String SEVERITY_INFO = 'INFO';		
		public static final String SEVERITY_WARNING = 'WARNING';		


		public integer errorNumber {get;set;}
		public String errorText {get;set;}
		public String errorSeverity {get;set;}
		public String errorSource {get;set;}
		public String errorPrefix {get;set;}
		public String errorLocation {get;set;}
		public String formName {get;set;}
		public String fieldName {get;set;}
		public String fieldLabel {get;set;}
		public integer row {get;set;}
		public integer col {get;set;}
		
		public AshError(String errorText, String errorSeverity) {
			this.errorNumber = 0;
			this.errorText = errorText;
			this.errorSeverity = errorSeverity;
			this.errorSource = '';
			this.errorPrefix = '';
			this.errorLocation = '';
			this.formName = '';
			this.fieldName = '';
			this.fieldLabel = '';
			this.row = 0;
			this.col = 0;
		}

		public AshError(Integer errorNumber) {
			this.errorNumber = errorNumber;
			this.errorText = '';  //Should look this up...
			this.errorSeverity = '';
			this.errorSource = '';
			this.errorPrefix = '';
			this.errorLocation = '';
			this.formName = '';
			this.fieldName = '';
			this.fieldLabel = '';
			this.row = 0;
			this.col = 0;
		}

		public AshError(Integer errorNumber, String errorText, String errorSeverity) {
			this.errorNumber = errorNumber;
			this.errorText = errorText;
			this.errorSeverity = errorSeverity;
			this.errorSource = '';
			this.errorPrefix = '';
			this.errorLocation = '';
			this.formName = '';
			this.fieldName = '';
			this.fieldLabel = '';
			this.row = 0;
			this.col = 0;
		}

		public String errorMessage() {
			String result = '';
			
			if (errorPrefix != '') {result += ' ' + errorPrefix + ' - ';}
			if (errorLocation != '') {result += ' ' + errorLocation + ' - ';}
			if (row != 0) {result += ' in Row ' + row + '';}
			if (col != 0) {result += ' in Col ' + col + '';}
			if (fieldLabel != '') {result += ' with ' + fieldLabel + ' - ';}
			if (errorNumber != 0) {result += ' ' + errorNumber + ' - ';}
			if (errorText != '') {result += ' ' + errorText;}
			
			return result;
		}

		public void apexPagesAddMessage() {
			ApexPages.Severity severity;
			
			if (errorSeverity == SEVERITY_CONFIRM) {severity = ApexPages.Severity.CONFIRM;}
			if (errorSeverity == SEVERITY_ERROR) {severity = ApexPages.Severity.ERROR;}
			if (errorSeverity == SEVERITY_FATAL) {severity = ApexPages.Severity.FATAL;}
			if (errorSeverity == SEVERITY_INFO) {severity = ApexPages.Severity.INFO;}
			if (errorSeverity == SEVERITY_WARNING) {severity = ApexPages.Severity.WARNING;}
			
			ApexPages.Message errMessage = new ApexPages.Message(severity, errorMessage());
			ApexPages.addMessage(errMessage);
		}
}