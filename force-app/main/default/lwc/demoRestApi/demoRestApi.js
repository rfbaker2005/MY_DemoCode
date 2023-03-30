/***
 * Widgets Are Us, Inc.
 * Copyright (c) 2023
 *
 * @author       Rick Baker
 * @Description  This javascript file initializes a list of language Ids that are pulled, via REST GET call,
 *               from the Google Translate site and displayed in a combo box.
 */
import { LightningElement } from 'lwc';
import getLanguageIds from '@salesforce/apex/DemoRestApi.getLanguageIds';

export default class DemoRestApi extends LightningElement {

    languageOptionsFrom  = [];
    languageOptionsTo    = [];
    selectedLanguageFrom = 'en';
    selectedLanguageTo   = 'de';

    /***
     * This function is called when Javascript loads the page.  Here, it initializes the list of language Ids
     * by calling the REST API in the demoRestApi.cls Apex class and populates both combo boxes for the language
     * to translate from and the language to translate to.
     */
    connectedCallback() {

        console.log('DEBUG.initializeLanguageIds.01.1.1');

        getLanguageIds ()
            .then(results => {

                console.log('DEBUG.initializeLanguageIds.01.2.1');
                // console.log('DEBUG.initializeLanguageIds.01.2.2 results: ['+JSON.stringify(results)+']');

                if (results) {

                    console.log('DEBUG.initializeLanguageIds.01.2.3.1 results has data...');

                    for(const element of results) {

                        console.log('DEBUG.initializeLanguageIds.01.2.3.3 option: ['+JSON.stringify(element)+']');

                        const option = {
                            label: element,
                            value: element
                        };

                        console.log('DEBUG.initializeLanguageIds.01.2.3.5 option: ['+JSON.stringify(option)+']');

                        this.languageOptionsFrom = [...this.languageOptionsFrom, option];
                        this.languageOptionsTo   = [...this.languageOptionsTo,   option];
                    }

                } else {

                    console.log('DEBUG.initializeLanguageIds.01.2.3.2 results has NO data...');
                }

                console.log('DEBUG.initializeLanguageIds.01.2.4 languageOptionsFrom: ['+JSON.stringify(languageOptionsFrom)+']');
            })
            .catch(error => {

                // console.log('DEBUG.initializeLanguageIds.01.3.1 error: ['+JSON.stringify(error)+']');
            });
    }

    /***
     * Handles the click event when user selects a language to translate text from.
     */
    handleLanguageChangeFrom (event) {

        this.selectedLanguageFrom = event.target.value;

        console.log('DEBUG.handleLanguageChangeFrom.01.1.2 event: ['+this.selectedLanguageFrom+']');
    }

    /***
     * Handles the click event when user selects a language to translate text to.
     */
    handleLanguageChangeTo (event) {

        this.selectedLanguageTo = event.target.value;

        console.log('DEBUG.handleLanguageChangeTo.01.1.1 event: ['+this.selectedLanguageTo+']');
    }
}