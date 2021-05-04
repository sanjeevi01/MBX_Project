import { api, LightningElement,track } from 'lwc';
import findOpp from '@salesforce/apex/SearchOppCon.findOpp';
import sendOpp from '@salesforce/apex/SearchOppHttpCallout.postOpp';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const COLUMN=[
    {label:'Opportunity Name',fieldName:'oppurl',type:'url',
                typeAttributes:
                    {label:{fieldName: 'Name'},target:'_blank'}}, 
    {label : 'Account Name', fieldName : 'accurl' ,type:'url',
                typeAttributes:
                    {label:{fieldName: 'Account_Name__c'},target:'_blank'}},  
    {label : "Stage", fieldName : "StageName" ,type : "text" },
    {label : "Type", fieldName : "Type" ,type : "text"},
    {label: "Amount", fieldName:"Amount",type:"currency",
                cellAttributes:
                    {alignment:"left"}},
    {type: "button",
        cellAttributes:{alignment:"center"},
        typeAttributes: {  
            label: 'Send opportunity',  
            name: 'Send opportunity',  
            title: 'Send opportunity',  
            disabled: false,  
            value: 'send',  
            variant: "brand",

    }}
];


export default class Search_Opportunity_LWC extends LightningElement {

    selectedField;
    oppList;
    visibleRecords;

    @track recordsFound = false;
    @track noRecordsFound = false;

    @track columns=COLUMN;

    selectedFieldFun = (event) =>{
        this.selectedField = event.target.value;
        console.log(this.selectedField);
    }

    searchValues = (event) => {
        findOpp({s:event.target.value, fieldName:this.selectedField}).then(result => {
            let oppurl,accurl;
            let baseurl='https://'+location.host+'/';
              this.oppList = result.map(rec =>{
                oppurl = baseurl+rec.Id;

                if(rec.AccountId){
                    accurl = baseurl+rec.AccountId;
                }else{
                    accurl = '';
                }
  
                return{...rec,oppurl,accurl};
                
              })
                if(result.length == 0){
                    this.noRecordsFound = true;
                    this.recordsFound = false;
                }else{
                    this.recordsFound = true;
                    this.noRecordsFound = false;
                }
        }).catch((err) => {
            console.log(err);
        });
    }

    updateRec(event){
        this.visibleRecords=[...event.detail.records]
        //console.log(this.visibleRecords);
    }

    callRowAction(event){
        const recid= event.detail.row.Id;
        console.log(recid);
        const actionName = event.detail.action.name;

        if(actionName == 'Send opportunity'){
            sendOpp({i:recid}).then((result) => {
                const status=result;
                console.log('status');
                if(status == 200){

                    const evt = new ShowToastEvent({
                        title: "Success!!",
                        message: "Record Sent Successfully",
                        variant: "success"
                    });
                    this.dispatchEvent(evt);
                }
                
            }).catch((err) => {
                console.log(err);
                const evt = new ShowToastEvent({
                    title: "Failure!!",
                    message: "Record could not be sent ",
                    variant: "error"
                });
                this.dispatchEvent(evt);
                
            });
        }

    }
    
}