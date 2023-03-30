/***
 * Widgets Are Us, Inc.
 * Copyright (c) 2023
 *
 * @author      Rick Baker
 * @Description This class is the helper class with convenience methods to aid in unit testing.
 */
public with sharing class UnitTestUtil {

    @testVisible private static Boolean ForceExceptionInUnitTest = false;

    /***
     * Forces an exception to allow unit tests to reach code coverage for areas of code
     * that catch exceptions, but reaching that exceptin is near impossible to achieve.
     */
    public static void  forceExceptionInUnitTest () {

        if (Test.isRunningTest() && ForceExceptionInUnitTest) {

            // Throw a divide by zero exception.
            Integer aNumericValue = (10 / 0);
        }
    }
}