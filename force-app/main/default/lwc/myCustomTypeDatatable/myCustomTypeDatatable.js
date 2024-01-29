import LightningDatatable from 'lightning/datatable';
import customRichTextTemplate from './customRichText.html';
import customRichTextEditTemplate from './customRichTextEdit.html';

export default class MyCustomTypeDatatable extends LightningDatatable {
    static customTypes = {
        customRichText: {
            template: customRichTextTemplate,
            editTemplate: customRichTextEditTemplate,
            standardCellLayout: true,
            typeAttributes: [],
        }
        // Other types here
    }
}