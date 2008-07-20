/****
 *
 *  A library to manipulate layers
 *
 *  Browser and OS Compatability:
 *	
 *	Internet Explorer 6+ 			(Windows XP, Max OSX)
 *	Netscape/Mozilla/FireFox 1.0	     	(Windows, Macs)
 *	Safari		     			(Mac OSX)
 *	Opera (?)
 *      Konqueror (?)
 *
 *  @cvs-id $Id: layer-procs.js,v 1.1 2006/08/02 22:50:43 avni Exp $
 *	
 **/

/* Show or hide the layer */
function showHideWidget(layerId,action) {
	

	var edit_section = document.getElementById(layerId).style;

	if (action == null || action == '') {
		if (edit_section.display == '') {
			edit_section.display='none';
		} else {
			edit_section.display='';
		}
	} else if (action == 'show') {
		edit_section.display='';
	} else if (action == 'hide') {
		edit_section.display='none';
	}
}

/*
* Method for setting layers that is browser compatable
*/

function setEntityContent(entity, content, width) {
	if (document.getElementById) {
		entity.innerHTML = content;
	} else if (document.all) {
		entity.innerHTML = content;
	} else if (document.layers) {
		content_entity_width = width;

		with (entity.document) {
			write(" ");
			close();
		}
		newEntity = new Layer(content_entity_width, entity);

		with (newEntity.document) {
			write(content);
			close();
		}
		newEntity.visibility = "inherit";
		entity.visibility = "show";
	}
}

/**
* Method for getting layer's contents that is compatible for all browsers
*/

function getEntityContent(entity) {
	if (document.getElementById) {
		return entity.innerHTML;
	} else if (document.all) {
		return entity.innerHTML;
	} else if (document.layers) {
		return entity.document.read();
	}
}
