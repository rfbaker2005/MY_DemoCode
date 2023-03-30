/***
 * Widgets Are Us, Inc.
 * Copyright (c) 2023
 *
 * @author      Rick Baker
 * @Description This Lightning Web Component (LWC) is for demonstrating HTML and Javascript code that performs
 *              CRUD operations on the Salesforce platform. The LWC will showcase these CRUD operations in the
 *              form of a table and other auxiliary components that will present a list of accounts in a table.
 */
import { LightningElement, track } from 'lwc';
import { refreshApex  }   from '@salesforce/apex';
import { updateRecord }   from 'lightning/uiRecordApi';
import   getAccountsLike  from '@salesforce/apex/DemoCRUDController.retrieveAccountsLike';
import   getAllAccounts   from '@salesforce/apex/DemoCRUDController.retrieveAccounts';
import   LightningConfirm from 'lightning/confirm';

const columns = [
    { label: 'Name',                fieldName: 'Name',              type: 'text', editable: false },
    { label: 'Description',         fieldName: 'Description',       type: 'text', editable: false },
    { label: 'Billing Street',      fieldName: 'BillingStreet',     type: 'text', editable: false },
    { label: 'Billing City',        fieldName: 'BillingCity',       type: 'text', editable: false },
    { label: 'Billing State',       fieldName: 'BillingState',      type: 'text', editable: false },
    { label: 'Billing Postal Code', fieldName: 'BillingPostalCode', type: 'text', editable: false },
    { label: 'Billing Country',     fieldName: 'BillingCountry',    type: 'text', editable: false },
];

export default class demoCRUDTable extends LightningElement {

    @track columns    = columns;
    @track rowOffset  = 0;
    @track nameFilter = ''
    error             = '';
    tableData         = [];
    draftValues       = [];

    connectedCallback() {

        this.handleRetrieveAccountsLike (undefined);
    }

    async handleConfirmClick (event) {

        console.log('DEBUG.demoCRUDTable.handleConfirmClick.01.1.1 event: '+ JSON.stringify(event));

        const result = await LightningConfirm.open ({
            message: 'Delete the selected account(s)?',
            variant: 'headerless',
            label: 'Delete the selected account(s)?',
            // setting theme would have no effect
        });

        if (result.status === true) {

            console.log('DEBUG.demoCRUDTable.handleConfirmClick.01.1.2 OK clicked: '+ result);

        } else {

            console.log('DEBUG.demoCRUDTable.handleConfirmClick.01.1.3 Cancel clicked: '+ result);
        }
    }

    handleRetrieveAllAccounts (event) {

        this.handleRetrieveAccountsLike (undefined);
    }

    handleRetrieveAccountsLike (event) {

        console.log('DEBUG.demoCRUDTable.handleRetrieveAccountsLike.01.1.1 event: '+ JSON.stringify(event));

        this.nameFilter = (event == undefined ? '' : event.target.value);

        console.log('DEBUG.demoCRUDTable.handleRetrieveAccountsLike.1.2 this.nameFilter: '+ this.nameFilter);

        this.retrieveAccountsLike (this.nameFilter);
    }

    /***
     * Performs the heavy lifting of retrieving accounts
     */
    retrieveAccountsLike (accountFilter) {

        if (accountFilter == undefined) {

            getAllAccounts()
            .then(result => {

                console.log('DEBUG.demoCRUDTable.retrieveAccountsLike.01.1.1 result: '+ result);

                this.tableData = result;
            })
            .catch(error => {
                this.error = error;
            });

        } else {

            getAccountsLike({ filterString: accountFilter })
            .then(result => {

                console.log('DEBUG.demoCRUDTable.retrieveAccountsLike.01.1.2 result: '+ result);

                this.tableData = result;
            })
            .catch(error => {
                this.error = error;
            });
        }
    }

    handleAddNewAccount (event) {

        console.log('DEBUG.demoCRUDTable.handleAddNewAccount.01.1.1 event: '+ JSON.stringify(event));

        let childLWC = this.template.querySelector('c-demo-c-r-u-d-create');

        console.log('DEBUG.demoCRUDTable.handleAddNewAccount.01.1.2 childLWC: '+ JSON.stringify(childLWC));

        childLWC.showModalBox('My Test Name');
    }

    async handleOnCellChange (event) {

        // Convert datatable draft values into record objects
        const records = event.detail.draftValues.slice().map((draftValue) => {
            const fields = Object.assign({}, draftValue);
            return { fields };
        });

        // Display fresh data in the datatable
        await refreshApex(records);

        try {
            // Update all records in parallel thanks to the UI API
            const recordUpdatePromises = records.map((record) =>
                updateRecord(record)
            );
            await Promise.all(recordUpdatePromises);

            // Report success with a toast
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Account updated',
                    variant: 'success'
                })
            );

        } catch (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error updating or reloading accounts',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        }
    }
}