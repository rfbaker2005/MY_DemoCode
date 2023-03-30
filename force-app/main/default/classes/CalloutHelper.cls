/***
 * Widgets Are Us, Inc.
 * Copyright (c) 2023
 *
 * @author      Rick Baker
 * @Description This class is a convenience utility class for HTTP callouts.
 */
public with sharing class CalloutHelper {

    /***
     * This is a helper method for URL encoding of an Object.
     */
    public static String urlEncode(Object oData) {

        List<String> formData = new List<String>();

        String sData = JSON.serialize(oData);

        Map<String, Object> data = (Map<String, Object>)JSON.deserializeUntyped(sData);

        for(String key :data.keySet()) {

            Object value  = data.get(key);
            String sValue = String.valueOf(value);
            String eValue = EncodingUtil.urlEncode(sValue, 'UTF-8');

            formData.add(key + '=' + eValue);
        }

        return String.join(formData, '&');
    }
}