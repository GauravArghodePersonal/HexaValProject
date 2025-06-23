import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import saveSignature from '@salesforce/apex/SignatureController.saveSignature';

// declaration of variables for calculations
let isDownFlag,
    isDotFlag = false,
    prevX = 0,
    currX = 0,
    prevY = 0,
    currY = 0;

let x = "#000000"; // black color
let y = 1.5; // weight of line width and dot.       

let canvasElement, ctx; // storing canvas context
let dataURL, contentDataURI; // holds image data

export default class SignatureComponent extends LightningElement {

    @api recordId;
    @api ContentVersionData;
    header = 'Signature Pad For Seller';
    @track showSpinner = false;

    // event listeners added for drawing the signature within shadow boundary
    constructor() {
        super();
        this.template.addEventListener('mousemove', this.handleMouseMove.bind(this));
        this.template.addEventListener('mousedown', this.handleMouseDown.bind(this));
        this.template.addEventListener('mouseup', this.handleMouseUp.bind(this));
        this.template.addEventListener('mouseout', this.handleMouseOut.bind(this));
        this.template.addEventListener('touchmove', this.handleMouseMove.bind(this));
        this.template.addEventListener('touchstart', this.handleMouseDown.bind(this));
        this.template.addEventListener('touchend', this.handleMouseUp.bind(this));
    }

    // retrieve canvase and context
    renderedCallback() {
        canvasElement = this.template.querySelector('canvas');
        ctx = canvasElement.getContext("2d");
        this.handleClearClick();
    }

    // handler for mouse move operation
    handleMouseMove(event) {
        this.searchCoordinatesForEvent('move', event);
    }

    // handler for mouse down operation
    handleMouseDown(event) {
        this.searchCoordinatesForEvent('down', event);
    }

    // handler for mouse up operation
    handleMouseUp(event) {
        this.searchCoordinatesForEvent('up', event);
    }

    // handler for mouse out operation
    handleMouseOut(event) {
        this.searchCoordinatesForEvent('out', event);
    }

    // Shows toast message
    /* ------------ Inputs ------------
     * title: Title of Toast message
     * message: Message to display in Toast Message
     * variant: Valid values are: 'info' (default), 'success', 'warning', and 'error'.
     * mode: Valid values are: 'dismissible' (default), remains visible until you click the close button or 3 seconds has elapsed, whichever comes first; 
     *                         'pester', remains visible for 3 seconds and disappears automatically. No close button is provided; 
     *                         'sticky', remains visible until you click the close button.
     */
    @api showToastMessage(title, message, variant, mode) {
        const toastMessage = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant, // 'warning',
            mode: mode
        });
        this.dispatchEvent(toastMessage);
    }

    // Checks if canvas is empty. Returns 'true' if canvas is not empty
    @api isSignatureValid() {
        if (!this.isCanvasBlank()) {
            return true;
        }
        return false;
    }

    /** 
     * This below method can be invoked by Parent component (If this signature component is being used as a child to another component)
     * Returns 'contentDataURI' which can be used later to generate Content document record.
     */
    @api saveSignature() {
        // set to draw behind current content
        ctx.globalCompositeOperation = "destination-over";
        ctx.fillStyle = "#FFF"; // white
        ctx.fillRect(0, 0, canvasElement.width, canvasElement.height);

        // convert to png image as dataURL
        dataURL = canvasElement.toDataURL("image/png");
        // convert that as base64 encoding
        contentDataURI = dataURL.replace(/^data:image\/(png|jpg);base64,/, "");
        return contentDataURI;
    }

    // Checks if canvas is empty. Returns 'true' if canvas is empty
    isCanvasBlank() {
        const pixelBuffer = new Uint32Array(
            ctx.getImageData(0, 0, canvasElement.width, canvasElement.height).data.buffer
        );

        return !pixelBuffer.some(color => color !== 0);
    }

    // Clear the signature from canvas
    @api handleClearClick() {
        ctx.clearRect(0, 0, canvasElement.width, canvasElement.height);
    }

    searchCoordinatesForEvent(requestedEvent, event) {
        event.preventDefault();
        if (requestedEvent === 'down') {
            this.setupCoordinate(event);
            isDownFlag = true;
            isDotFlag = true;
            if (isDotFlag) {
                this.drawDot();
                isDotFlag = false;
            }
        }
        if (requestedEvent === 'up' || requestedEvent === "out") {
            isDownFlag = false;
        }
        if (requestedEvent === 'move') {
            if (isDownFlag) {
                this.setupCoordinate(event);
                this.redraw();
            }
        }
    }

    // This method is primary called from mouse down & move to setup cordinates.
    setupCoordinate(eventParam) {
        // get size of an element and its position relative to the viewport 
        // using getBoundingClientRect which returns left, top, right, bottom, x, y, width, height.
        const clientRect = canvasElement.getBoundingClientRect();
        prevX = currX;
        prevY = currY;
        currX = ((eventParam.touches && eventParam.touches[0].clientX) || eventParam.clientX) - clientRect.left;
        currY = ((eventParam.touches && eventParam.touches[0].clientY) || eventParam.clientY) - clientRect.top;

        currX /= clientRect.width;
        currY /= clientRect.height;

        currX *= canvasElement.width;
        currY *= canvasElement.height;
    }

    // For every mouse move based on the coordinates line to redrawn
    redraw() {
        ctx.beginPath();
        ctx.moveTo(prevX, prevY);
        ctx.lineTo(currX, currY);
        ctx.strokeStyle = x; // sets the color, gradient and pattern of stroke
        ctx.lineWidth = y;
        ctx.closePath(); // create a path from current point to starting point
        ctx.stroke(); // draws the path
    }

    // this draws the dot
    drawDot() {
        ctx.beginPath();
        ctx.fillStyle = x; // black color
        ctx.fillRect(currX, currY, y, y); // fill rectrangle with coordinates
        ctx.closePath();
    }

    handleSaveClick() {
        if (this.isCanvasBlank() === false) {
            //set to draw behind current content
            ctx.globalCompositeOperation = "destination-over";
            ctx.fillStyle = "#FFF"; //white
            ctx.fillRect(0, 0, canvasElement.width, canvasElement.height);

            //convert to png image as dataURL
            dataURL = canvasElement.toDataURL("image/png");
            //convert that as base64 encoding
            let convertedDataURI = dataURL.replace(/^data:image\/(png|jpg);base64,/, "");
            this.ContentVersionData = convertedDataURI;
            this.showSpinner = true;

            //call Apex method imperatively and use promise for handling sucess & failure
            if (convertedDataURI != null || convertedDataURI != undefined) {
                saveSignature({
                    ContentVersionData: convertedDataURI,
                    recordId: this.recordId,
                    title: 'Signature_Seller'
                }).then(result => {
                    // Result is Content Version Id
                    this.showToastMessage('Success', 'Signature saved successfully.', 'success', 'dismissible');
                }).catch(error => {
                    this.showToastMessage('Error encountered!', error.body.message, 'error', 'dismissible');                    
                }).finally(() => {
                    this.showSpinner = false;
                });
            }
        } else {
            this.showToastMessage('Warning!!!', 'Signature missing...', 'warning', 'dismissible');
        }
    }
}