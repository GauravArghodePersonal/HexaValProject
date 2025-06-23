public class ConfirmDialogParam {

    public enum DialogButtons {YesNo, YesNoCancel, ContinueCancel}

    public Boolean renderComp                {get; set;}
    public Boolean renderContinueBtn         {get; set;}

    public Boolean renderYesNoPanel          {get; set;}
    public Boolean renderYesNoCancelPanel    {get; set;}
    public Boolean renderContinueCancelPanel {get; set;}
    public Boolean clickedYes                {get; set;}
    public Boolean clickedNo                 {get; set;}

    public String  cancelUrl                 {get; set;}
    public String  errMsg1                   {get; set;}
    public String  infoMsg1                  {get; set;}
    public String  warnMsg1                  {get; set;}

    public ConfirmDialogParam() {
        renderComp = true; renderContinueBtn = true; renderContinueCancelPanel = true;
        renderYesNoPanel = false; renderYesNoCancelPanel = false;
        clickedYes = false; clickedNo = false;
    }

    public ConfirmDialogParam(Boolean renderContinueBtn) {
        this(); this.renderContinueBtn = renderContinueBtn;
    }

    public ConfirmDialogParam(DialogButtons btns) {
        this();
        renderYesNoPanel          = (btns == DialogButtons.YesNo);
        renderYesNoCancelPanel    = (btns == DialogButtons.YesNoCancel);
        renderContinueCancelPanel = (btns == DialogButtons.ContinueCancel);
    }

}