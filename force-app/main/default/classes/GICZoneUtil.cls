public with sharing class GICZoneUtil {
    static public GICZone__c find(Id gicZoneId){
        return [
            SELECT
                Id,
                Name,
                UUID__c,
                GICModel__c
            FROM 
                GICZone__c
            WHERE 
                Id = :gicZoneId
        ];
    }
}