import { LightningElement, track, wire } from 'lwc';
import Id from '@salesforce/user/Id';
import { getRecord } from 'lightning/uiRecordApi';
import { getFieldValue } from 'lightning/uiRecordApi';
// import USER_PROFILE_PHOTO_FIELD from '@salesforce/schema/User.SmallPhotoUrl';
import UserNameFIELD from '@salesforce/schema/User.Name';
import assetFolder from '@salesforce/resourceUrl/Solenis_Exp_Icons';

export default class Solenis_Header extends LightningElement {

      @track userId = Id;
      @track currentUserName;
      @track solenisLogo = assetFolder + "/Solenis_Exp_Icons/solenisLogo.svg";
      @track searchLogo = assetFolder + "/Solenis_Exp_Icons/Search.svg";
      @track notificationLogo = assetFolder + "/Solenis_Exp_Icons/Alert.svg";
      @track profileLogo = assetFolder + "/Solenis_Exp_Icons/Profile.svg";

      @wire(getRecord, { recordId: '$userId', fields: [USER_PROFILE_PHOTO_FIELD, UserNameFIELD] })
      userRecord;

      get profilePhotoUrl() {
            console.log('PP URL:: ',getFieldValue(this.userRecord.data, USER_PROFILE_PHOTO_FIELD));
            return getFieldValue(this.userRecord.data, USER_PROFILE_PHOTO_FIELD);
      }

      get profileUserName() {
            console.log('User Name :: ',getFieldValue(this.userRecord.data, UserNameFIELD));
            return getFieldValue(this.userRecord.data, UserNameFIELD);
      }
}