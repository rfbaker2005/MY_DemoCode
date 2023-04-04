/***
 * Widgets Are Us, Inc.
 * Copyright (c) 2023
 *
 * @author      Rick Baker
 * @Description This Lightning Web Component (LWC) is for demonstrating HTML and Javascript code that performs
 *              CRUD operations on the Salesforce platform. The LWC will showcase these CRUD operations in the
 *              form of a table and other auxiliary components that will present a list of accounts in a table.
 */
import { LightningElement, api, track, wire } from 'lwc';
import { subscribe, unsubscribe, onError }    from 'lightning/empApi';
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex  }    from '@salesforce/apex';
import { updateRecord }    from 'lightning/uiRecordApi';
import   getAccounts       from '@salesforce/apex/DemoCRUDController.getAccounts';
import   deleteAccounts    from '@salesforce/apex/DemoCRUDController.deleteAccounts';
import   LightningConfirm  from 'lightning/confirm';

// Define row actions
const actions = [
    { label: 'View',   name: 'view' },
    { label: 'Edit',   name: 'edit' },
    { label: 'Delete', name: 'delete' }
];

// Define columns
const columns = [
    { label: 'Name',                fieldName: 'Name',              sortable: true, type: 'text', editable: true },
    { label: 'Description',         fieldName: 'Description',       sortable: true, type: 'text', editable: false },
    { label: 'Billing Street',      fieldName: 'BillingStreet',     sortable: true, type: 'text', editable: true },
    { label: 'Billing City',        fieldName: 'BillingCity',       sortable: true, type: 'text', editable: true },
    { label: 'Billing State',       fieldName: 'BillingState',      sortable: true, type: 'text', editable: true },
    { label: 'Billing Postal Code', fieldName: 'BillingPostalCode', sortable: true, type: 'text', editable: true },
    { label: 'Billing Country',     fieldName: 'BillingCountry',    sortable: true, type: 'text', editable: true },
    {
        type: 'action',
        typeAttributes: {
            rowActions: actions,
            menuAlignment: 'right'
        }
    }
];

export default class demoCRUDTable extends NavigationMixin(LightningElement) {

    @api channelName            = '/event/RefreshDataTable__e';
    @api searchKey              = '';
    @api sortDirection          = 'ASC';
    @api sortBy                 = 'Name';
    @track columns              = columns;
    @track rowOffset            = 0;
    @track nameFilter           = ''
    @track items                = [];
    @track totalRecountCount    = 0;
    @track totalPage            = 0;
    @track endingRecord         = 0;
    recordId                    = undefined;
    showSpinner                 = false;
    error                       = '';
    tableData                   = [];
    draftValues                 = [];

    connectedCallback () {

        // Subscribe to the platform event for refreshing data in the datatable component.
        // The handlePlatformEvent function is the callback function that will be called
        // when this platform event is received.
        subscribe(this.channelName, -1, this.handlePlatformEvent).then(response => {

            console.log('DEBUG.demoCRUDTable.connectedCallback.01.1.1 Successfully subscribed to channel');

            this.subscription = response;
        });

        onError(error => {

            console.error('DEBUG.demoCRUDTable.connectedCallback.01.1.2 Received error from server: ', error);
        });
    }

    disconnectedCallback () {

        // Unsubscribe from the platform event for refreshing data in the datatable component.
        unsubscribe(this.subscription, () => {

            console.log('DEBUG.demoCRUDTable.disconnectedCallback.01.1 Successfully unsubscribed...');
        });
    }

    // Retrieving accounts using wire service
    @wire (getAccounts, { searchKey: '$searchKey', sortBy: '$sortBy', sortDirection: '$sortDirection' })
        wiredAccounts ({ error, data }) {

        console.error('DEBUG.demoCRUDTable.@wire getAccounts.01.1. data: ' + JSON.stringify(data));

        this.loader = true;

        if (data) {

            this.tableData  = data;
            this.loader     = false;
            this.error      = undefined;
            this.processRecords (this.tableData);

        } else if (error) {

            this.loader     = false;
            this.error      = error;
            this.tableData  = undefined;
        }
    }

    processRecords (data) {

        console.error('DEBUG.demoCRUDTable.processRecords.01.1.1 data: ' + JSON.stringify(data));

        this.items              = data;
        this.totalRecountCount  = data.length;
        this.totalPage          = Math.ceil (this.totalRecountCount / this.pageSize);
        this.tableData          = this.items.slice (0, this.pageSize);
        this.endingRecord       = this.pageSize;
        this.columns            = columns;
    }

