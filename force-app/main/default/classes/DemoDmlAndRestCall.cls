/***
 * Widgets Are Us, Inc.
 * Copyright (c) 2023
 *
 * @author      Rick Baker
 * @Description This class is the controller for demontrating how to perform a Dml
 *              operation and subsequently perform a REST callout.  Salesforce does
 *              not support a callout after a Dml operation in the same execution
 *              context; therefore, after a Dml operation, the REST callout must be
 *              performed in a separate execution context, namely, an asynchronous
 *              thread.  This demo uses an Apex Queuable Job to accomplish the REST
 *              callout and, in this example, the callout will query the Google Translate
 *              service for the Ids of the supported languages and send them to an LWC
 *              to display the results.  Before the REST callout is performed, the Dml
 *              operation will be the updating of a Contact.
 *
 * To test, run this command in an anonymous window:
 *
 *    DemoPlatformEventController.publishGoogleTranslateLanguages();
 */
public with sharing class DemoDmlAndRestCall {

    /***
     * Uses the contactId parameter to retrieve the the Name of the contact and then
     * performs the REST callout in an Apex Queueable Job.
     *
     * @contactId - The Id that identifies the contact whose name will be displayed
     *              in the REST call along with the supported Google Translate
     *              language Ids.
     */
    public static void demoDmlAndRestCall (Id contactId) {

        System.assertNotEquals(null, contactId);

        System.debug('DemoDmlAndRestCall.demoDmlAndRestCall.01.1.1 contactId: ' + contactId);

        final List<Contact> contacts = [SELECT Name FROM Contact WHERE Id = :contactId];

        System.assertNotEquals(null, contacts);
        System.assertEquals(true, contacts.size() == 1);

        final Contact theContact  = contacts[0];
        final String  contactName = theContact.Name;

        System.debug('DemoDmlAndRestCall.demoDmlAndRestCall.01.1.2 contactName: ' + contactName);

        AsyncThread newThread = new AsyncThread (contactName);

        System.enqueueJob(newThread);
    }

    /***
     * NOTE: In order for an Apex Queueable Job to perform a callout, the class must include
     * this in the class definition: Database.AllowsCallouts
     */
    private class AsyncThread implements Queueable, Database.AllowsCallouts {

        public String contactName {get; set;}

        public AsyncThread() {
        }

        public AsyncThread(String contactName) {

            System.assertNotEquals(null, contactName);
            System.assertEquals(false, String.isEmpty(contactName));

            System.debug('DemoDmlAndRestCall.AsyncThread.AsyncThread.01.1.1 contactName: ' + contactName);

            this.contactName = contactName;
        }

        public void execute(QueueableContext context) {

            System.debug('DemoDmlAndRestCall.AsyncThread.execute.01.1.1 we are running in a new thread...');

            DemoPlatformEventController.publishGoogleTranslateLanguages(contactName);
        }
    }
}