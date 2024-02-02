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
}