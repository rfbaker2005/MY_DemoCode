/***
 * Rakuten
 * Copyright (c) 2023
 *
 * @author       Rick Baker
 * @Description  This class is a container class that holds the label and selectedLanguageFrom of a combobox option.
 */
public with sharing class SelectOption {

    public String label;
    public String selectedLanguageFrom;

    public SelectOption () {        
    }

    public SelectOption (String label, String selectedLanguageFrom) {
        
        this.label = label;
        this.selectedLanguageFrom = selectedLanguageFrom;
    }
}