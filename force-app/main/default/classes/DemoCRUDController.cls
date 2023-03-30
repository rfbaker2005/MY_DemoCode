/***
 * Widgets Are Us, Inc.
 * Copyright (c) 2023
 *
 * @author      Rick Baker
 * @Description This class is the controller for demonstrating Apex and LWC code that performs
 *              CRUD operations on the Salesforce platform. The class will showcase Apex and
 *              LWC code for creating an account, renaming the account, modify one or more fields
 *              in the account and delete the account.
 */
public with sharing class DemoCRUDController {

    private static final String MaskLike = '%{0}%'; // For the SOQL LIKE clause

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
     * This is the CRUD "Read" operation.  Returns a list of all Account objects.
     *
     * @return       A list of all Accounts.
     */
    @AuraEnabled(cacheable=false)
    public static List<Account> retrieveAccounts () {

        return Instance.performRetrieveAccounts();
    }

    /***
     * This is the CRUD "Read" operation.  Returns a list of Account objects by Name filter.
     *
     * @param        filterString - Contains a string pattern that identifes Account objects to return.
     * @return       A list of Accounts that match the filter string pattern
     */
    @AuraEnabled(cacheable=false)
    public static List<Account> retrieveAccountsLike (String filterString) {

        return Instance.performRetrieveAccountsLike(filterString);
    }

    /***
     * This is the CRUD "Update" operation.  Performs an update of the account Description field.
     *
     * @param accounts - The list of accounts to be updated.
     */
    @AuraEnabled
    public static void updateAccounts(List<Account> accounts) {

        Instance.performUpdateAccounts(accounts);
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
     * This is the CRUD "Read" operation.  Returns a list of all Account objects.
     *
     * @return       A list of all Accounts.
     */
    public List<Account> performRetrieveAccounts () {

        List<Account> accounts = [  SELECT  Name, Description, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry
                                    FROM    Account
                                    ORDER BY Name];

        System.debug ('DemoCRUDController.performRetrieveAccounts.01.1.3 accounts: ['+accounts+']');

        return accounts;
    }

    /***
     * This is the CRUD "Read" operation.  Returns a list of Account objects by Name filter.
     *
     * @param        filterString - Contains a string pattern that identifes Account objects to return.
     * @return       A list of Accounts that match the filter string pattern
     */
    public List<Account> performRetrieveAccountsLike (String filterString) {

        System.debug ('DemoCRUDController.fetchAccounts.01.1.1 filterString: ['+filterString+']');

        final String searchToken = String.format(MaskLike, new String[] {filterString});

        System.debug ('DemoCRUDController.fetchAccounts.01.1.2 searchToken: ['+searchToken+']');

        List<Account> accounts = [  SELECT  Name, Description, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry
                                    FROM    Account
                                    WHERE   Name LIKE :searchToken
                                    ORDER BY Name];

        System.debug ('DemoCRUDController.fetchAccounts.01.1.3 accounts: ['+accounts+']');

        return accounts;
    }

    /***
     * This is the CRUD "Update" operation.  Performs an update of the account Description field.
     *
     * @param accounts - The list of accounts to be updated.
     */
    private void performUpdateAccounts(List<Account> accounts) {

        System.assertNotEquals  (null, accounts);
        System.assertEquals     (false, accounts.isEmpty());

        try {

            UnitTestUtil.forceExceptionInUnitTest();

            update accounts;

        } catch (Exception ex) {

            System.debug('DemoCRUDController.performRetrieveAccountsLike.01.1 Exception: ' + ex);

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
}