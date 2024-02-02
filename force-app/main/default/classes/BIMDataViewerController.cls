global with sharing class BIMDataViewerController {
  public String cloudId {get; set;}
  public String projectId {get; set;}
  public String modelId {get; set;}
  public String viewerToken {get; set;}

  public String zoneUUID {get; set;}

  public GICModel__c gicModel {get; set;}
  public GICZone__c gicZone {get; set;}

  private String getViewerToken() {
    BIMDataAPI api = BIMDataAPI.new_session();
    api.cloudId = cloudId;
    api.projectId = projectId;
    return api.createProjectToken();
  }
  
  public BIMDataViewerController() {
    String recordId = ApexPages.currentPage().getParameters().get('id').escapeHtml4();
    String sObjectType = String.valueOf(((id)recordId).getSobjectType());

    if (sObjectType == 'GICModel__c') {
      gicModel =  GICModelUtil.find(recordId);
    }else if (sObjectType == 'GICZone__c') {
      gicZone = GICZoneUtil.find(recordId);
      gicModel =  GICModelUtil.find(gicZone.GICModel__c);
      zoneUUID = gicZone.uuid__c;
    }

    BIMDataAPI api = BIMDataAPI.new_session();
    cloudId = gicModel.cloudId__c;
    projectId = gicModel.projectId__c;
    modelId = gicModel.modelId__c;
    viewerToken = getViewerToken();
  }
}