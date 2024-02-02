public with sharing class GICModelUtil {
    public static GICModel__c find(Id gicModelId){
        return [SELECT 
                Id,
                cloudId__c,
                projectId__c,
                modelId__c,
                Name
            FROM 
            GICModel__c 
            WHERE Id = :gicModelId
        ];
    }

    @future(callout=true)
    public static void loadZones(Id gicModelId){
        GICModel__c currentGICModel = GICModelUtil.find(gicModelId);

        BimdataApi api = BIMDataAPI.new_session();
        api.cloudId = currentGICModel.cloudId__c;
        api.projectId = currentGICModel.projectId__c;
        api.modelId = currentGICModel.modelId__c;
        List<Map<String,Object>> zones = api.getZones();
        List<GICZone__c> gicZones = new List<GICZone__c>();
        for(Map<String,Object> zone : zones){
            GICZone__c gicZone = new GICZone__c();
            gicZone.GICModel__c = currentGICModel.Id;
            gicZone.Name = (String)zone.get('name');
            gicZone.uuid__c = (String)zone.get('uuid');
            gicZones.add(gicZone);
        }
        insert gicZones;
    }
}