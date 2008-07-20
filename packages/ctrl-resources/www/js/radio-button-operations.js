/****
 *
 *  A library for operations on radio buttons
 *
 *  Browser and OS Compatability:
 *	
 *	Internet Explorer 6+ 			(Windows XP, Max OSX)
 *	Netscape/Mozilla/FireFox 1.0	     	(Windows, Macs)
 *	Safari		     			(Mac OSX)
 *	Opera (?)
 *      Konqueror (?)
 * 
 *  @cvs-id $Id: radio-button-operations.js,v 1.1 2005/10/25 02:51:10 avni Exp $
 *	
 **/


/****
 * Return the index of the selected radio button
 *
 * @param buttonGroup the Radio Button Widget 	
 */


function getSelectedRadio(buttonGroup) {
   // returns the array number of the selected radio button or -1 if no button is selected
   if (buttonGroup[0]) { // if the button group is an array (one button is not an array)
      for (var i=0; i<buttonGroup.length; i++) {
         if (buttonGroup[i].checked) {
            return i
         }
      }
   } else {
      if (buttonGroup.checked) { return 0; } // if the one button is checked, return zero
   }
   // if we get to this point, no radio button is selected
   return -1;
} // Ends the "getSelectedRadio" function



/****
 * Return the value of the selected Radio Button
 *
 * @param buttonGroup the Radio Button Widget 	
 */


function getSelectedRadioValue(buttonGroup) {
   // returns the value of the selected radio button or "" if no button is selected
   var i = getSelectedRadio(buttonGroup);

   if (i == -1) {
      return "";
   } else {
      if (buttonGroup[i]) { // Make sure the button group is an array (not just one button)
         return buttonGroup[i].value;
      } else { // The button group is just the one button, and it is checked
         return buttonGroup.value;
      }
   }
} // Ends the "getSelectedRadioValue" function


