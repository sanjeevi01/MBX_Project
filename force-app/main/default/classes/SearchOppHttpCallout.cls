public with sharing class SearchOppHttpCallout {
    @AuraEnabled
    public static Integer postOpp(String i){
        //Call Opportunity associated to Id List
        Opportunity opp=[select name, accountid,stagename, type, amount from opportunity where id=:i];

        // Creating a JSONgenerator object
        JSONGenerator gen = JSON.createGenerator(true);
        
        // opening the JSON generator
        gen.writeStartObject(); 

        // Writing data to the JSON string.
        gen.writeStringField('Name ', opp.name);
        gen.writeStringField('Accountid',opp.accountid);
        gen.writeStringField('Stage ', opp.StageName);
        gen.writeStringField('type ', opp.type);
        gen.writeStringField('amount',String.valueOf(opp.Amount)) ;

         // closing the JSON generator
        gen.writeEndObject();
        
        // creating a string from the JSON generator
        String jsonS = gen.getAsString();

        //check
        System.debug('jsonMaterials'+jsonS);
       
        //creating a new HTTP object
        Http http = new Http();

        // creating an HTTPrequest object
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://project4.free.beeceptor.com/my/api/path');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(jsonS);

        // creating a new HTTP response for receiving the remote response
        HttpResponse response = http.send(request);
        system.debug(response.getStatusCode());

               
        if (response.getStatusCode() != 200) {
            //System.debug('The status code returned was not expected: ' +\response.getStatusCode() + ' ' + response.getStatus());
         
            opp.Integration_Status__c='Failure';
            opp.Integration_Comments__c='Failure';
            update opp;
        }
        else {
            //System.debug(response.getBody());
           
            opp.Integration_Status__c='Success';
            opp.Integration_Comments__c='Success';
            update opp;
        }
        return response.getStatusCode();
    }
}
