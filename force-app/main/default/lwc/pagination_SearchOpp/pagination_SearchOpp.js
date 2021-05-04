import { api, LightningElement, track } from 'lwc';

export default class Pagination_SearchOpp extends LightningElement {
    currentPage = 1;
    @track recordSize = 5 ;
    visibleRecords;
    totalrecords;
    totalPage;
    totalRecordSize;

    get records(){ 
        return this.visibleRecords;
    }

    @api
    set records(data){
        if(data){
            this.totalrecords=data;
            this.recordSize = this.recordSize;
            this.totalRecordSize=data.length;            
            this.totalPage = Math.ceil(data.length/this.recordSize);
            this.updateRecords();
        }
    }
    // Previous
    previousHander(){
        if(this.currentPage > 1){
            this.currentPage = this.currentPage -1;
            this.updateRecords();
        }

    }
    get disablePrevious(){
        return this.currentPage == 1;
    }

    // Next
    nextHander(){
        if(this.currentPage < this.totalPage){
            this.currentPage = this.currentPage +1;
            this.updateRecords();
        }

    }
    get disableNext(){
        return this.currentPage == this.totalPage ;
    }

    // Update Rec
    updateRecords(){
        const start = (this.currentPage-1) * this.recordSize;
        const end = this.currentPage * this.recordSize;

        this.visibleRecords = this.totalrecords.slice(start,end);

        this.dispatchEvent(new CustomEvent('update',{
            detail:{
                records:this.visibleRecords
            }
        }))
    }

    // Size
    recSizeHandler(event){
        this.recordSize=event.target.value;
        this.updateRecords();
    }
}