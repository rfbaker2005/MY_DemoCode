/***
 * Widgets Are Us, Inc.
 * Copyright (c) 2023
 *
 * @author      Rick Baker
 * @Description This class provide code coverage and unit testing for the DemoCRUDController class.
 */
@isTest
private class DemoCRUDControllerTest {

    private static final String accountName_1   = 'The Beatles';
    private static final String accountName_2   = 'The Rolling Stones';
    private static final String accountName_3   = 'U2';

    private static final String description     = 'This accounts is used for unit testing purposes.';
    private static final String billingStreet   = '9702 Zakro Lane';
    private static final String billingCity     = 'South Jordan';
    private static final String billingState    = 'UT';
    private static final String billingZip      = '84095';
    private static final String billingCountry  = 'US';

    private static final String accountNameNew  = 'New Test Account Name';
    private static final String accountDesc     = 'This is just a plain old, boring account description for a unit test.';

    @isTest
    private static void testCreateAccount () {

        Test.startTest();

        Id accountId = DemoCRUDController.createAccount(accountName_1, description, billingStreet, billingCity, billingState, billingZip, billingCountry);

        Test.stopTest();

        Account testAccount = [ SELECT Name, Description, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry
                                FROM Account
                                WHERE Id = :accountId];

        System.assertNotEquals  (null,           testAccount);
        System.assertEquals     (accountName_1,  testAccount.Name);
        System.assertEquals     (description,    testAccount.Description);
        System.assertEquals     (billingStreet,  testAccount.BillingStreet);
        System.assertEquals     (billingCity,    testAccount.BillingCity);
        System.assertEquals     (billingState,   testAccount.BillingState);
        System.assertEquals     (billingZip,     testAccount.BillingPostalCode);
        System.assertEquals     (billingCountry, testAccount.BillingCountry);
    }

    @isTest
    private static void testRetrieveAccounts () {

        Test.startTest();

        List<Account> accounts = DemoCRUDController.retrieveAccounts();

        Test.stopTest();

        System.assertNotEquals (null, accounts);
        System.assertEquals    (3, accounts.size());
    }

    @isTest
    private static void testRetrieveAccountsLike () {

        Test.startTest();

        List<Account> searchResult_1 = DemoCRUDController.retrieveAccountsLike('');        // Should return all accounts
        List<Account> searchResult_2 = DemoCRUDController.retrieveAccountsLike('The');     // Should return "The Beatles" and "The Rolling Stones"
        List<Account> searchResult_3 = DemoCRUDController.retrieveAccountsLike('Animals'); // Should return an empty list
        List<Account> searchResult_4 = DemoCRUDController.retrieveAccountsLike('2');       // Should return "U2"

        Test.stopTest();

        System.assertEquals(false,  searchResult_1.isEmpty());
        System.assertEquals(3,      searchResult_1.size());
        System.assertEquals(2,      searchResult_2.size());
        System.assertEquals(true,   searchResult_3.isEmpty());
        System.assertEquals(1,      searchResult_4.size());
    }

    /***
     * This test is the Update in the CRUD operation and will use the Description field
     * for this purpose.
     */
    @isTest
    private static void testUpdateAccounts () {

        final String testFilter = 'The';
        final String newDescVal = 'This is a new description value.';

        Test.startTest();

        List<Account> testAccounts = DemoCRUDController.retrieveAccountsLike(testFilter);

        System.assertNotEquals(testAccounts, NULL);
        System.assertEquals(FALSE, testAccounts.isEmpty());
        System.assertEquals(2, testAccounts.size()); // Should only be 2 with "The" in the name.

        for (Account account : testAccounts) {

            account.Description = newDescVal;
        }

        DemoCRUDController.updateAccounts(testAccounts);

        Test.stopTest();

        testAccounts = DemoCRUDController.retrieveAccountsLike(testFilter);

        System.assertNotEquals(testAccounts, NULL);
        System.assertEquals(FALSE, testAccounts.isEmpty());

        for (Account account : testAccounts) {

            System.assertEquals(newDescVal, account.Description);
        }
    }

    @isTest
    private static void testDeleteAccounts () {

        Boolean exceptionHit = false;

        List<Account> accounts = [SELECT Id, Name FROM Account];

        System.assertNotEquals  (null, accounts);
        System.assertEquals     (false, accounts.isEmpty());

        Test.startTest();

        DemoCRUDController.deleteAccounts(accounts);

        Test.stopTest();

        try {

            Account testAccount = [SELECT Description FROM Account WHERE Id = :accounts];

        } catch (Exception ex) {

            exceptionHit = true;
        }

        System.assertEquals(true, exceptionHit);
    }

    /***
     * Testing to force hard-to-hit exceptions in controller code.
     */
    @isTest
    private static void testForceExceptions () {

        // Indicate that we want to force hard-to-hit exceptions in controller code.
        UnitTestUtil.ForceExceptionInUnitTest = true;

        Boolean exceptionHit_1 = false;
        Boolean exceptionHit_2 = false;

        Test.startTest();

        List<Account> accounts = [SELECT Id, Description FROM Account FOR UPDATE];

        accounts[0].Description = 'Test Me';

        try {

            DemoCRUDController.updateAccounts(accounts);

        } catch (Exception ex) {

            exceptionHit_1 = true;
        }

        try {

            DemoCRUDController.deleteAccounts(accounts);

        } catch (Exception ex) {

            exceptionHit_2 = true;
        }

        Test.stopTest();

        System.assertEquals(true, exceptionHit_1);
        System.assertEquals(true, exceptionHit_2);
    }

    @TestSetup
    private static void makeData(){

        List<Account> accountList = new List<Account> {
            new Account (Name = 'The Beatles'),
            new Account (Name = 'The Rolling Stones'),
            new Account (Name = 'U2')
        };

        insert accountList;
    }
}