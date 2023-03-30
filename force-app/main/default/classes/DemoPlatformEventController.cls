/***
 * Widgets Are Us, Inc.
 * Copyright (c) 2023
 *
 * @author      Rick Baker
 * @Description This class is the controller for the demoPlatformEvent LWC, which will
 *              dispatch an event that will contain the language Ids that are supported
 *              by the Google Translate service.
 *
 * To test, run this command in an anonymous window:
 *
 *    DemoPlatformEventController.publishGoogleTranslateLanguages();
 */
public with sharing class DemoPlatformEventController {

    /***
     * Publishes the Google_Translate_Languages__e event with the language Ids that are
     * supported by the Google Translate service.
     */
    public static void publishGoogleTranslateLanguages () {

        publishGoogleTranslateLanguages (null);
    }

    /***
     * Publishes the Google_Translate_Languages__e event with the language Ids that are
     * supported by the Google Translate service.
     *
     * @prefix - The prefix that will be prepended before any language Ids, if it exists.
     */
    public static void publishGoogleTranslateLanguages (String prefix) {

        List<String> languageIds = DemoRestApi.getLanguageIds();

        System.debug('DemoPlatformEventController.publishGoogleTranslateLanguages.01.1.1 languageIds: '+languageIds+']');

        Google_Translate_Languages__e theEvent = new Google_Translate_Languages__e ();

        theEvent.Language_Ids__c = String.join(languageIds, ',');

        if (String.isNotEmpty(prefix)) {

            theEvent.Language_Ids__c = prefix + ': ' + theEvent.Language_Ids__c;
        }

        System.debug('DemoPlatformEventController.publishGoogleTranslateLanguages.01.1.2 theEvent.Language_Ids__c: '+theEvent.Language_Ids__c+']');

        // Publish the platform event
        Database.SaveResult result = EventBus.publish(theEvent);

        if (result.isSuccess()) {

            System.debug('DemoPlatformEventController.publishGoogleTranslateLanguages.01.1.3 theEvent.Language_Ids__c: '+theEvent.Language_Ids__c+']');

        } else {

            for(Database.Error err : result.getErrors()) {

                final String errorMessage = String.format('Error: {0} - {1}', new String[] {String.valueOf(err.getStatusCode()), err.getMessage()});
                System.debug('DemoPlatformEventController.publishGoogleTranslateLanguages.01.1.4 Error: '+errorMessage+']');
            }
        }
    }
}