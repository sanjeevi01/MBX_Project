@isTest
global class MockRes implements HttpCalloutMock {
  global HTTPResponse respond(HTTPRequest request) {
    // System.assertEquals('https://project4.free.beeceptor.com/project4', request.getEndpoint());
    // System.assertEquals('POST', request.getMethod());

    HttpResponse response = new HttpResponse();
    response.setHeader('Content-Type', 'application/json');
    response.setStatusCode(200);
    return response;
  }
}
