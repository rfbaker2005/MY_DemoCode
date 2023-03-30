/***
 * Widgets Are Us, Inc.
 * Copyright (c) 2023
 *
 * @author      Rick Baker
 * @Description This LWC is a demontration of subscibing to a platform event subject
 *              and displaying the results of that event.  In this demonstration, we
 *              "Google Translate" event, that will be dispatched from Apex after it
 *              performs a REST call to retrieve supported language Ids from the
 *              service.
 */
import { LightningElement, api, track } from 'lwc';
import { subscribe, unsubscribe, onError, setDebugFlag, isEmpEnabled } from 'lightning/empApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class DemoPlatformEvent extends LightningElement {

    @api   channelName = '/event/Google_Translate_Languages__e';

    languageIds  = undefined;
    subscription = {};

    test = 'This is a bloomin test!!!';

    connectedCallback() {
        // Register error listener
        this.registerErrorListener();
        this.handleSubscribe();
    }

    // Handles subscribe button click
    handleSubscribe() {
        // Callback invoked whenever a new event is received
        const self = this;
        const messageCallback = function (response) {

            console.log('DEBUG.01.1.1 New response received 1: ', JSON.stringify(response));

            console.log('DEBUG.01.1.2 New response received 2: ', response);

            var obj = JSON.parse(JSON.stringify(response));

            console.log('DEBUG.01.2.1 payload: ' + obj.data.payload);
            console.log('DEBUG.01.2.2 self.channelName: ' + self.channelName);

            let objData = obj.data.payload;

            console.log('DEBUG.01.3.1 objData: ' + JSON.stringify(objData));

            self.languageIds = objData.Language_Ids__c;
        };

        // Invoke subscribe method of empApi. Pass reference to messageCallback
        subscribe(this.channelName, -1, messageCallback).then(response => {
            // Response contains the subscription information on subscribe call
            console.log('DEBUG.01.4.1 Subscription request sent to: ', JSON.stringify(response.channel));
            this.subscription = response;
        });
    }

    // handle Error
    registerErrorListener() {
        onError(error => {
            console.log('DEBUG.02.1.1 Received error from server: ', JSON.stringify(error));
        });
    }
}