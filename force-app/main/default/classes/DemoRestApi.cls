/***
 * Widgets Are Us, Inc.
 * Copyright (c) 2023
 *
 * @author      Rick Baker
 * @Description This class is the Apex controller for the Rest Api demo.
 */
public with sharing class DemoRestApi {

    public static DemoRestApi Instance {
        get {
            if (Instance == NULL) {
                Instance = new DemoRestApi();
            }
            return Instance;
        }
        set;
    }

    //
    // ========== Class Methods =================================================================
    //

    /***
      * @Description  This method pulls a list of language identifiers from the Google Translate Api.
      *
      * @return The list of language identifiers
      */
    @AuraEnabled
    public static List<String> getLanguageIds () {

        return Instance.fetchLanguageIds ();
    }

    //
    // ========== Instance Methods =================================================================
    //

    /***
      * @Description  This method pulls a list of language identifiers from the Google Translate Api
      *               using the REST GET method.
      *
      * @return The list of language identifiers
      */
    private List<String> fetchLanguageIds () {

        List<String> languageIds = new List<String> ();

        // Fetch the list of language identifiers
        Http        http    = new Http();
        HttpRequest request = new HttpRequest();

        request.setEndpoint('https://google-translate1.p.rapidapi.com/language/translate/v2/languages');

        request.setHeader('User-Agent',      'PostmanRuntime/7.31.0');
        request.setHeader('Accept',          '*/*');
        request.setHeader('Accept-Encoding', 'gzip, deflate, br');
        request.setHeader('Connection',      'keep-alive');
        request.setHeader('X-RapidAPI-Key',  '3eb16c44d7msh60f9f5c6a8feec0p1d6db4jsn32092a5c8cf5');
        request.setHeader('X-RapidAPI-Host', 'google-translate1.p.rapidapi.com');

        request.setMethod('GET');

        // Pull language identifiers from the Google Translate API
        HttpResponse response = http.send(request);

        String serializedStr = String.valueOf(response.getBody());

        System.debug('DemoRestApi.fetchLanguageIds.01.1.1: '+response+']');
        System.debug('DemoRestApi.fetchLanguageIds.01.1.2: '+response.getBody()+']');
        System.debug('DemoRestApi.fetchLanguageIds.01.1.3: '+serializedStr+']');

        serializedStr = serializedStr.remove('"data":{"languages":[').remove(']').remove('"').remove('{').remove('}').remove('language:');

        System.debug('DemoRestApi.fetchLanguageIds.01.1.4: '+serializedStr+']');

        for (String language : serializedStr.split(',')) {

            languageIds.add(language); // Take only the first two characters of the language value
        }

        languageIds.sort();

        return languageIds;
    }
}