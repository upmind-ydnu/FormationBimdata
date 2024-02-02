global with sharing class BIMDataViewerController {
  public String cloudId {get; set;}
  public String projectId {get; set;}
  public String modelId {get; set;}
  public String viewerToken {get; set;}

  private String getViewerToken() {
    BIMDataAPI api = BIMDataAPI.new_session();
    api.cloudId = cloudId;
    api.projectId = projectId;
    return api.createProjectToken();
  }
  
  public BIMDataViewerController() {
    String recordId = ApexPages.currentPage().getParameters().get('id').escapeHtml4();
    GICModel__c gicModel =  GICModelUtil.find(recordId);

    BIMDataAPI api = BIMDataAPI.new_session();
    cloudId = gicModel.cloudId__c;
    projectId = gicModel.projectId__c;
    modelId = gicModel.modelId__c;
    viewerToken = getViewerToken();
  }
}