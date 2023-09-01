import { LightningElement, wire, api } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getAttachment from "@salesforce/apex/AnimalController.getAttachment";
import getAnimal from "@salesforce/apex/AnimalController.getAnimal";
import { refreshApex } from "@salesforce/apex";
import FORM_FACTOR from "@salesforce/client/formFactor";

export default class AnimalImageUpload extends LightningElement {
  @api recordId;
  imageUrl;
  file;
  animalName;
  wiredAnimalImage;
  formFactor = FORM_FACTOR;
  deviceType;

  // file formats for lightning-file-upload
  get acceptedFormats() {
    return [".jpg", ".jpeg", ".png"];
  }

  connectedCallback() {
    if (FORM_FACTOR === "Large") {
      this.deviceType = "Desktop/Laptop";
    } else if (FORM_FACTOR === "Medium") {
      this.deviceType = "Tablet";
    } else if (FORM_FACTOR === "Small") {
      this.deviceType = "Phone";
    }
  }

  // get record name to display
  @wire(getAnimal, { animalId: "$recordId" })
  wiredAnimal({ error, data }) {
    console.log("wiredAnimal2", data, error);
    if (data) {
      this.animalName = data.Animal_Name__c;
      console.log(this.recordId);
    } else if (error) {
      console.error(error);
    }
  }

  // checks to see if there is an image already attached to the record and sets it to the image url
  @wire(getAttachment, { parentId: "$recordId" })
  wiredAttachment(wireResult) {
    const { data, error } = wireResult;
    this.wiredAnimalImage = wireResult;
    if (data) {
      this.imageUrl = "/sfc/servlet.shepherd/version/download/" + data;
      console.log("this.imageUrl: " + this.imageUrl);
    } else if (error) {
      console.error(error);
    }
  }

  // fires when file is uploaded
  handleUploadFinished(event) {
    const uploadedFiles = event.detail.files;
    console.log("uploadedFiles: " + JSON.stringify(uploadedFiles));
    const successMessage = new ShowToastEvent({
      title: "Success!",
      message: "Animal image uploaded successfully."
    });
    this.dispatchEvent(successMessage);

    return refreshApex(this.wiredAnimalImage);
  }
}
