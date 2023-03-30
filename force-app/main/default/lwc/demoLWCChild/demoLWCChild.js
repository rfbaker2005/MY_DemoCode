/***
 * Widgets Are Us, Inc.
 * Copyright (c) 2023
 *
 * @author      Rick Baker
 * @Description This is a demo of how to communicate from a parent LWC to a child LWC.
 */
import { LightningElement, api, track } from 'lwc';

export default class demoLWCComp extends LightningElement {

    /***
     * Use the @api decorator to make the children properties / method public available so parent
     * can be able to call it directly using JavaScript API. For example create one public method
     * (which we need to access in parent component) in ChildComponent with @api decorator like below.
     */
    @track Message;
    @api
    changeMessage(strString) {
        this.Message = strString.toUpperCase();
    }
}