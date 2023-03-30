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
import   createAccount from '@salesforce/apex/DemoCRUDController.createAccount';

export default class demoCRUDCreate extends LightningElement {

    @track isShowModal  = false;

    @track accountName;
    @track description;
    @track billingStreet;
    @track billingCity;
    @track billingState;
    @track billingZip;
    @track billingCountry;

    @api
    showModalBox () {

        this.accountName     = undefined;
        this.description     = undefined;
        this.billingStreet   = undefined;
        this.billingCity     = undefined;
        this.billingState    = undefined;
        this.billingZip      = undefined;
        this.billingCountry  = undefined;

        this.isShowModal = true;
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

    saveRecord (event) {

        console.log('DEBUG.demoCRUDCreate.01.1.1 ...');

        let testFieldVal = this.template.querySelector("lightning-input[name='AccountName']");
        // let testFieldVal = this.template.querySelector(".AccountName");

        console.log('DEBUG.demoCRUDCreate.01.1.2 testFieldVal: ' + testFieldVal);

        createAccount ({    accountName:    this.accountName,
                            description:    this.description,
                            billingStreet:  this.billingStreet,
                            billingCity:    this.billingCity,
                            billingState:   this.billingState,
                            billingZip:     this.billingZip,
                            billingCountry: this.billingCountry})
        .then(results => {

            this.isShowModal = false;

        }).catch(error => {

            this.isShowModal = false;
        });
    }

    handleFieldChange (event) {

        this.accountName = (event == undefined ? '' : event.target.value);
    }
}