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
    BIMDataAPI api = BIMDataAPI.new_session();
    cloudId = '25737';
    projectId = '832106';
    modelId = '1175967';
    viewerToken = getViewerToken();
  }
}