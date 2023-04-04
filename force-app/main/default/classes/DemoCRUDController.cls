/***
 * Widgets Are Us, Inc.
 * Copyright (c) 2023
 *
 * @author      Rick Baker
 * @Description This class is the controller for demonstrating Apex and LWC code that performs
 *              CRUD operations on the Salesforce platform. The class will showcase Apex and
 *              LWC code for creating an account, renaming the account, modify one or more fields
 *              in the account and delete the account.
 *
 *              The UI for this demo is the demoCRUDTabe Lightning Web Component.  To see this in
 *              action, embed this component on a page where it can be displayed.
 */
public with sharing class DemoCRUDController {

    public static DemoCRUDController Instance {
        get {
            if (Instance == null) {
                Instance = new DemoCRUDController();
            }
            return Instance;
        }
        set;
    }

    //
    // ========== Class Methods ==================================================
    //

    /***
     * This is the CRUD "Create" operation.  Creates and inserts a new account.
     *
     * @param accountName       - The name of the account to be created and inserted.
     * @param description       - The description of the account to be created and inserted.
     * @param billingStreet     - The billing street of the account to be created and inserted.
     * @param billingCity       - The billing city of the account to be created and inserted.
     * @param billingState      - The billing state of the account to be created and inserted.
     * @param billingZip        - The billing postal code of the account to be created and inserted.
     * @param billingCountry    - The billing country of the account to be created and inserted.
     *
     * @return The Id of the new account.
     */
    @AuraEnabled
    public static Id createAccount (
        String accountName,
        String description,
        String billingStreet,
        String billingCity,
        String billingState,
        String billingZip,
        String billingCountry) {

        System.debug('DemoCRUDController.createAccount.01.1.1 accountName: ' + accountName);

        return Instance.performCreateAccount(accountName, description, billingStreet, billingCity, billingState, billingZip, billingCountry);
    }

    /***
     * This is the CRUD "Read" operation.  Returns a list of accounts sorted by the sortBy field.
     *
     * @param searchKey     - The search pattern of the account name to retrieve.
     * @param sortBy        - The current field by which to sort.
     * @apram sortDirection - The direction of the sorted given the current sortBy field.
     *
     * @return The list of accounts sorted by the sortBy field.
     */
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts (String searchKey, String sortBy, String sortDirection) {

        return Instance.performGetAccounts(searchKey, sortBy, sortDirection);
    }

    /***
     * This is the CRUD "Update" operation.  Performs an update an account record.
     *
     * @param account - The account record to be updated.
     */
    @AuraEnabled
    public static void updateAccount(Account account) {

        Instance.performUpdateAccount(account);
    }

    /***
     * This is the CRUD "Delete" operation.  Perform a delete operation on one or more accounts.
     *
     * @param accounts - The list of accounts that will be deleted.
     */
    @AuraEnabled
    public static void deleteAccounts (List<Account> accounts) {

        Instance.performDeleteAccounts (accounts);
    }

    //
    // ========== Instance Methods ================================================
    //

    /***
     * Creates and inserts a new account.
     *
     * @param accountName       - The name of the account to be created and inserted.
     * @param description       - The description of the account to be created and inserted.
     * @param billingStreet     - The billing street of the account to be created and inserted.
     * @param billingCity       - The billing city of the account to be created and inserted.
     * @param billingState      - The billing state of the account to be created and inserted.
     * @param billingZip        - The billing postal code of the account to be created and inserted.
     * @param billingCountry    - The billing country of the account to be created and inserted.
     *
     * @return The Id of the new account.
     */
    private Id performCreateAccount (
        String accountName,
        String description,
        String billingStreet,
        String billingCity,
        String billingState,
        String billingZip,
        String billingCountry) {

        System.assertNotEquals  (null, accountName, 'Account must have a name.');
        System.assertEquals     (true, String.isNotEmpty(accountName));

        Account newAccount = new Account(   Name                = accountName,
                                            Description         = description,
                                            BillingStreet       = billingStreet,
                                            BillingCity         = billingCity,
                                            BillingState        = billingState,
                                            BillingPostalCode   = billingZip,
                                            BillingCountry      = billingCountry);

        insert newAccount;

        return newAccount.Id;
    }

    /***
     * This is the CRUD "Read" operation.  Returns a list of accounts sorted by the sortBy field.
     *
     * @param searchKey     - The search pattern of the account name to retrieve.
     * @param sortBy        - The current field by which to sort.
     * @apram sortDirection - The direction of the sorted given the current sortBy field.
     *
     * @return The list of accounts sorted by the sortBy field.
     */
    private List<Account> performGetAccounts (String searchKey, String sortBy, String sortDirection) {

        System.debug('DemoCRUDController.performGetAccounts.01.1 searchKey: ['+searchKey+'] sortBy: ['+sortBy+'] seasortDirectionrchKey: ['+sortDirection+']');

        String queryString = 'SELECT Name, Description, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry FROM Account';

        if (String.isNotEmpty(searchKey)) {

            String key = '%' + searchKey + '%';
            queryString += ' WHERE Name LIKE :key';
        }

        if (String.isNotEmpty(sortBy) && String.isNotEmpty(sortDirection)) {

            queryString += ' ORDER BY ' + sortBy + ' ' + sortDirection;
        }

        System.debug('DemoCRUDController.performGetAccounts.01.2 queryString: ['+queryString+']');

        List<Account> retrievedAccounts = Database.query(queryString);

        System.debug('DemoCRUDController.performGetAccounts.01.3 retrievedAccounts: ['+queryString+']');

        return retrievedAccounts;
    }

    /***
     * This is the CRUD "Update" operation.  Performs an update an account record.
     *
     * @param account - The account record to be updated.
     */
    private void performUpdateAccount (Account account) {

        System.assertNotEquals  (null, account);

        try {

            UnitTestUtil.forceExceptionInUnitTest();

            update account;

            // Tell the listening data table to refresh this record
            publishRefreshEvents (new List<Account> { account });

        } catch (Exception ex) {

            System.debug('DemoCRUDController.performUpdateAccount.01.1 Exception: ' + ex);

            throw new WidgetsAreUsException(ex);
        }
    }

    /***
     * This is the CRUD "Delete" operation.  Perform a delete operation on one or more accounts.
     *
     * @param accounts - The list of accounts that will be deleted.
     */
    private void performDeleteAccounts (List<Account> accounts) {

        System.assertNotEquals(null, accounts, 'The accountIds parameter must not be null.');

        try {

            UnitTestUtil.forceExceptionInUnitTest();

            if (!accounts.isEmpty()) {

                delete accounts;
            }

        } catch (Exception ex) {

            System.debug('DemoCRUDController.performDeleteAccounts.01.1 Exception: ' + ex);

            throw new WidgetsAreUsException(ex);
        }
    }

    //
    // ========== Supporting Logic ==================================================
    //

    /***
     * Publishes one or more Data Table Refresh Events to indicate to the subscriber that
     * the Lightning data table records (in this case, Accounts) need to be refreshed.
     *
     * @param accounts - The list of account records that need to be refreshed in the table.
     */
    private void publishRefreshEvents (List<Account> accounts) {

        System.assertNotEquals  (null, accounts);
        System.assertEquals     (false, accounts.isEmpty());

        List<RefreshDataTable__e> eventsToPublish = new List<RefreshDataTable__e> ();

        for (Account account : accounts) {

            eventsToPublish.add(new RefreshDataTable__e (RecordId__c = account.Id));
        }

        EventBus.publish(eventsToPublish);
    }
}