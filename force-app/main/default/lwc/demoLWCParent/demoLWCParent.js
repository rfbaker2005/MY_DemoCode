/***
 * Widgets Are Us, Inc.
 * Copyright (c) 2023
 *
 * @author      Rick Baker
 * @Description This is a demo of how to communicate from a parent LWC to a child LWC.
 */
import { LightningElement } from 'lwc';

export default class demoLWCParent extends LightningElement {

    handleChangeEvent(event){

        console.log('DEBUG.demoLWCParent.handleChangeEvent.01.1.1 event: '+ JSON.stringify(event));

        let childLWC = this.template.querySelector('c-demo-l-w-c-child');

        console.log('DEBUG.demoLWCParent.handleChangeEvent.01.1.2 childLWC: '+ JSON.stringify(childLWC));

        childLWC.changeMessage(event.target.value);
    }
}