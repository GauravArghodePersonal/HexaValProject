/**
 * Adds an onsubmit event handler to the specified form which disabled any buttons with a CSS
 * class of "btn".
 *
 * @param formId
 *        the ID of the form element
 */
function disableButtonsOnSubmit(formId) {
	jQuery(document.getElementById(formId)).submit(function() {
		jQuery(".btn", this).each(function() {
			jQuery("<input type=\"button\" class=\"btn btnDisabled\" disabled=\"disabled\" />")
				.val(jQuery(this).val())
				.insertAfter(this);
			
			jQuery(this).hide();
		});
	});
}
