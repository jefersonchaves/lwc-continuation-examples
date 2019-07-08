import { LightningElement, track, wire } from 'lwc';
import startRequestImperative from '@salesforce/apexContinuation/SampleContinuationClass.startRequestImperative';
import startRequestWire from '@salesforce/apexContinuation/SampleContinuationClass.startRequestWire';

export default class ContinuationComponent extends LightningElement {
    //#region Imperative
    @track imperativeContinuation = {};

    callContinuation() {
        this.imperativeContinuation = '';
        startRequestImperative()
            .then(result => {
                this.imperativeContinuation = result;
            })
            .catch(error => {
                this.imperativeContinuation = error;
            }
        );
    }

    get formattedImperativeResult() {
        return JSON.stringify(this.imperativeContinuation);
    }
    //#endregion

    //#region Wired

    @wire(startRequestWire)
    wiredContinuation

    get formattedWireResult() {
        //Data is defined only on success
        return JSON.stringify(
            typeof this.wiredContinuation.data !== 'undefined' ?
            this.wiredContinuation.data :
            this.wiredContinuation.error
        );
    }
    //#endregion
}