    handlePlatformEvent = event => {

        console.error('DEBUG.demoCRUDTable.handlePlatformEvent.01.1.1 Received platform event from server: ' + JSON.stringify(event));

        const refreshRecordEvent = event.data.payload;

        console.error('DEBUG.demoCRUDTable.handlePlatformEvent.01.1.2 refreshRecordEvent: ' + JSON.stringify(refreshRecordEvent));

        if (refreshRecordEvent.RecordId__c === this.recordId) {

            this.recordId = '';

            return refreshApex(this.refreshTable);
        }
    }

    handleRowActions(event) {

        const actionName    = event.detail.action.name;
        const row           = event.detail.row;
        this.recordId       = row.Id;

        switch (actionName) {
            case 'view':
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: row.Id,
                        actionName: 'view'
                    }
                });
                break;
            case 'edit':
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: row.Id,
                        objectApiName: 'Account',
                        actionName: 'edit'
                    }
                });
                break;
            // case 'delete':
            //     this.delAccount(row);
            //     break;
        }
    }

    handleSortColumns (event) {

        this.sortBy           = event.detail.fieldName;
        this.sortDirection    = event.detail.sortDirection;

        return refreshApex (this.result);
    }

    async handleConfirmDelete (event) {

        console.log('DEBUG.demoCRUDTable.handleConfirmClick.01.1.1 event: '+ JSON.stringify(event));

        const result = await LightningConfirm.open ({
            message: 'Delete Selected Account(s)?',
            variant: 'headerless',
            label: 'Delete Selected Account(s)?',
        });

        console.log('DEBUG.demoCRUDTable.handleConfirmClick.01.2.1 OK result: '+ result);

        if (result=== true) {

            console.log('DEBUG.demoCRUDTable.handleConfirmClick.01.3.1 OK result: '+ result);

            this.deleteSelectedAccounts();

            console.log('DEBUG.demoCRUDTable.handleConfirmClick.01.3.2 OK result: '+ result);

        } else {

            console.log('DEBUG.demoCRUDTable.handleConfirmClick.01.4.1 Cancel result: '+ result);
        }
    }

    deleteSelectedAccounts () {

        let selectedAccounts = this.template.querySelector("lightning-datatable").getSelectedRows();

        console.log('DEBUG.demoCRUDTable.handleDeleteSelectedAccounts.01.1.1 selectedAccounts: '+ JSON.stringify(selectedAccounts));

        deleteAccounts({accounts: selectedAccounts})
        .then(result => {

            console.log('DEBUG.demoCRUDTable.handleDeleteSelectedAccounts.01.2.1 result: '+ JSON.stringify(result));
        })
        .catch(error => {

            console.log('DEBUG.demoCRUDTable.handleDeleteSelectedAccounts.01.3.1 this.error: '+ JSON.stringify(error));
        });
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
     * Called whenever the user types a character into the
     */
    handleKeyChange (event) {

        console.log('DEBUG.demoCRUDTable.handleKeyChange.01.1.1 event: ['+JSON.stringify(event)+']');

        this.searchKey  = event.target.value;
        var data        = [];

        console.log('DEBUG.demoCRUDTable.handleKeyChange.01.1.2 this.searchKey: ['+this.searchKey+']');

        for (var i = 0; i < this.items.length; i++) {

            if (this.items[i] != undefined && this.items[i].Name.includes (this.searchKey)) {

                data.push (this.items[i]);

                console.log('DEBUG.demoCRUDTable.handleKeyChange.01.2.1 data: ['+data+']');
            }
        }

        console.log('DEBUG.demoCRUDTable.handleKeyChange.01.3.1 data: ['+data+']');

        this.processRecords (data);
    }

    /***
     * Performs the heavy lifting of retrieving accounts
     */
    retrieveAccountsLike (accountFilter) {

        if (accountFilter == undefined) {

            getAccounts({ searchKey: this.searchKey, sortBy: this.sortBy, sortDirection: this.sortDirection })
            .then(result => {

                console.log('DEBUG.demoCRUDTable.retrieveAccountsLike.01.1.1 result: '+ result);

                this.tableData = result;
            })
            .catch(error => {
                this.error = error;
            });
        }
    }

    handleAddNewAccount (event) {

        console.log('DEBUG.demoCRUDTable.handleAddNewAccount.01.1.1 event: '+ JSON.stringify(event));

        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: undefined,
                actionName: 'new'
            }
        });

        // let childLWC = this.template.querySelector('c-demo-c-r-u-d-create');

        // console.log('DEBUG.demoCRUDTable.handleAddNewAccount.01.1.2 childLWC: '+ JSON.stringify(childLWC));

        // childLWC.showModalBox('My Test Name');
    }

    /***
     * Called when the contents of a table row cell is changed.
     */
    async handleOnCellChange (event) {

        console.log('DEBUG.demoCRUDTable.handleOnCellChange.01.1.1 event: '+ JSON.stringify(event));

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