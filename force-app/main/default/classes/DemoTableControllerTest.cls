/***
 * Rakuten
 * Copyright (c) 2023
 *
 * @author       Rick Baker
 * @Description  This class provides code coverage and unit testing for the demo
 *               Table Lightning Web Application.
 */
@isTest
private class DemoTableControllerTest {

    List<Account> accountLst = new List<Account> ();

    @isTest
    private static void testGetAccounts () {

        final String testFilter = 'The';

        Test.startTest();

        List<Account> testAccounts = DemoTableController.getAccounts(testFilter);

        Test.stopTest();

        for (Account account : testAccounts) {

            System.assert(account.Name.contains(testFilter));
        }
    }

    @isTest
    private static void testUpdateAccounts () {

        final String testFilter = 'The';
        final String newDescVal = 'This is a new description value.';

        Test.startTest();

        List<Account> testAccounts = DemoTableController.getAccounts(testFilter);

        System.assertNotEquals(testAccounts, NULL);
        System.assertEquals(FALSE, testAccounts.isEmpty());
        System.assertEquals(2, testAccounts.size()); // Should only be 2 with "The" in the name.

        for (Account account : testAccounts) {

            account.Description = newDescVal;
        }

        DemoTableController.updateAccounts(testAccounts);

        Test.stopTest();

        testAccounts = DemoTableController.getAccounts(testFilter);

        System.assertNotEquals(testAccounts, NULL);
        System.assertEquals(FALSE, testAccounts.isEmpty());

        for (Account account : testAccounts) {

            System.assertEquals(newDescVal, account.Description);
        }
    }

    @TestSetup
    private static void makeData(){

        List<Account> accountList = new List<Account> {
            new Account (Name = 'The Beatles'),
            new Account (Name = 'The Rolling Stones'),
            new Account (Name = 'U2'),
            new Account (Name = 'Dire Staits'),
            new Account (Name = 'Tears for Fears')
        };

        insert accountList;
    }
}