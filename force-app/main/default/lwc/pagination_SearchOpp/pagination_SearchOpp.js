import { api, LightningElement, track } from 'lwc';
import { refreshApex } from '@salesforce/apex';

export default class Pagination_SearchOpp extends LightningElement {
    currentPage = 1;
    @track recordSize = 10;
    visibleRecords;
    totalrecords;
    totalPage;
    totalRecordSize;

    get records() {
        return this.visibleRecords;
    }

    @api
    set records(data) {
        if (data) {
            this.totalrecords = data;
            this.totalRecordSize = data.length;
            this.totalPage = Math.ceil(data.length / this.recordSize); 
            this.updateRecords();
        }
    }
    // Previous
    previousHandler() {
        if (this.currentPage > 1) {
            this.currentPage--;
            this.updateRecords();
        }

    }
    get disablePrevious() {
        return this.currentPage == 1;
    }

    // Next
    nextHandler() {
        if (this.currentPage < this.totalPage) {
            this.currentPage++;
            this.updateRecords();
        }

    }
    get disableNext() {
        return this.currentPage == this.totalPage;
    }

    // Size
    recSizeHandler(event) {
        this.recordSize = event.target.value;
        this.currentPage = 1;
        this.totalPage = Math.ceil(this.totalrecords.length/this.recordSize);
        this.updateRecords();

    }
    // Update Rec
    updateRecords() {
        const start = (this.currentPage - 1) * this.recordSize;
        const end = this.currentPage * this.recordSize;

        this.visibleRecords = this.totalrecords.slice(start, end);

        this.dispatchEvent(new CustomEvent('update', {
            detail: {
                records: this.visibleRecords
            }
        }))
}
    
}