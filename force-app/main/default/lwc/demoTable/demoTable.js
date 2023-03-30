/***
 * Rakuten
 * Copyright (c) 2023
 *
 * @author       Rick Baker
 * @Description  This javascript file initializes a table of accouints that can be filtered by name pattern.
 *               The account Description field may be changed inline in the table.
 */
import { LightningElement, track } from 'lwc';
import { refreshApex  } from '@salesforce/apex';
import { updateRecord } from 'lightning/uiRecordApi';
import getAccounts      from '@salesforce/apex/DemoTableController.getAccounts';

const columns = [
    { label: 'Label', fieldName: 'Name', editable: false },
    { label: 'Label', fieldName: 'Description', type: 'text', editable: true },
];

export default class DemoTable extends LightningElement {

    @track columns    = columns;
    @track rowOffset  = 0;
    @track nameFilter = ''
    error             = '';
    tableData         = [];
    draftValues       = [];
    columns           = columns;

    connectedCallback() {
    }

    handleNameFilterChange(event) {

        this.nameFilter = event.target.value;
     }

    handleRetrieveAccountsLike (event) {

        getAccounts({ filterString: this.nameFilter })
            .then(result => {

                this.tableData = result;
            })
            .catch(error => {
                this.error = error;
            });
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