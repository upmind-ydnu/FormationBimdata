public with sharing class GICAnnotationUtil {
    static public List<GICAnnotation__c> whereInZone(Id gicZoneId){
        return [SELECT
            Id,
            GICModel__c,
            GICZone__c,
            Name,
            x__c,
            y__c,
            z__c,
            color__c
            FROM
                GICAnnotation__c
            WHERE
                GICZone__c = :gicZoneId                 
        ];
    }

    static public GICAnnotation__c find(Id gicAnnotationId){
        return [SELECT
            Id,
            GICModel__c,
            GICZone__c,
            Name,
            x__c,
            y__c,
            z__c,
            color__c
            FROM
                GICAnnotation__c
            WHERE
                Id = :gicAnnotationId                 
        ];
    }

    static public GICAnnotation__c create(
        String zoneId,
        String name,
        String x,
        String y,
        String z,
        String color
    ){
        GICZone__c zone = GICZoneUtil.find(zoneId);
        GICAnnotation__c gicAnnotation = new GICAnnotation__c(
            GICModel__c = zone.GICModel__c,
            GICZone__c = zoneId,
            Name = name,
            x__c = Decimal.valueOf(x),
            y__c = Decimal.valueOf(y),
            z__c = Decimal.valueOf(z),
            color__c = color
        );
        insert gicAnnotation;
        return find(gicAnnotation.Id);
    }

    public static List<Map<String, Object>> toMap(List<GICAnnotation__c> gicAnnotations){
        List<Map<String, Object>> annotationsMap = new List<Map<String, Object>>();
        for(GICAnnotation__c annotation : gicAnnotations){            
            Map<String, Object> annotationMap = new Map<String, Object>{
                'id' => annotation.Id,
                'name' => annotation.name,
                'x' => annotation.X__c,
                'y' => annotation.Y__c,
                'z' => annotation.Z__c,
                'color' => annotation.color__c
            };
            annotationsMap.add(annotationMap);

        }
        return annotationsMap;
    }

}