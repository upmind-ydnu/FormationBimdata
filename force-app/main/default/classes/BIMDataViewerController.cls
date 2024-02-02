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

  @RemoteAction
  global static String createAnnotation(
      String zoneId,
      String description,
      String x,
      String y,
      String z,
      String color
  ) {
      GICAnnotation__c annotation = GICAnnotationUtil.create(zoneId, description, x,  y, z, color);
      return '{"success": "true", "annotationId": "' + annotation.Id + '"}';
  }

  @RemoteAction
  global static String getAnnotations(
      String zoneId
  ) {
      List<GICAnnotation__c> annotations = GICAnnotationUtil.whereInZone(zoneId);
      return JSON.serialize(GICAnnotationUtil.toMap(annotations));
  }

}