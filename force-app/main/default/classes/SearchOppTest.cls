@isTest
public with sharing class SearchOppTest {
  @isTest
  static void sarchOppTestMethod1() {
    Account acc = new Account(name = 'Search Opportunity-Account');
    insert acc;

    Opportunity opp1 = new Opportunity();
    opp1.name = 'Search Opportunity-Opportunity';
    opp1.AccountId = acc.Id;
    opp1.StageName = 'Prospecting';
    opp1.Type = 'New-Customer';
    opp1.Amount = 70000;
    opp1.CloseDate = date.today();
    opp1.Integration_Status__c = 'Success';
    insert opp1;

    Test.startTest();

    //Set mock callout class
    Test.setMock(HttpCalloutMock.class, new MockRes());
    //This cause a fake response to send from the class that implements the HttpMockCallout

    Integer n = SearchOppHttpCallout.postOpp(opp1.Id);

    Test.stopTest();

    System.assertEquals(200, n);
  }

  @isTest
  static void sarchOppTestMethod2() {
    Account acc = new Account(name = 'Search Opportunity-Account1');
    insert acc;

    Opportunity opp2 = new Opportunity();
    opp2.name = 'Search Opportunity-Opportunity1';
    opp2.AccountId = acc.Id;
    opp2.StageName = 'Prospecting';
    opp2.Type = 'New-Customer';
    opp2.CloseDate = date.today();
    opp2.Integration_Status__c = 'Success';
    insert opp2;

    Test.startTest();

    Test.setMock(HttpCalloutMock.class, new MockRes());
    Integer n1 = SearchOppHttpCallout.postOpp(opp2.Id);

    Test.stopTest();

    System.assertEquals(null, n1);
  }

  @isTest
  static void sarchOppConTest() {
    Account acc = new Account(name = 'Search Opportunity-Account1');
    insert acc;

    Opportunity opp3 = new Opportunity();
    opp3.name = 'Search Opportunity';
    opp3.AccountId = acc.Id;
    opp3.StageName = 'Prospecting';
    opp3.Type = 'New-Customer';
    opp3.CloseDate = date.today();
    opp3.Amount = 70000;
    opp3.Integration_Status__c = 'Success';
    insert opp3;

    Test.startTest();

    List<Opportunity> oppList1 = SearchOppCon.findOpp('Opportunity', 'Name');
    List<Opportunity> oppList2 = SearchOppCon.findOpp('Search Opportunity-Account1', 'Account Name');
    List<Opportunity> oppList3 = SearchOppCon.findOpp('Prospecting','Stage Name');
    List<Opportunity> oppList4 = SearchOppCon.findOpp('New-Customer', 'Type');
    List<Opportunity> oppList5 = SearchOppCon.findOpp('70000', 'Amount');
    List<Opportunity> oppList6 = SearchOppCon.findOpp('Opportunity', null);

    Test.stopTest();

    System.assertEquals(oppList1[0].name, 'Search Opportunity');
    System.assertEquals(oppList2[0].AccountId, acc.Id);
    System.assertEquals(oppList3[0].StageName, 'Prospecting');
    System.assertEquals(oppList4[0].Type, 'New-Customer');
    System.assertEquals(oppList5[0].Amount, 70000);
    System.assertEquals(oppList6[0].name, 'Search Opportunity');
  }
}
