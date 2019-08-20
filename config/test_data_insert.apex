//Insert Org Default and user global settings 
List<GlobalSettings__c> globalSettingsList = new List<GlobalSettings__c>(); 
Globalsettings__c globalSettingsOrg = new GlobalSettings__c(GenerateLog__c = true);   
globalSettingsList.add(globalSettingsOrg); 
GlobalSettings__c globalSettingsUser = new GlobalSettings__c(GenerateLog__c = true, SetupOwnerId = userInfo.getUserId());  
globalSettingsList.add(globalSettingsUser);
insert globalSettingsList; 

//Insert test data account and contacts 
Account acc = new Account(Name='Demo Account');
insert acc;  
Contact con1 = new Contact(LastName= 'Contact1', FirstName= 'Demo', Account = acc.Id);
Contact con2 = new Contact(LastName= 'Contact2', FirstName= 'Demo', Account = acc.Id); 
List<sObject> sObjectList = new List<sObject>(); 
sObjectList.add(con1); 
sObjectList.add(con2); 
insert sObjectList; 

