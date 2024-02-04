# Formation BIMData + SF

# Présentation rapide BIMData

Creer un compte sur la plateform bimdata

Petite visite rapide

- [https://platform.bimdata.io/](https://platform.bimdata.io/) : Permet l’administration des modèles
- [https://developers.bimdata.io/](https://developers.bimdata.io/) : La documentation
    - Viewer
    - API
- [https://connect.bimdata.io/](https://developers.bimdata.io/) : Gestion du SSO et des apps openid

Création d’un app bimdata pour la suite

Copier le client et le secret id

![Untitled](Formation%20BIMData%20+%20SF%201a53da5921a847979e5daadddc934bdd/Untitled.png)

# Préparation de l’env de travail.

Scratch Org pour tout le monde ?

- Creer un compte developpeur
- Attendre l’email
- Le passer en Dev Hub
- Créer un projet SF Vide
- 

```json
# Créer un projet vide
# setter la dev hub
sf  org list limits -o ogossegardet@upmind.fr.ludwig

# Créer uune scratch org
sf org create scratch --definition-file config/project-scratch-def.json -a FormationBIMData

# Ouvrir
sf org open

```

- Créer un projet / Sandbox

## Composant de base

Créer une VF page `Bimdataviewer`

La VF doit etre visible dans app builder 

```
<?xml version="1.0" encoding="UTF-8"?>
<ApexPage xmlns="http://soap.sforce.com/2006/04/metadata"> 
    <apiVersion>59.0</apiVersion>
    <label>BIMDataViewer</label>
    <availableInTouch>true</availableInTouch>
</ApexPage>
```

Créer un controller équivalent

`BIMDataViewerController`

```json
global with sharing class BIMDataViewerController {
}
```

Par le point & Click : Creer une App BIMDataViewer

- Ajouter la visualforce
- Activer comme app

![Untitled](Formation%20BIMData%20+%20SF%201a53da5921a847979e5daadddc934bdd/Untitled%201.png)

Code de la page :

```html
<apex:page controller="BIMDataViewerController">
  <style>
      html,
      body {
        margin: 0;
        padding: 0;
        background-color: whitesmoke;
      }
      
      button.bimdata-btn {
        background-image: none;
      }
    </style>  
  <script type="module">
    import makeBIMDataViewer from 'https://cdn.jsdelivr.net/npm/@bimdata/viewer@2.0.0-beta.90/dist/bimdata-viewer.esm.min.js';
    const bimdataViewer = makeBIMDataViewer({
      api: {
        modelIds: [15097],
        cloudId: 10344,
        projectId: 237466,
        accessToken: "TAbdyPzoQeYgVSMe4GUKoCEfYctVhcwJ",
      },
    });
    const vm = bimdataViewer.mount("#viewer");
    </script>
    <div style="height: 100vh;">
      <div id="viewer"></div>
    </div>

</apex:page>
```

Explication sur le code 

Partie CSS / API / …

## Ajout de la config bimdata

Le viewer bimdate est pilotable par le code : 

### Paramétrage de l’UI

```html
<apex:page controller="BIMDataViewerController">
  <style>
      html,
      body {
        margin: 0;
        padding: 0;
        background-color: whitesmoke;
      }
      
      button.bimdata-btn {
        background-image: none;
      }
    </style>  
  <script type="module">
    import makeBIMDataViewer from 'https://cdn.jsdelivr.net/npm/@bimdata/viewer@2.0.0-beta.90/dist/bimdata-viewer.esm.min.js';

    const bimdataViewerConfig = {
      ui: {
        // style: {
        //   backgroundColor: "FFFFFF",
        // },
        headerVisible: false,
        windowManager: false,
        version: false,
        bimdataLogo: false,
        contextMenu: false,
        menuVisible: false,
      },
      plugins: {
        alerts: true,
        bcf: false,
        bcfManager: false,
        buildingMaker: false,
        dwg: true,
        "dwg-layer": true,
        dxf: true,
        equipment2d: false,
        fullscreen: true,
        gauge2d: false,
        ged: true,
        measure2d: false,
        measure3d: false,
        pdfAnnotations: false,
        pdfExport: false,
        pdf: false,
        plan: {
          help: false,
          modelLoader: "hidden",
        },
        viewer3d: {
          help: false,
          modelLoader: 'hidden',
          synchronization: false,
        },
        viewer2d: {
          help: false,
          modelLoader: 'hidden',
          compass: false,
        },        
        panorama: true,
        pointCloud: true,
        pointCloudParameters: true,
        projection: false,
        properties: false,
        search: false,
        section: false,
        smartview: false,
        split: false,
        "storey-selector": false,
        structure: false,
        "structure-properties": true,
        "viewer2d-background": false,
        "viewer3d-background": false,
        "viewer2d-drawer": false,
        "viewer2d-parameters": true,
        "viewer2d-screenshot": false,

        "viewer3d-parameters": true,
        "window-split": true,
      }
    };

    const bimdataViewer = makeBIMDataViewer({
      api: {
        modelIds: [15097],
        cloudId: 10344,
        projectId: 237466,
        accessToken: "TAbdyPzoQeYgVSMe4GUKoCEfYctVhcwJ",
      },
      ...bimdataViewerConfig
    });
    const vm = bimdataViewer.mount("#viewer");
    </script>
    <div style="height: 100vh;">
      <div id="viewer"></div>
    </div>

</apex:page>
```

### Paramétrage des windows

```jsx
	... 
  const customLayout = {
        ratios: [30, 70],
        children: [
          "3d",
          "2d"
        ],
      };

    const bimdataViewer = makeBIMDataViewer({
      api: {
        modelIds: [15097],
        cloudId: 10344,
        projectId: 237466,
        accessToken: "TAbdyPzoQeYgVSMe4GUKoCEfYctVhcwJ",
      },
      ...bimdataViewerConfig
    });
    const vm = bimdataViewer.mount("#viewer", customLayout);
...
```

# Intégration avec l’API BIMData

Il n’est pas possible d’accèder par l’API à un espace/cloud créé par la plateforme 

Il faut donc utiliser les identifiants de l’app bimdata pour créer le cloud voulu et le projet.

Autoriser en remote setting : 

- [https://iam.bimdata.io](https://iam.bimdata.io/)
- [https://api.bimdata.io](https://iam.bimdata.io/)

Class Apex pour discussion avec BIMData

```java
public class BIMDataAPI {
    public static BimdataApi instance {
        get {
            if(instance == null){
                instance = BimdataApi.new_session();
            }
            return instance;
        }
        set;
    }

    public static String token;
    Map<String, String> headers;
    public String cloudId;
    public String projectId;

    class BimdataApiException extends Exception {}

    public BimdataApi() {
        this.headers = new Map<String, String>{
            'Content-Type' => 'application/json',
            'Authorization' => 'Bearer ' + token
        };
        this.cloudId = null;
    }

    public static BimdataApi new_session() {
        token = BimdataApi.getToken();
        return new BimdataApi();
    }

    public static String getToken() {
        String CLIENTID = 'ebcd547f-1318-4d25-8683-863ea0f6965c';
        String CLIENTSECRET = 'a494e8fcb5739808ab477d8aa7a4ddefdd21fef9ac700338d14350b2';
    
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://iam.bimdata.io/auth/realms/bimdata/protocol/openid-connect/token');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setBody('grant_type=client_credentials&client_id='+ CLIENTID +'&client_secret='+ CLIENTSECRET);

        Http http = new Http();
        HttpResponse res = http.send(req);
        if (!(res.getStatusCode() >= 200 && res.getStatusCode() < 300)){
            throw new BimdataApiException('Failed to get a token. Status code: ' + res.getStatusCode());
        }
        Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        return (String) data.get('access_token');

    }
    
    
    public String createCloud(String name) {
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.bimdata.io/cloud');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + token);
        req.setBody('{"name": "' + name + '"}');
        
        @SuppressWarnings('PMD.Security.ApexSuggestUsingNamedCred')
        Http http = new Http();
        HttpResponse res = http.send(req);
        if (!(res.getStatusCode() >= 200 && res.getStatusCode() < 300)){
            throw new BimdataApiException('FAILED - createCloud. Status code: ' + res.getStatusCode() + ' '+ res.getBody());
        }
        Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        this.cloudId = String.valueOf( data.get('id'));
        system.debug(LoggingLevel.INFO,'Cloud was created: ' + this.cloudId);
        return this.cloudId;
    }

    public String createProject(String name, String description) {
        String url = 'https://api.bimdata.io/cloud/' + cloudId + '/project';

        // Prepare request body
        Map<String, Object> data = new Map<String, Object>{
            'name' => name,
            'description' => (description != null ? description : name),
            'status' => 'A'
        };

        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + token);
        req.setBody(JSON.serialize(data));

        Http http = new Http();
        HttpResponse res = http.send(req);
        if (!(res.getStatusCode() >= 200 && res.getStatusCode() < 300)){
            throw new BimdataApiException('FAILED - createProject. Status code: ' + res.getStatusCode() + ' '+ res.getBody());
        }

        Map<String, Object> responseData = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        
        this.projectId = String.valueOf( responseData.get('id'));
        system.debug(LoggingLevel.INFO,'Project was created: ' + this.projectId);
        return this.projectId;
    }

    public Map<String, Object> inviteUser(String email) {
        String url = 'https://api.bimdata.io/cloud/' + cloudId + '/invitation';

        Map<String, Object> data = new Map<String, Object>{
            'email' => email,
            'redirect_uri' => 'https://bimdata.io'
        };

        // Perform HTTP request
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + token);
        
        req.setBody(JSON.serialize(data));

        HttpResponse res = http.send(req);
        if (!(res.getStatusCode() >= 200 && res.getStatusCode() < 300)){
            throw new BimdataApiException('FAILED - inviteUser. Status code: ' + res.getStatusCode() + ' '+ res.getBody());
        }

        Map<String, Object> responseData = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        system.debug(LoggingLevel.INFO,''+responseData);
        return responseData;
    }

    class ScopeBuilder {
        String expiresAt;
        List<String> scopes = new List<String>();
        ScopeBuilder(String expiresAt) {
            this.expiresAt = expiresAt;
            scopes.add('bcf:write');
            scopes.add('document:read');
            scopes.add('document:write');
            scopes.add('model:read');
            scopes.add('model:write');
        }
    }

    public String createProjectToken() {
        String url = 'https://api.bimdata.io/cloud/' + cloudId + '/project/' + projectId +'/access-token';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + token);
        DateTime currentTimePlusTwoHours = DateTime.now().addHours(2);
        String isoFormattedString = currentTimePlusTwoHours.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        ScopeBuilder scopeBuilder = new ScopeBuilder(isoFormattedString);
        String body = JSON.serialize(scopeBuilder);
        req.setBody(body);
        system.debug(url);
        system.debug(body);
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        if (!(res.getStatusCode() >= 200 && res.getStatusCode() < 300)){
            throw new BimdataApiException('FAILED - createProjectToken. Status code: ' + res.getStatusCode() + ' '+ res.getBody());
        }
        Map<String, Object> tokenMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        return (String)tokenMap.get('token');
    }

}
```

## Principe de fonctionnement de l’API

1 Connection 

2 Obtention d’un token Bearer Token

3 Création d’un cloud

4 Invitation du user

5 Création d’un projet

⇒ Upload du modèle depuis la plateforme dans le projet.

Code pour execution Anonyme

```java
// Création d'un cloud dans BIMData
BIMDataAPI instance = BIMDataAPI.new_session();
instance.createCloud('test');
// Rendre visible le cloud dans son compte pour BIMData
instance.inviteUser('ogossegardet@upmind.fr');

// Création d'un projet dans BImdata
BIMDataAPI instance = BIMDataAPI.new_session();
instance.cloudId = '25737'; // Id du cloud de la commande précedente
instance.createProject('test','ma description');

// Création d'un token 
BIMDataAPI instance = BIMDataAPI.new_session();
instance.cloudId = '25737';
instance.projectId = '832106'; // Id du projet de la commande précédente
system.debug(instance.createProjectToken());
// => Récupération d'un token
// Penser à récupérer l'id du model dans Bimdata
```

## Explication sur la structure des données BIMData

- Cloud / Projet / Model
- Explication sur le token de projet
- Création d’un compte BIMData pour chacun
    - ⇒ Création d’une app.
- Code Apex Interface avec Bimdata

## Modification du controller

```java
// BIMDataViewerController
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
```

## Modification de la VF page pour afficher ce nouveau modèle

```jsx

			// Lire les données du controller
			const cloudId = '{!cloudId}';
      const projectId = '{!projectId}';
      const modelId = '{!modelId}';
      const viewerToken = '{!viewerToken}'

			// Variabilisation
			const bimdataViewer = makeBIMDataViewer({
        api: {
          cloudId: cloudId,
          projectId: projectId,
          modelIds: [modelId],
          accessToken: viewerToken,
        },
        ...bimdataViewerConfig
      });
      const vm = bimdataViewer.mount("#viewer", customLayout);

```

# App SF QOOZY Viewer intégrant le viewer

## Création de l’App

- Création des modeles GICModel /  GICZone / GICAnnotation
- Création de tab pour chacun de ces modèles
- Création d’une App Lightning QoozyViewer
- Associer les 3 tabs à cette App

- Modifier le controller pour ne plus gérer les données en ‘dur’

```java
global with sharing class BIMDataViewerController {

	// Code ...
  
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
```

- Dans l’app QoozyViewer, ajouter un GIcModel avec les données précédentes
- Modifier ensuite la page pour y intégrer le BIMDataViewer + Activer en défaut pour l’Org

⇒ Le modèle est maintenant visible

![Untitled](Formation%20BIMData%20+%20SF%201a53da5921a847979e5daadddc934bdd/Untitled%202.png)

<aside>
💡 Créer un deuxième projet dans BIMData avec un autre modèle
Le rendre visible dans QOOZYViewer

</aside>

## Charger les zones d’un modèle

Appel de l’api bimdata correspondante :

```java
public class BIMDataAPI {
    // Code ...
    public List<Map<String,Object>> getZones() {
        String token = createProjectToken();
        String url = 'https://api.bimdata.io/cloud/' + cloudId + '/project/' + projectId + '/model/' + modelId + '/zone';
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + token);
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        if (!(res.getStatusCode() >= 200 && res.getStatusCode() < 300)){
            throw new BimdataApiException('FAILED - getZone. Status code: ' + res.getStatusCode() + ' '+ res.getBody());
        }
        List<Object> rawZones = (List<Object>) JSON.deserializeUntyped(res.getBody());
        List<Map<String,Object>> zones = new List<Map<String,Object>>();
        for(Object zone : rawZones){
            zones.add((Map<String, Object>) zone);
        }
        return zones;
    }
}
```

```java
public with sharing class GICModelUtil {
    // Code ...
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
```

Execution anonyme

Retrouver l’id sf du modèle voulu 

```java
// Loading des zones
Id gicModelId = 'a005t0000091jmoAAA';
GICModel__c model = GICModelUtil.find(gicModelId);
GICModelUtil.loadZones(model.Id);
```

⇒ Aller dans la page GICZone de l’app : Les zones sont chargées 

![Untitled](Formation%20BIMData%20+%20SF%201a53da5921a847979e5daadddc934bdd/Untitled%203.png)

## Initialisation d’un viewer à la bonne zone

Une page VF recoit en id l’id Sf de l’objet de la RecordPage 

⇒ Déterminer l’objet et faire l’action voulu

ICI, le BIMDataVIewer est ajouté sur la page GICZOne ⇒ l’id recu sera un GICZone__c

```java
global with sharing class BIMDataViewerController {
  // Code ..
  public String zoneUUID {get; set;}

  public GICModel__c gicModel {get; set;}
  public GICZone__c gicZone {get; set;}

  // Code ..
  
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
```

(Pour le reste du code, voir le commit correspondant :/)

## Création d’un plugin d’annotation dans bimdata

Principe

```jsx
// Définition du plugin et de son affichage
const annotationPlugin = {
  name: "annotationPlugin",
  component: annotationPluginComponent,
  addToWindows: ["3d", "2d", "dwg", "plan", "pointCloud", "panorama"],
  button: {
    position: "left",
    content: "simple",
    tooltip: 'Ajouter une annotation',
    keepOpen: true,
    icon: {imgUri: "https://testogg.s3.eu-west-1.amazonaws.com/annotation.svg"}
  }
};

// Définition du comportement du plugin
const annotationPluginComponent = {
  template: annotationPluginComponentTemplate(),
  data() {
    return {
      count: 0,
      color: "7A7A7A",
      message: "",
      displayColorSelector: false,
    };
  },
  mounted() {
    this.viewer = this.$viewer.localContext.plugins.get("viewer3d") ||
                  this.$viewer.localContext.plugins.get("viewer2d");
  },
  onOpen() {
    this.viewer.startAnnotationMode(data => {
      const { x, y, z } = data;
      this.count++;
      addAnnotation(this.$viewer, this.message, this.color, x, y, z, {count: this.count})
    });
  },
  onClose() {
    this.viewer.stopAnnotationMode();
  },
  methods: {
    updateColorSelector(color) {
      this.color = color;
      this.displayColorSelector = false;
    }
  }
};
```

Activer le plugin au niveau du viewer 

```jsx
const bimdataViewer = makeBIMDataViewer({
	// Code ...
});
**bimdataViewer.registerPlugin(annotationPlugin);**
const viewerInstance = await bimdataViewer.mount("#viewer", customLayout);
```

## Faire le lien avec les annotations dans Salesforce

cf commit

# Pour aller plus loin

## Rendre le viewer compatible avec n’importe quel objet

```java
global with sharing class BIMDataViewerController {
// code ...
public BIMDataViewerController() {
		// code ...

    else {
        // fonction de record id
        SObject record = GICUtil.getObjectDetails(recordId);
        try{
            Id zoneId = (Id)record.get('GICZone__c');
            if(zoneId == null){
                throw new CustomException('Object can support the viewer, but the zone is empty');
            }
            gicZone = GICZoneUtil.find(recordId);
            gicModel =  GICModelUtil.find(gicZone.GICModel__c);
            zoneUUID = gicZone.uuid__c;
        }catch(System.SObjectException e){
            throw new CustomException('Object dont support the viewer\n. Please add the UBDZone__c field to the object');
        }
    }
	// code ...
}

// Retouver l'objet voulu
public with sharing class GICUtil {
    public static SObject getObjectDetails(Id recordId) {
        // Get the object type of the record
        String sObjectType = String.valueOf(recordId.getSobjectType());
        String fieldList = getFieldsForQuery(sObjectType);        
        List<SObject> records = Database.query(
            'SELECT ' + 
            String.escapeSingleQuotes(fieldList) + 
            ' FROM ' + 
            String.escapeSingleQuotes(sObjectType) + 
            ' WHERE Id = :recordId'
        );

        SObjectAccessDecision decision = Security.stripInaccessible(AccessType.READABLE, records );
        return decision.getRecords()[0];
    }
		
		public static String getFieldsForQuery(String sObjectType) {
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(sObjectType).getDescribe().fields.getMap();
        String fields = String.join(new List<String>(fieldMap.keySet()), ',');
        return fields;
    }
}
```

## Faire le lien avec LWC

Utilisation d’un message channel pour réagir à un clic.

### Dans la VF Page

```jsx
window.sforce.one.subscribe(messageChannel, (event) => {
		if(event.action === 'focus'){
	    handleDeselect();
	    handleZone(event.uuid);
		}
  });
```

### LWC

```jsx
import GICMC from "@salesforce/messageChannel/GICChannel__c";
import { MessageContext, publish } from 'lightning/messageService';
// Code ...
export default class GicZone extends LightningElement {
    @wire(MessageContext) messageContext;
// Code ...
    handleZoneClick() {
        const payload = {
						action : 'focus',
            uuid : this.uuid
        }
        publish(this.messageContext, GICMC, payload);
    }
// Code ..
}
```