// headerComponent.js
import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import img1 from '@salesforce/resourceUrl/primark_logo';

export default class HeaderComponent extends NavigationMixin(LightningElement) {
    img2Url=img1;
    navigateToChristmas() {
        // Implement navigation logic for CHRISTMAS
    }

    navigateToWomen() {
        // Implement navigation logic for WOMEN
    }

    navigateToRitaOra() {
        // Implement navigation logic for RITA ORA
    }

    navigateToClickAndCollect() {
        // Implement navigation logic for CLICK AND COLLECT
    }

    navigateToKids() {
        // Implement navigation logic for KIDS
    }

    navigateToBaby() {
        // Implement navigation logic for BABY
    }

    navigateToHome() {
        // Implement navigation logic for HOME
    }

    navigateToBeauty() {
        // Implement navigation logic for BEAUTY
    }

    navigateToMen() {
        // Implement navigation logic for MEN
    }

    navigateToCollabs() {
        // Implement navigation logic for COLLABS
    }
}