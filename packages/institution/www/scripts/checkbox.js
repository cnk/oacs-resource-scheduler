/**
 * Functions to aid with Checkboxes
 *
*/

function setAllCheckBoxes(formName, fieldName, checkValue) {
    if (!document.forms[formName])
        return;
    var checkBoxObject = document.forms[formName].elements[fieldName];
    if (!checkBoxObject)
        return;
    var checkBoxCount = checkBoxObject.length;
    if (!checkBoxCount)
        checkBoxObject.checked = checkValue;
    else
        for (var i = 0; i < checkBoxCount; i++)
		checkBoxObject[i].checked = checkValue;
}
