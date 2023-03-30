/***
 * Widgets Are Us, Inc.
 * Copyright (c) 2023
 *
 * @author       Rick Baker
 * @Description  This class is the Apex controller for the demo Table Lightning Web Application.
 */
public with sharing class DemoTableController {

    final String MaskLike = '%{0}%';

    public static DemoTableController Instance {
        get {
            if (Instance == NULL) {
                Instance = new DemoTableController();
            }
            return Instance;
        }
        set;
    }

    //
    // ========== Class Methods =================================================================
    //

    /***
      * @Description  Returns a list of Account objects by Name filter.
      * @param        filterString - Contains a string pattern that identifes Account objects to return.
      * @return       A list of Accounts that match the filter string pattern
      */
    @AuraEnabled(cacheable=false)
    public static List<Account> getAccounts(String filterString) {

        return Instance.fetchAccounts (filterString);
    }

    /***
      * @Description  This method updates an account with a new value for the Description field.
      * @param        accounts - The list of Account objects to update
      */
    @AuraEnabled
    public static void updateAccounts(List<Account> accounts) {

        System.debug('DemoTableController.updateAccouns.01.1.1 accounts: ['+accounts+']');

        Instance.modifyAccounts (accounts);
    }

    //
    // ========== Instance Methods =================================================================
    //

    /***
      * @Description  Returns a list of Account objects by Name filter.
      * @param        filterString - Contains a string pattern that identifes Account objects to return.
      * @return       A list of Accounts that match the filter string pattern
      */
    public List<Account> fetchAccounts(String filterString) {

        System.debug ('DemoTableController.fetchAccounts.01.1.1 filterString: ['+filterString+']');

        final String searchToken = String.format(MaskLike, new String[] {filterString});

        System.debug ('DemoTableController.fetchAccounts.01.1.2 searchToken: ['+searchToken+']');

        List<Account> accounts = [SELECT Name, Description FROM Account WHERE Name LIKE :searchToken];

        System.debug ('DemoTableController.fetchAccounts.01.1.3 accounts: ['+accounts+']');

        return accounts;
    }

    /***
      * @Description  This method updates an account with a new value for the Description field.
      * @param        accounts - The list of Account objects to update
      */
    public void modifyAccounts(List<Account> accounts) {

        System.assertNotEquals (accounts, NULL, 'The accounts parameter cannot be NULL.');
        System.assertNotEquals (TRUE, accounts.isEmpty(), 'The accounts parameter cannot be an empty list.');

        System.debug('DemoTableController.modifyAccounts.01.1.1 accounts: ['+accounts+']');

        if (!accounts.isEmpty()) {

            update accounts;
        }
    }
}