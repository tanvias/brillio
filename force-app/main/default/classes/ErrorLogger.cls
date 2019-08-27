/*
 * Description: This Class can be utilized by other Apex Classes to create error Logs 
 * 
 * Created By: Anil Pilaka.
 * 
 * Created Date: Aug 12, 2019
 *
*/
public virtual class ErrorLogger{

  public String className;
  public String methodName;
  public String recordContext;
  public Exception ex;
  
  
  public ErrorLogger(String className,String methodName,String recordContext,Exception ex){
     this.className = className;
     this.methodName = methodName;
     this.recordContext = recordContext;
     this.ex = ex;
  }
  
  //to insert list of error log from apex 
  public static void createLog(List<ErrorLogger> log){
  
      if(checkGlobalSettings(userInfo.getUserId())){
        List<Error_Log__c> errorLogList = new List<Error_log__c>();
    
        for(ErrorLogger errLog: log){
            Error_Log__c logToCreate = new Error_Log__c();
            logToCreate.Line_Number__c = errLog.ex.getLineNumber();
            logToCreate.Stack_Trace__c = errLog.ex.getStackTraceString();
            logToCreate.Error_Type__c = errLog.ex.getTypeName();
            logToCreate.Error_Message__c = errLog.ex.getMessage();
            logToCreate.Class_Name__c = errLog.className;
            logToCreate.Method_Name__c = errLog.methodName;
            logToCreate.Record_Context__c = errLog.recordContext;
            
            errorLogList.add(logToCreate);
        }
      
        if(!errorLogList.isEmpty())
            Database.insert(errorLogList, FALSE);
      }
  }
  
  //to insert single error log from apex 
  public static void createLog(ErrorLogger log){
       if(checkGlobalSettings(userInfo.getUserId())){

        Error_Log__c logToCreate = new Error_Log__c();
        logToCreate.Line_Number__c = log.ex.getLineNumber();
        logToCreate.Stack_Trace__c = log.ex.getStackTraceString();
        logToCreate.Error_Type__c = log.ex.getTypeName();
        logToCreate.Error_Message__c = log.ex.getMessage();
        logToCreate.Class_Name__c = log.className;
        logToCreate.Method_Name__c = log.methodName;
        logToCreate.Record_Context__c = log.recordContext;
        
        Database.insert(logToCreate, FALSE);
      }
  }

  
  public static Boolean checkGlobalSettings(Id userId){
      GlobalSettings__c gs = GlobalSettings__c.getInstance(userId); 
      if(!gs.GenerateLog__c){
          gs = GlobalSettings__c.getInstance(); 
      }
      return gs.GenerateLog__c; 
  }
 
}