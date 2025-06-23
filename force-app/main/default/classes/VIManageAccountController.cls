/**
 * Redirects the user to the standard detail page for his/her account.
 */
public with sharing class VIManageAccountController {
	/**
	 * Initializes the controller.
	 */
	public PageReference init() {
		PageReference pageRef = null;
		
		Id portalAccountId = VIUtils.getPortalAccountId();
		if (portalAccountId != null) {
			pageRef = new PageReference('/' + portalAccountId);
			pageRef.setRedirect(true);
		}
		
		return pageRef;
	}
}