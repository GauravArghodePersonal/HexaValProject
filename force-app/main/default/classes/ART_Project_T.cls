@isTest
private class ART_Project_T {
/****************************************************************************
 * Test Class ART_Project_T
 * --------------------------------------------------------------------------
 * Responsible for Testing:
 *   - ART_Project Apex Class
 ****************************************************************************/
 
    //Test Data
    public static ART_Project__c artProject;
    public static List<ART_Project__c> artProjects;

    public static ART_Project project;
    public static ART_Project.ART_Projects projects;
    
    public static List<SelectOption> selectOptions;
    
    private static testMethod void unitTest() {
        // Create Test Data       
        createTestData();

        // Execute Tests
        Test.startTest();
        executeTest01();
        Test.stopTest();
    }
  
    private static void createTestData() {
        artProject = TestObjects.newART_Project();
        artProjects = new List<ART_Project__c>();
        artProjects.add(artProject);
    }
  
    private static void executeTest01() { 
        // Execute Tests 
		project = new ART_Project(artProject);
		
		projects = ART_Project.query(false);
		projects = ART_Project.query(true);
		
		selectOptions = ART_Project.createSelectOptions(artProjects);
		selectOptions = ART_Project.createSelectOptions(projects.projects);
		
		delete artProject;
		projects = ART_Project.query(false);
    }
}