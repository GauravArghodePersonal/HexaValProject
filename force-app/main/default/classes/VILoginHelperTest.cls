/**
 * Contains test methods for the VILoginHelper class.
 */
@IsTest
private class VILoginHelperTest {
	/**
	 * Check the portal type of the current user.
	 */
	testmethod static void checkPortalType() {
		Test.startTest();
		VILoginHelper.getPortalType(UserInfo.getUsername());
		Test.stopTest();
	}
}