/**
 * Author: Jeff Wang
 *
 * @cvs-id $Id$
 **/

/*
  Create a new object - This is for the Library List.
*/

function LibraryList () {
	this.name= "";
	this.used=0;
	this.libraries= new Array();
	this.addLibrary=addLibrary;
	this.getStateCount=getStateCount;
	this.getStates=getStates;
}

/* The is the Library object.
*/

function Library(name,fromStateCount) {
	this.name=name;
	this.used=0;
	this.fromStates=new Array(fromStateCount);
	this.addState=addState;    
}

/* THe state object */
function State(name, id, toStateCount) {
	this.name=name;
	this.id=id;
	this.used=0;
}

/*This method adds a Library to the LibraryList object*/
function addLibrary(name, fromStateCount) {
	var lib=new Library(name, fromStateCount);
	this.libraries[name]=lib;
	this.used++;
	return lib;
}


/*This method adds an image to the Library object */
function addState(name, id, toStateCount) {
	var state=new State(name, id, toStateCount);
	this.fromStates[this.used]=state;
	this.used++;
	return state;
}



/**Return the number of States in this Library **/
function getStateCount(libName) {
	return this.libraries[libName].used;
}


/**return the actual array of states associated with this library id **/
function getStates(libName) {
    return this.libraries[libName].fromStates;
}

/** Remove everything from the specfied select field **/

function selectRemoveAll(select_field) {

   var select_size = select_field.options.length

   while (select_field.options.length > 0) {
       select_field.options[0] = null;
   }

}


/* Fill the specified library select widget with the appropriate items */

function libraryChange(libSelect,fromStateSelect) {
    index = libSelect.selectedIndex;
    selectedOption = libSelect.options[index];

    selectRemoveAll(fromStateSelect);  
    fromStateCount = libraryList.getStateCount(selectedOption.value);
    

    if (fromStateCount == 0) {
	return;
    }
   
    fromStateSelect.options[0] = new Option('Select State...', '-1');
    fromStates = libraryList.getStates(selectedOption.value);    
	
    for (i = 0; i < fromStateCount; i++) {
        fromStateSelect.options[i+1] = new Option(fromStates[i].name, fromStates[i].id);
    }

}
