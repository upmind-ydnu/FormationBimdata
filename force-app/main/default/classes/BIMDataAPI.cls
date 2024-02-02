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
    public String modelId;

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