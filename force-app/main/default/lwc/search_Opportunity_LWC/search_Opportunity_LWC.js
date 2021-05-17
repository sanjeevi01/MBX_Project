import { LightningElement, track } from 'lwc';
import findOpp from '@salesforce/apex/SearchOppCon.findOpp';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import sendOpp from '@salesforce/apex/SearchOppHttpCallout.postOpp';
import Resources from '@salesforce/resourceUrl/Resources';


const COLUMN = [
    {
        label: 'Opportunity Name', fieldName: 'oppurl', type: 'url',
        typeAttributes:
            { label: { fieldName: 'Name', class: "bgImg1" }, target: '_blank' }, sortable: true
    },
    {
        label: 'Account Name', fieldName: 'accurl', type: 'url',
        typeAttributes:
            { label: { fieldName: 'Account_Name__c' }, target: '_blank' }
    },
    { label: "Stage", fieldName: "StageName", type: "text" },
    { label: "Type", fieldName: "Type", type: "text" },
    {
        label: "Amount", fieldName: "Amount", type: "currency",
        cellAttributes:
            { alignment: "left" }
    },
    {
        type: "button",
        cellAttributes: { class: 'slds-theme_shade slds-theme_alert-texture slds-border_left', alignment: "center" },
        typeAttributes: {
            label: 'Send',
            name: 'Send opportunity',
            title: 'Send opportunity',
            disabled: false,
            value: 'send',
            variant: "brand",

        }
    }
];


export default class Search_Opportunity_LWC extends LightningElement {

    selectedField;
    oppList;
    visibleRecords;

    miLogo = Resources + '/MBX_img/image.jpg';

    @track recordsFound = false;
    @track noRecordsFound = false;
    @track isModalOpen = false;

    @track columns = COLUMN;

    selectedFieldFun = (event) => {
        this.selectedField = event.target.value;
        console.log(this.selectedField);
    }

    searchValues(event) {

        findOpp({ s: event.target.value, fieldName: this.selectedField }).then(result => {

            let oppurl, accurl;
            let baseurl = 'https://' + location.host + '/';
            //console.log(location.host)
            this.oppList = result.map(rec => {
                oppurl = baseurl + rec.Id;

                if (rec.AccountId) {
                    accurl = baseurl + rec.AccountId;
                } else {
                    accurl = '';
                }

                return { ...rec, oppurl, accurl };

            })

            if (result.length == 0) {
                this.noRecordsFound = true;
                this.recordsFound = false;

                const evt = new ShowToastEvent({
                    title: 'Search Result',
                    message: 'No Records Found!',
                    variant: 'error'
                });
                this.dispatchEvent(evt);

            } else {
                this.recordsFound = true;
                this.noRecordsFound = false;
            }
        }).catch((err) => {
            //console.log(err);
        });
    }

    updateRec(event) {
        this.visibleRecords = [...event.detail.records];
        //console.log(this.visibleRecords);
    }


    sendDetails(event) {
        console.log('onrowaction')
        if (event.detail.action.name == 'Send opportunity') {
            this.opp = {
                id: event.detail.row.Id,
                name: event.detail.row.Name,
                accName: event.detail.row.Account_Name__c,
                stage: event.detail.row.StageName,
                type: event.detail.row.Type,
                amount: event.detail.row.Amount
            }
            this.isModalOpen = true;
        }
    }

    sended() {
        this.isModalOpen = false;

        sendOpp({ i: this.opp.id }).then((result) => {
            const status = result;
            //console.log('status');
            if (status == 200) {

                const evt = new ShowToastEvent({
                    title: "Success!!",
                    message: "Record Sent Successfully",
                    variant: "success"
                });
                this.dispatchEvent(evt);
            } else {
                const evt = new ShowToastEvent({
                    title: "Failure!!",
                    message: "Record could not be sent ",
                    variant: "error"
                });
                this.dispatchEvent(evt);
            }

        }).catch((err) => {
            //console.log(err);           
        });

    }

    // Close PopUp
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
        this.opp = {};
    }

}