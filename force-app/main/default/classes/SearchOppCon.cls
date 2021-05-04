public with sharing class SearchOppCon {
    @AuraEnabled(cacheable=true)
    public static list<Opportunity> findOpp(String s, String fieldName){

        List<Opportunity> opp = new List<Opportunity>();
            String searchword = '%'+ s +'%';
    
           if(fieldName=='Name' ){
                opp=[select id, name, AccountId, Account_Name__c, stagename,type,amount from opportunity where name like:searchword];
                system.debug(opp);
            }
            else if(fieldName=='Account Name'){
                opp=[select id,name,AccountId,Account_Name__c,stagename,type,amount from opportunity where account.name like:searchword];
                system.debug(opp);
            }
            else if(fieldName=='Stage Name'){
                opp=[select id,name,AccountId,Account_Name__c,stagename,type,amount from opportunity where stagename like:searchword];
                system.debug(opp);
            }
            else if(fieldName=='Type'){
                opp=[select id,name,accountId,Account_Name__c,stagename,type,amount from opportunity where type like:searchword];
                system.debug(opp);
            }
            else if(fieldName=='Amount'){
                Integer a=Integer.valueOf(s);
                opp=[select id,name,AccountId,Account_Name__c,stagename,type,amount from opportunity where amount =:a];
                system.debug(opp);
            }
            else if(fieldName=='Select' || fieldName==null ){
                opp=[select id, name, AccountId, Account_Name__c, stagename,type,amount from opportunity where (name like:searchword) OR (stageName like:searchword) OR (type like:searchword) or (Account_Name__c like:searchword) ];
                system.debug(opp);
            }
            return opp;

    }
}
