public with sharing class SearchOppCon {
  @AuraEnabled(cacheable=true)
  public static list<Opportunity> findOpp(String s, String fieldName) {
    List<Opportunity> opp = new List<Opportunity>();

    String searchword = '%' + s + '%';

          if (fieldName == 'Name') {
            opp = [
              SELECT id, name, AccountId, Account_Name__c, stagename, type, amount
              FROM opportunity
              WHERE name LIKE :searchword
            ];
          } 
          else if (fieldName == 'Account Name') {
            opp = [
              SELECT id, name, AccountId, Account_Name__c, stagename, type, amount
              FROM opportunity
              WHERE account.name LIKE :searchword
            ];
          } 
          else if (fieldName == 'Stage Name') {
            opp = [
              SELECT id, name, AccountId, Account_Name__c, stagename, type, amount
              FROM opportunity
              WHERE stagename LIKE :searchword
            ];
          }
          else if (fieldName == 'Type') {
            opp = [
              SELECT id, name, accountId, Account_Name__c, stagename, type, amount
              FROM opportunity
              WHERE type LIKE :searchword
            ];
          } 
          else if (fieldName == 'Amount') {
            Integer a = Integer.valueOf(s);
            opp = [
              SELECT id, name, AccountId, Account_Name__c, stagename, type, amount
              FROM opportunity
              WHERE amount = :a
            ];
          } 
          else if (fieldName == 'Select' || fieldName == null) {
            opp = [
              SELECT id, name, AccountId, Account_Name__c, stagename, type, amount
              FROM opportunity
              WHERE
                name LIKE :searchword
                OR stageName LIKE :searchword
                OR type LIKE :searchword
                OR Account_Name__c LIKE :searchword
            ];
          }
    return opp;
  }
}
