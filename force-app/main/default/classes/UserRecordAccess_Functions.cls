public class UserRecordAccess_Functions {
	
	public static UserRecordAccess getUserRecordAccess(Id userId, Id recordId) {
		List<UserRecordAccess> alist = [
		    Select RecordId, MaxAccessLevel, 
		           HasTransferAccess, HasReadAccess, 
		           HasEditAccess, HasDeleteAccess, 
		           HasAllAccess 
		      From UserRecordAccess u
		     where UserId = :userId
		       and RecordId = :recordId];
        if (alist != null && !alist.isEmpty()) {return alist[0];} return null;
	}

}