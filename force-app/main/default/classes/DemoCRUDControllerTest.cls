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
    private static final String accountName_2   = 'Dire Straits';
    private static final String accountName_3   = 'U2';

    private static final String description     = 'This accounts is used for unit testing purposes.';
    private static final String billingStreet   = '9702 Zakro Lane';
    private static final String billingCity     = 'South Jordan';
    private static final String billingState    = 'UT';
    private static final String billingZip      = '84095';
    private static final String billingCountry  = 'US';

    private static final String accountNameNew  = 'New Test Account Name';
    private static final String accountDesc     = 'This is just a plain old, boring account description for a unit test.';

    private static String sortByDefault         = 'Name';
    private static String sortDirDefault        = 'Asc';

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
    private static void testGetAccounts () {

        Test.startTest();

        List<Account> searchResult_1 = DemoCRUDController.getAccounts('',        sortByDefault, sortDirDefault); // Should return all accounts
        List<Account> searchResult_2 = DemoCRUDController.getAccounts('e',       sortByDefault, sortDirDefault); // Should return "The Beatles" and "Dire Straits"
        List<Account> searchResult_3 = DemoCRUDController.getAccounts('Animals', sortByDefault, sortDirDefault); // Should return an empty list
        List<Account> searchResult_4 = DemoCRUDController.getAccounts('2',       sortByDefault, sortDirDefault); // Should return "U2"

        Test.stopTest();

        System.assertEquals(false,  searchResult_1.isEmpty());
        System.assertEquals(3,      searchResult_1.size());
        System.assertEquals(2,      searchResult_2.size());
        System.assertEquals(true,   searchResult_3.isEmpty());
        System.assertEquals(1,      searchResult_4.size());
    }

    @isTest
    private static void testGetAccountsSorting () {

        Test.startTest();

        // Test sorting in ascending order
        List<Account> sortedAsc_1 = DemoCRUDController.getAccounts('', 'Name',          'ASC');
        List<Account> sortedAsc_2 = DemoCRUDController.getAccounts('', 'BillingStreet', 'ASC');

        // Test sorting in descending order
        List<Account> sortedDes_1 = DemoCRUDController.getAccounts('', 'BillingStreet',     'DESC');
        List<Account> sortedDes_2 = DemoCRUDController.getAccounts('', 'BillingPostalCode', 'DESC');

        Test.stopTest();

        // Verify table sorted by Name in ascending order
        System.assertEquals('Dire Straits', sortedAsc_1[0].Name);
        System.assertEquals('The Beatles',  sortedAsc_1[1].Name);
        System.assertEquals('U2',           sortedAsc_1[2].Name);

        // Verify table sorted by BillingStreet in ascending order
        System.assertEquals('The Beatles',  sortedAsc_2[0].Name);
        System.assertEquals('U2',           sortedAsc_2[1].Name);
        System.assertEquals('Dire Straits', sortedAsc_2[2].Name);

        // Verify table sorted by Name in ascending order
        System.assertEquals('Dire Straits', sortedDes_1[0].Name);
        System.assertEquals('U2',           sortedDes_1[1].Name);
        System.assertEquals('The Beatles',  sortedDes_1[2].Name);

        // Verify table sorted by Name in ascending order
        System.assertEquals('Dire Straits', sortedDes_2[0].Name);
        System.assertEquals('The Beatles',  sortedDes_2[1].Name);
        System.assertEquals('U2',           sortedDes_2[2].Name);
    }

    /***
     * This test is the Update in the CRUD operation.
     */
    @isTest
    private static void testUpdateAccount () {

        final String testFilter = 'The Beatles';
        final String newDescVal = 'Four lads who shook the world.';

        Test.startTest();

        List<Account> testAccounts = DemoCRUDController.getAccounts(testFilter, sortByDefault, sortDirDefault);

        System.assertNotEquals(testAccounts, NULL);
        System.assertEquals(FALSE, testAccounts.isEmpty());
        System.assertEquals(1, testAccounts.size()); // Should only be 1 with "The Beatles" in the name.

        Account testAccount = testAccounts[0];

        testAccount.Description = newDescVal;

        DemoCRUDController.updateAccount(testAccount);

        Test.stopTest();

        testAccounts = DemoCRUDController.getAccounts(testFilter, sortByDefault, sortDirDefault);

        System.assertNotEquals(testAccounts, NULL);
        System.assertEquals(FALSE, testAccounts.isEmpty());
        System.assertEquals(1, testAccounts.size()); // Should only be 1 with "The Beatles" in the name.

        testAccount = testAccounts[0];

        System.assertEquals(newDescVal, testAccount.Description);
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

        List<Account> testAccounts = [SELECT Id, Description FROM Account FOR UPDATE];

        System.assertNotEquals(testAccounts, NULL);
        System.assertEquals(FALSE, testAccounts.isEmpty());
        System.assertEquals(3, testAccounts.size()); // Should only be 1 with "The Beatles" in the name.

        Account testAccount = testAccounts[0];

        testAccount.Description = 'Test Me';

        try {

            DemoCRUDController.updateAccount(testAccount);

        } catch (Exception ex) {

            exceptionHit_1 = true;
        }

        try {

            DemoCRUDController.deleteAccounts(testAccounts);

        } catch (Exception ex) {

            exceptionHit_2 = true;
        }

        Test.stopTest();

        System.assertEquals(true, exceptionHit_1);
        System.assertEquals(true, exceptionHit_2);
    }

    @TestSetup
    private static void makeData () {

        List<Account> accountList = new List<Account> {
            new Account (Name = 'U2',           BillingStreet = '555 Middle Street',  BillingPostalCode = '05015'),
            new Account (Name = 'The Beatles',  BillingStreet = '3115 Alma Street',   BillingPostalCode = '59939'),
            new Account (Name = 'Dire Straits', BillingStreet = '999 Zebra Street',   BillingPostalCode = '93201')
        };

        insert accountList;
    }
}