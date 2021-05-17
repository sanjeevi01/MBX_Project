public with sharing class SearchOppHttpCallout {
  @AuraEnabled
  public static Integer postOpp(String i) {
    integer returncode;
    Opportunity opp = [
      SELECT name, accountid, stagename, type, amount
      FROM opportunity
      WHERE id = :i
    ];

    //String jsonS = JSON.serialize(opp);

    try {
      JSONGenerator gen = JSON.createGenerator(true);

      gen.writeStartObject();

      gen.writeStringField('Name ', opp.name);
      gen.writeStringField('Accountid', opp.accountid);
      gen.writeStringField('Stage ', opp.StageName);
      gen.writeStringField('type ', opp.type);
      gen.writeStringField('amount', String.valueOf(opp.Amount));
 
      gen.writeEndObject();

      String jsonS = gen.getAsString();

      System.debug('jsonS string' + jsonS);

      Http http = new Http();

      HttpRequest request = new HttpRequest();
      request.setEndpoint('https://project4.free.beeceptor.com/project4');
      request.setMethod('POST');
      request.setHeader('Content-Type', 'application/json;charset=UTF-8');
      request.setBody(jsonS); 

      HttpResponse response = http.send(request);
      system.debug(response.getStatusCode());

      returncode = response.getStatusCode();

      if (response.getStatusCode() == 200) {
        System.debug(response.getBody());

        opp.Integration_Status__c = 'Success';
        opp.Integration_Comments__c = 'Success';
        update opp;
      }
    } catch (Exception e) {
      System.debug(
        'The status code returned was not expected: ' + e.getMessage()
      );

      opp.Integration_Comments__c = 'Failure';
      update opp;
    }

    return returncode;
  }
}
