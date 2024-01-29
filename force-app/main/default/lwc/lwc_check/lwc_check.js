import { LightningElement } from 'lwc';

export default class Lwc_check extends LightningElement {

    inputText = "hey hi there what's up are you ready for the party??";

    handleReplaceSelection() {
        console.log('buttonclicked-->');
        const selection = window.getSelection();
        console.log('buttonclicked--1>',selection);
        console.log('buttonclicked--2>',selection.rangeCount);

        if (selection.rangeCount > 0) {
            console.log('buttonclicked--3>');
            const range = selection.getRangeAt(0);
            console.log('buttonclicked--4>',range);
            const startOffset = range.startOffset;
            console.log('buttonclicked--5>',startOffset);
            const endOffset = range.endOffset;
            console.log('buttonclicked--6>',endOffset);
            const selectedText = range.toString();

            console.log('buttonclicked--7>',selectedText);
            console.log('buttonclicked--7.1>',selectedText.length);
            
            if (selectedText.length === 1) {
                console.log('buttonclicked--8>',selectedText);
                const updatedText = this.inputText.substr(0, startOffset) + "#" + this.inputText.substr(endOffset);
                console.log('buttonclicked--9>',updatedText);
                this.inputText = updatedText;
            }
        }
    }

    handleReplaceSelection() {
        console.log('buttonclicked-->');
        const selection = window.getSelection();
        console.log('buttonclicked--1>',selection);
        console.log('buttonclicked--2>',selection.rangeCount);
        if (selection.rangeCount > 0) {
            console.log('buttonclicked--3>');
            const range = selection.getRangeAt(0);
            console.log('buttonclicked--4>',range);
            const selectedText = selection.toString();
            console.log('buttonclicked--4.1>',selectedText);
            
            if (selectedText) {
                console.log('buttonclicked--5',selectedText);
                const replacement = selectedText.replace(/./g, '#'); // Replace each character with #
                console.log('buttonclicked--6',replacement);
                const updatedText = this.inputText.substring(0, range.startOffset) + replacement + this.inputText.substring(range.endOffset);
                console.log('buttonclicked--7',updatedText);
                this.inputText = updatedText;
            }
        }
    }
}