/***
 * Rakuten
 * Copyright (c) 2023
 *
 * @author       Rick Baker
 * @Description  This class provides code coverage and unit testing for the DemoRestApi class.
 */
@isTest
private class DemoRestApiTest {

    private static final Integer ExpectedCode     = 200;
    private static final String  ExpectedStatus   = 'OK';
    private static final String  MockResponseBody = '"data":{"languages":['+
                                                           '{"language":"af"},{"language":"ak"},{"language":"am"},{"language":"ar"},'+
                                                           '{"language":"as"},{"language":"ay"},{"language":"az"},{"language":"be"},{"language":"bg"},'+
                                                           '{"language":"bho"},{"language":"bm"},{"language":"bn"},{"language":"bs"},{"language":"ca"},'+
                                                           '{"language":"ceb"},{"language":"ckb"},{"language":"co"},{"language":"cs"},{"language":"cy"}';

    private static final Map<String, String> HeadersMap = new Map<String, String> {

        'User-Agent'      => 'PostmanRuntime/7.31.0',
        'Accept'          => '*/*',
        'Accept-Encoding' => 'gzip, deflate, br',
        'Connection'      => 'keep-alive',
        'X-RapidAPI-Key'  => '3eb16c44d7msh60f9f5c6a8feec0p1d6db4jsn32092a5c8cf5',
        'X-RapidAPI-Host' => 'google-translate1.p.rapidapi.com'
    };

    @isTest
    private static void testGetLanguageIds () {

        HttpMockFactory mock = new HttpMockFactory (ExpectedCode, ExpectedStatus, MockResponseBody, HeadersMap);

        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();

        List<String> languageOptionsFrom = DemoRestApi.getLanguageIds ();

        Test.stopTest();

        System.assertNotEquals(NULL, languageOptionsFrom);
        System.assert(!languageOptionsFrom.isEmpty());
    }
}