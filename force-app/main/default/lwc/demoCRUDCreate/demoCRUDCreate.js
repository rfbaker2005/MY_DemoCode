/***
 * Widgets Are Us, Inc.
 * Copyright (c) 2023
 *
 * @author      Rick Baker
 * @Description This Lightning Web Component (LWC) is for demonstrating HTML and Javascript code that performs
 *              CRUD operations on the Salesforce platform. This component serves as a dialog to enter field
 *              values to create an account.
 */
import { LightningElement, api, track } from 'lwc';
import { createRecord   } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import   ACCOUNT_OBJECT   from '@salesforce/schema/Account';
import   NAME_FIELD       from '@salesforce/schema/Account.Name';
import   BA_STREET_FIELD  from '@salesforce/schema/Account.BillingStreet';
import   BA_CITY_FIELD    from '@salesforce/schema/Account.BillingCity';
import   BA_STATE_FIELD   from '@salesforce/schema/Account.BillingState';
import   BA_ZIP_FIELD     from '@salesforce/schema/Account.BillingPostalCode';
import   BA_COUNTRY_FIELD from '@salesforce/schema/Account.BillingCountry';
import   BA_DESC_FIELD    from '@salesforce/schema/Account.Description';

export default class demoCRUDCreate extends LightningElement {

    isShowModal = false;
    accountId   = undefined;

    @track accountName;
    @track description;
    @track billingStreet;
    @track billingCity;
    @track billingState;
    @track billingZip;
    @track billingCountry;

    @api
    showModalBox () {

        this.accountName    = undefined;
        this.description    = undefined;
        this.billingStreet  = undefined;
        this.billingCity    = undefined;
        this.billingState   = undefined;
        this.billingZip     = undefined;
        this.billingCountry = undefined;

        this.isShowModal    = true;
    }

    @api
    hideModalBox () {

        this.isShowModal = false;
    }

    handleChangeAccountName (event) {
        this.accountName = event.target.value;
    }

    handleChangeDescription (event) {
        this.description = event.target.value;
    }

    handleChangeAccountBillingStreet (event) {
        this.billingStreet = event.target.value;
    }

    handleChangeAccountBillingCity (event) {
        this.billingCity = event.target.value;
    }

    handleChangeAccountBillingState (event) {
        this.billingState = event.target.value;
    }

    handleChangeAccountBillingZip (event) {
        this.billingZip = event.target.value;
    }

    handleChangeAccountBillingCountry (event) {
        this.billingCountry = event.target.value;
    }

    createAccount () {

        const fields = {};

        fields[NAME_FIELD.fieldApiName]       = this.accountName;
        fields[BA_STREET_FIELD.fieldApiName]  = this.billingStreet;
        fields[BA_CITY_FIELD.fieldApiName]    = this.billingCity;
        fields[BA_STATE_FIELD.fieldApiName]   = this.billingState;
        fields[BA_ZIP_FIELD.fieldApiName]     = this.billingZip;
        fields[BA_COUNTRY_FIELD.fieldApiName] = this.billingCountry;
        fields[BA_DESC_FIELD.fieldApiName]    = this.description;

        console.log('DEBUG.demoCRUDCreate.01.1.1 fields: ' + fields);

        const recordInput = { apiName: ACCOUNT_OBJECT.objectApiName, fields };

        createRecord(recordInput)
        .then(account => {

            console.log('DEBUG.demoCRUDCreate.01.2.1 account: ' + JSON.stringify(account));

            this.isShowModal = false;
            this.accountId   = account.id;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Account created',
                    variant: 'success',
                }),
            );
        })
        .catch(error => {

            console.log('DEBUG.demoCRUDCreate.01.3.1 error: ' + JSON.stringify(error));

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error creating record',
                    message: error.body.message,
                    variant: 'error',
                }),
            );
        });
    }
}