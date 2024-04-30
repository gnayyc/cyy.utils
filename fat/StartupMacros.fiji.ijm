// "StartupMacros"
// The macros and macro tools in this file ("StartupMacros.txt") are
// automatically installed in the Plugins>Macros submenu and
//  in the tool bar when ImageJ starts up.

//  About the drawing tools.
//
//  This is a set of drawing tools similar to the pencil, paintbrush,
//  eraser and flood fill (paint bucket) tools in NIH Image. The
//  pencil and paintbrush draw in the current foreground color
//  and the eraser draws in the current background color. The
//  flood fill tool fills the selected area using the foreground color.
//  Hold down the alt key to have the pencil and paintbrush draw
//  using the background color or to have the flood fill tool fill
//  using the background color. Set the foreground and background
//  colors by double-clicking on the flood fill tool or on the eye
//  dropper tool.  Double-click on the pencil, paintbrush or eraser
//  tool  to set the drawing width for that tool.
//
// Icons contributed by Tony Collins.

// Global variables
var pencilWidth=1,  eraserWidth=10, leftClick=16, alt=8;
var brushWidth = 10; //call("ij.Prefs.get", "startup.brush", "10");
var floodType =  "8-connected"; //call("ij.Prefs.get", "startup.flood", "8-connected");

// The macro named "AutoRunAndHide" runs when ImageJ starts
// and the file containing it is not displayed when ImageJ opens it.

// macro "AutoRunAndHide" {}

function UseHEFT {
	requires("1.38f");
	state = call("ij.io.Opener.getOpenUsingPlugins");
	if (state=="false") {
		setOption("OpenUsingPlugins", true);
		showStatus("TRUE (images opened by HandleExtraFileTypes)");
	} else {
		setOption("OpenUsingPlugins", false);
		showStatus("FALSE (images opened by ImageJ)");
	}
}

UseHEFT();

// The macro named "AutoRun" runs when ImageJ starts.

macro "AutoRun" {
	// run all the .ijm scripts provided in macros/AutoRun/
	autoRunDirectory = getDirectory("imagej") + "/macros/AutoRun/";
	if (File.isDirectory(autoRunDirectory)) {
		list = getFileList(autoRunDirectory);
		// make sure startup order is consistent
		Array.sort(list);
		for (i = 0; i < list.length; i++) {
			if (endsWith(list[i], ".ijm")) {
				runMacro(autoRunDirectory + list[i]);
			}
		}
	}
}

var pmCmds = newMenu("Popup Menu",
	newArray("Help...", "Rename...", "Duplicate...", "Original Scale",
	"Paste Control...", "-", "Record...", "Capture Screen ", "Monitor Memory...",
	"Find Commands...", "Control Panel...", "Startup Macros...", "Search..."));

macro "Popup Menu" {
	cmd = getArgument();
	if (cmd=="Help...")
		showMessage("About Popup Menu",
			"To customize this menu, edit the line that starts with\n\"var pmCmds\" in ImageJ/macros/StartupMacros.txt.");
	else
		run(cmd);
}

macro "Abort Macro or Plugin (or press Esc key) Action Tool - CbooP51b1f5fbbf5f1b15510T5c10X" {
	setKeyDown("Esc");
}

var xx = requires138b(); // check version at install
function requires138b() {requires("1.38b"); return 0; }

var dCmds = newMenu("Developer Menu Tool",
newArray("ImageJ Website","News", "Documentation", "ImageJ Wiki", "Resources", "Macro Language", "Macros",
	"Macro Functions", "Startup Macros...", "Plugins", "Source Code", "Mailing List Archives", "-", "Record...",
	"Capture Screen ", "Monitor Memory...", "List Commands...", "Control Panel...", "Search...", "Debug Mode"));

macro "Developer Menu Tool - C037T0b11DT7b09eTcb09v" {
	cmd = getArgument();
	if (cmd=="ImageJ Website")
		run("URL...", "url=http://rsbweb.nih.gov/ij/");
	else if (cmd=="News")
		run("URL...", "url=http://rsbweb.nih.gov/ij/notes.html");
	else if (cmd=="Documentation")
		run("URL...", "url=http://rsbweb.nih.gov/ij/docs/");
	else if (cmd=="ImageJ Wiki")
		run("URL...", "url=http://imagejdocu.tudor.lu/imagej-documentation-wiki/");
	else if (cmd=="Resources")
		run("URL...", "url=http://rsbweb.nih.gov/ij/developer/");
	else if (cmd=="Macro Language")
		run("URL...", "url=http://rsbweb.nih.gov/ij/developer/macro/macros.html");
	else if (cmd=="Macros")
		run("URL...", "url=http://rsbweb.nih.gov/ij/macros/");
	else if (cmd=="Macro Functions")
		run("URL...", "url=http://rsbweb.nih.gov/ij/developer/macro/functions.html");
	else if (cmd=="Plugins")
		run("URL...", "url=http://rsbweb.nih.gov/ij/plugins/");
	else if (cmd=="Source Code")
		run("URL...", "url=http://rsbweb.nih.gov/ij/developer/source/");
	else if (cmd=="Mailing List Archives")
		run("URL...", "url=https://list.nih.gov/archives/imagej.html");
	else if (cmd=="Debug Mode")
		setOption("DebugMode", true);
	else if (cmd!="-")
		run(cmd);
}

var sCmds = newMenu("Stacks Menu Tool",
	newArray("Add Slice", "Delete Slice", "Next Slice [>]", "Previous Slice [<]", "Set Slice...", "-",
		"Convert Images to Stack", "Convert Stack to Images", "Make Montage...", "Reslice [/]...", "Z Project...",
		"3D Project...", "Plot Z-axis Profile", "-", "Start Animation", "Stop Animation", "Animation Options...",
		"-", "MRI Stack (528K)"));
macro "Stacks Menu Tool - C037T0b11ST8b09tTcb09k" {
	cmd = getArgument();
	if (cmd!="-") run(cmd);
}

var luts = getLutMenu();
var lCmds = newMenu("LUT Menu Tool", luts);
macro "LUT Menu Tool - C037T0b11LT6b09UTcb09T" {
	cmd = getArgument();
	if (cmd!="-") run(cmd);
}
function getLutMenu() {
	list = getLutList();
	menu = newArray(16+list.length);
	menu[0] = "Invert LUT"; menu[1] = "Apply LUT"; menu[2] = "-";
	menu[3] = "Fire"; menu[4] = "Grays"; menu[5] = "Ice";
	menu[6] = "Spectrum"; menu[7] = "3-3-2 RGB"; menu[8] = "Red";
	menu[9] = "Green"; menu[10] = "Blue"; menu[11] = "Cyan";
	menu[12] = "Magenta"; menu[13] = "Yellow"; menu[14] = "Red/Green";
	menu[15] = "-";
	for (i=0; i<list.length; i++)
		menu[i+16] = list[i];
	return menu;
}

function getLutList() {
	lutdir = getDirectory("luts");
	list = newArray("No LUTs in /ImageJ/luts");
	if (!File.exists(lutdir))
		return list;
	rawlist = getFileList(lutdir);
	if (rawlist.length==0)
		return list;
	count = 0;
	for (i=0; i< rawlist.length; i++)
		if (endsWith(rawlist[i], ".lut")) count++;
	if (count==0)
		return list;
	list = newArray(count);
	index = 0;
	for (i=0; i< rawlist.length; i++) {
		if (endsWith(rawlist[i], ".lut"))
			list[index++] = substring(rawlist[i], 0, lengthOf(rawlist[i])-4);
	}
	return list;
}

macro "Pencil Tool - C037L494fL4990L90b0Lc1c3L82a4Lb58bL7c4fDb4L5a5dL6b6cD7b" {
	getCursorLoc(x, y, z, flags);
	if (flags&alt!=0)
		setColorToBackgound();
	draw(pencilWidth);
}

macro "Paintbrush Tool - C037La077Ld098L6859L4a2fL2f4fL3f99L5e9bL9b98L6888L5e8dL888c" {
	getCursorLoc(x, y, z, flags);
	if (flags&alt!=0)
		setColorToBackgound();
	draw(brushWidth);
}

macro "Flood Fill Tool -C037B21P085373b75d0L4d1aL3135L4050L6166D57D77D68La5adLb6bcD09D94" {
	requires("1.34j");
	setupUndo();
	getCursorLoc(x, y, z, flags);
	if (flags&alt!=0) setColorToBackgound();
	floodFill(x, y, floodType);
}

function draw(width) {
	requires("1.32g");
	setupUndo();
	getCursorLoc(x, y, z, flags);
	setLineWidth(width);
	moveTo(x,y);
	x2=-1; y2=-1;
	while (true) {
		getCursorLoc(x, y, z, flags);
		if (flags&leftClick==0) exit();
		if (x!=x2 || y!=y2)
			lineTo(x,y);
		x2=x; y2 =y;
		wait(10);
	}
}

function setColorToBackgound() {
	savep = getPixel(0, 0);
	makeRectangle(0, 0, 1, 1);
	run("Clear");
	background = getPixel(0, 0);
	run("Select None");
	setPixel(0, 0, savep);
	setColor(background);
}

// Runs when the user double-clicks on the pencil tool icon
macro 'Pencil Tool Options...' {
	pencilWidth = getNumber("Pencil Width (pixels):", pencilWidth);
}

// Runs when the user double-clicks on the paint brush tool icon
macro 'Paintbrush Tool Options...' {
	brushWidth = getNumber("Brush Width (pixels):", brushWidth);
	call("ij.Prefs.set", "startup.brush", brushWidth);
}

// Runs when the user double-clicks on the flood fill tool icon
macro 'Flood Fill Tool Options...' {
	Dialog.create("Flood Fill Tool");
	Dialog.addChoice("Flood Type:", newArray("4-connected", "8-connected"), floodType);
	Dialog.show();
	floodType = Dialog.getChoice();
	call("ij.Prefs.set", "startup.flood", floodType);
}

macro "Set Drawing Color..."{
	run("Color Picker...");
}

macro "-" {} //menu divider

macro "About Startup Macros..." {
	title = "About Startup Macros";
	text = "Macros, such as this one, contained in a file named\n"
		+ "'StartupMacros.txt', located in the 'macros' folder inside the\n"
		+ "Fiji folder, are automatically installed in the Plugins>Macros\n"
		+ "menu when Fiji starts.\n"
		+ "\n"
		+ "More information is available at:\n"
		+ "<http://imagej.nih.gov/ij/developer/macro/macros.html>";
	dummy = call("fiji.FijiTools.openEditor", fif, text);
}

macro "Save As JPEG... [j]" {
	quality = call("ij.plugin.JpegWriter.getQuality");
	quality = getNumber("JPEG quality (0-100):", quality);
	run("Input/Output...", "jpeg="+quality);
	saveAs("Jpeg");
}

macro "Save Inverted FITS" {
	run("Flip Vertically");
	run("FITS...", "");
	run("Flip Vertically");
}


//--------------------------------------- Fat Measurement

// "CT measurement Macro"
run("Options...", "iterations=1 white count=1"); //set black background
run("Colors...", "foregtround=black background=white selection=red"); //set colors
run("Display...", " "); //do not use Inverting LUT

var TF = 0;
var SF = 0;
var VF = 0;
var PF = 0;
var RF = 0;
var WVF = 0;
var WF = 0;
var PatientID = "";
var PatientsBirthDate = "";
var PatientSex = "";
var PatientName = "";
var StudyDate = "";
var time = "";
var studyid = "";
var series = "";
var image = "";
var Modality = "CT";

var ImageID = 0;
var iid = "";
var sid = "";
var Title = "";
var DataDir = "";
var FatLogfile = "";
var FatImgDir = "";
var AortaLogfile = "";
var AortaImgDir = "";
var CaLogfile = "";
var CaImgDir = "";
var fat_title = "";
var wvfat_title = "";
var vfat_title = "";
var pfat_title = "";
var idir = "";
var ipath = "";
var num_n = 0;
var num_N = 0;

var group_liver = 1;
var group_pancreas = 2;
var group_spleen = 3;
var group_rkfat = 4;
var group_lkfat = 5;
var group_rkthick = 6;
var group_lkthick = 7;
var group_aorta = 8;
var group_sat_u = 11;
var group_vat_u = 12;
var group_soft_u = 13;
var group_bone_u = 14;
var group_psoas_u = 15;
var group_back_u = 16;
var group_aw_u = 17;
var group_body_u = 18;
var group_sat_3 = 31;
var group_vat_3 = 32;
var group_soft_3 = 33;
var group_bone_3 = 34;
var group_psoas_3 = 35;
var group_back_3 = 36;
var group_aw_3 = 37;
var group_body_3 = 38;
var group_qlum_3 = 39;
var group_tat_3 = 40;
var group_ovat_3 = 41;
var group_oat_3 = 42;
var group_liver_mre = 51;

//var group_ccn = 1;
//var group_5mt = 2;

//--------- File structures -----------//
// ### {dir0}/{xdir}/{idir}/{imgs}
// ### xmode = 0:
//	{xdir} = "";
//	{idir} = "";
//	{data_dir} = {dir0}/0data
// ### xmode = 1:
//	{xdir} != "";
//	{idir} = "";
//	{wdir} = {dir0}/{xdir}/{data_dir}
// ### xmode = 2:
//	{xdir} != "";
//	{idir} != "";
//	{wdir} = {dir0}/{xdir}/{data_dir}


var xmode = 2;
//var data_dir = "0data/";
var data_dir = "";
var anatomy_dir = "0anatomy/";
function open_case(direction) {
    // direction = 1 (forward), 0 (find first undone), -1 (backward)

    xid = getXid("");			// exam_dir
    xdir = getXdir("");			// exam_dir
    idir = getIdir("");			// img_dir
    dir0 = get0dir("");			// root_dir
    xlist = getXlist("");

    x_n = -1;
    for (i = 0; i < xlist.length; i++) {
	// find first undo
	if (xmode == 0) {
	    xpath = dir0 + xlist[i];
	} else if (xmode == 1) {
	    xpath = dir0 + xlist[i];
	} else if (xmode == 2) {
	    xpath = dir0 + xlist[i] + "0data";
	}
	if (direction == 0) {
	    if (! existROI(xpath)) { x_n = i + 1; }
	} else {
	    xid1 = getXid(xpath);
	    print("[xid0 ] " + xid);
	    print("[xid1 ] " + xid1);
	    print("[xpath1] " + xpath);
	    if (xid == xid1) {
		if (direction == 1) {
		    if (i == xlist.length - 1) {
			showMessage("All Done!!");
			return 0;
		    } else {
			x_n = i + 2;
		    }
		} else { // direction == -1
		    if (i == 0) {
			showMessage("Already the first");
			return 0;
		    } else {
			x_n = i;
		    }
		}
	    }
	}
	if (x_n >= 0) {
	    x_N = xlist.length;
	    getLocationAndSize(x, y, width, height);
	    call("ij.gui.ImageWindow.setNextLocation", x, y);
	    nZoom = getZoom() * 100;
	    close("*");

	    if (xmode == 0) {
		xpath = dir0 + xlist[x_n - 1];
	    } else {
		xdir1 = dir0 + xlist[x_n-1];
		if (xmode == 2) {
		    ilist0 = getFileList(xdir1);
		    j = 0;
		    for (i = 0; i < ilist0.length; i++) {
			//if (File.isDirectory(xdir1 + ilist0[i]) && ! ilist0[i].matches("0data")) {
			if (ilist0[i].startsWith(defaultSeries) && File.isDirectory(xdir1 + ilist0[i]) && ! ilist0[i].matches("0data")) {
			    j = i;
			    break;
			}
		    }
		    xpath = xdir1 + ilist0[j];
		}
	    }
	    open(xpath);

	    //setLocation(x, y, width, height);
	    setLocation(x, y);
	    run("Set... ", "zoom="+ nZoom);
	    init();
	    showStatus("[" + x_n + "/" + xlist.length + "] " + xpath);
	    return xpath;
	}
    }
}

function init() {
    initVar();
    roiManager("reset");
    //roiManager("Show All");
    roiManager("Show None");
    //roiManager("Show All with labels");
    //setTool("Line");
    setTool("oval");
    loadROI("");
    update_info();
}

function init_dixon() {
  initVar();
  roiManager("reset");
  //roiManager("Show All");
  roiManager("Show None");
  //roiManager("Show All with labels");
  //setTool("Line");
  setTool("oval");
  xpath = getIpath();
  roifile = pathExt(xpath, "_dixon.zip");
  if(File.exists(roifile)) {
    roiManager("Open", roifile);
  }
  update_info();
}

function init_mre() {
  initVar();
  roiManager("reset");
  //roiManager("Show All");
  roiManager("Show None");
  //roiManager("Show All with labels");
  //setTool("Line");
  setTool("oval");
  xpath = getIpath();
  roifile = pathExt(xpath, "_mre.zip");
  if(File.exists(roifile)) {
    roiManager("Open", roifile);
  }
  update_info();
}

function initVar() {
    //roidir = File.getParent(pathROI(""));
    sid = getXid("");
}

macro "init [0]" {
    init();
}


function open_series(direction) {
    // direction = 1 (forward), 0 (find first undone), -1 (backward)
    if (direction == 0) {
	return;
    }
    if (xmode != 2) {
	return;
    }


    xid = getXid("");			// exam_dir
    xdir = getXdir("");			// exam_dir
    idir = getIdir("");			// img_dir
    dir0 = get0dir("");			// root_dir
    //xlist = getXlist("");
    ilist = getIlist("");

    x_n = -1;
    for (i = 0; i < ilist.length; i++) {
	if (idir == ilist[i]) {
	    // assign x_n
	    if (direction == 1) {
		if (i == ilist.length - 1) {
		    showMessage("Already the last series!!");
		    return 0;
		} else {
		    x_n = i + 2;
		}
	    } else { // direction == -1
		if (i == 0) {
		    showMessage("Already the first");
		    return 0;
		} else {
		    x_n = i;
		}
	    }
	}
	if (x_n >= 0) {
	    x_N = ilist.length;
	    getLocationAndSize(x, y, width, height);
	    call("ij.gui.ImageWindow.setNextLocation", x, y);
	    nZoom = getZoom() * 100;
	    close("*");

	    if (xmode == 2) {
		next_idir = dir0 + xdir + ilist[x_n-1];
		open(next_idir);
	    } //else {
		//open(xpath);
	    //}

	    //setLocation(x, y, width, height);
	    setLocation(x, y);
	    run("Set... ", "zoom="+ nZoom);
	    init();
	    showStatus("[" + x_n + "/" + ilist.length + "] " + next_idir);
	    return next_idir;
	}
    }
}

function getIpath() {
    // return 
    // xmode == 0 -> Dir/image.tgz
    // xmode == 1 -> Dir/x1
    // xmode == 2 -> Dir/x1/s1
    ipath = Property.get("xpath");
    //showMessage("ipath property = " + ipath);
    if (ipath == "") 
	ipath = getInfo("image.directory") + getInfo("image.filename");
    //showMessage("ipath getInfo = " + ipath);
    return ipath;
}

function getIdir(xpath) {
    if (xpath == "") xpath = getIpath();

    if (xmode == 0) { // xdir == idir == ""
	idir0 = "";
    } else if (xmode == 1) { // idir == ""
	idir0 = "";
    } else {
	idir0 = getInfo("image.directory");
    }

    return idir0;
}

function getXdir(xpath) {
    // return 
    // xmode == 0 -> Dir
    // xmode == 1 -> Dir/x1
    // xmode == 2 -> Dir/x1

    if (xpath == "") xpath = getIpath();
    if (xmode == 0) {
	xdir = File.getDirectory(xpath);
    } else if (xmode == 1) {
	xdir = xpath;
    } else { // xmode == 2
	xdir = File.getParent(xpath) + File.separator;
    }

    //xdir = replace(xdir, "\\", "/");
    //xdir = replace(xdir, "//", "/");
    //print(xdir);
    return xdir;
}

function getXlist(xpath) {
    // return 
    // xmode == 0 -> Dir
    // xmode == 1 -> Dir/x1
    // xmode == 2 -> Dir/x1

    if (xpath == "") xpath = getIpath();

    dir0 = get0dir("");
    if (xmode == 0) {
	iName = File.getNameWithoutExtension(xpath);
	iFilename = File.getName(xpath);
	iExt = replace(iFilename, iName + ".", "");

	xlist0 = getFileList(dir0);
	xlist = newArray;
	for (i = 0; i < xlist0.length; i++) {
	    if (endsWith(xlist0[i], iExt))
		xlist = Array.concat(xlist, xlist0[i]);
	}
    } else {
	xlist0 = getFileList(dir0);
	xlist = newArray;
	for (i = 0; i < xlist0.length; i++) {
	    if (File.isDirectory(dir0 + xlist0[i]))
		//itmp = replace(xlist0[i], "\\", "");
		//itmp = replace(itmp, "/", "");
		xlist = Array.concat(xlist, xlist0[i]);
	}
    }

    return xlist;
}

function getIlist(xpath) {
    // return 
    // xmode == 0 -> Dir
    // xmode == 1 -> Dir/x1
    // xmode == 2 -> Dir/x1

    if (xpath == "") xpath = getIpath();

    if (xmode != 2) {
	return;
    } else {
	xdir = getXdir(xpath);
	ilist0 = getFileList(xdir);
	ilist = newArray;
	for (i = 0; i < ilist0.length; i++) {
	    if (File.isDirectory(xdir + ilist0[i]) && ! ilist0[i].matches("0data")) {
		ilist = Array.concat(ilist, itmp);
	    }
	}

    }

    return ilist;
}

function get0dir(xpath) {
    // return 
    // xmode == 0 -> {Dir
    // xmode == 1 -> {Dir}/x1/
    // xmode == 2 -> {Dir}/x1/i1

    if (xpath == "") xpath = getIpath();

    if (xmode == 0) {
	xdir = File.getDirectory(xpath);
    } else if (xmode == 1) {
	xdir = File.getParent(xpath) + File.separator;
    } else { // xmode == 2
	xdir = File.getParent(xpath) + File.separator;
	xdir = File.getParent(xdir) + File.separator;
    }

    return xdir;
}


function getXid(xpath) {
    // return 
    // xmode == 0 -> (xxx).ext
    // xmode == 1 -> Dir/(x1)
    // xmode == 2 -> Dir/(x1)
    
    if (xpath == "") xpath = getIpath();

    if (xmode == 0) {
	xid = File.getNameWithoutExtension(xpath);
    } else if (xmode == 1) {
	xid = File.getName(xpath);
    } else { // xmode == 2
	xid = File.getName(File.getParent(xpath));
    }

    return xid;
}

function pathExt(xpath, ext) {
    // return:
    // xmode0: Dir/$xid.jpg	-> Dir/$data_dir/$xid$ext
    // xmode1: Dir/$xid/	-> Dir/$xid/$data_dir/$xid$ext
    // xmode2: Dir/$xid/xid_s1/	-> Dir/$xid/$data_dir/$xid$ext

    if (xpath == "") xpath = getIpath();

    xdir = getXdir(xpath);
    xid = getXid(xpath);
    if (xdir == "") xdir = Property.get("xdir");
    if (xid == "") xid = Property.get("xid");
    if (xmode == 0) data_dir = "";

    iExt = xdir + data_dir + xid + ext;

    return iExt;
}

function pathCSV(xpath) {
    path = pathExt(xpath, "_roi.csv");
    return path;
}

function pathROI(xpath) {
    path = pathExt(xpath, "_roi.zip");
    return path;
}

function existCSV(ipath) {
    if (File.exists(pathCSV(ipath)))
	return true;
    else
	return false;
}

function existROI(ipath) {
    if (File.exists(pathROI(ipath))) {
	return true;
    } else {
	return false;
    }
}

function loadROI(xpath) {
    showStatus("pathROI: " + pathROI(xpath));
    if(File.exists(pathROI(xpath))) {
	roiManager("Open", pathROI(xpath));
    }
    //tidyROI();
}


function savelvl(lvl) {
    Title = getTitle();

    id = getTag("0010,0020");
    studyid = getTag("0020,0010");
    series = getTag("0020,0011");
    image = getTag("0020,0013");
    modality = getTag("0008,0060");

    id = replace(id, " ", "");
    studyid = replace(studyid, " ", "");
    series = replace(series, " ", "");
    image = replace(image, " ", "");

    date = replace(getTag("0008,0020"), " ", "");
    tp = id + "_" + date + "_" + series + "_" + image;

    getDimensions(width, height, channels, slices, frames);
    idir = getDirectory("image");
    if (slices > 1) {
	ipath = getDirectory("image") + getInfo("slice.label"); 
    } else {
	ipath = getDirectory("image") + Title;
    }

    if (matches(modality, ".*MR.*"))
	mod = "MR";
    else
	mod = "CT";

    time = replace(getTime,"E12","");
    time = replace(time, "\\\.", "");

    if (xmode == 2) {
	idir = File.getParent(idir) + File.separator; 
    }
    ImgDir = idir + anatomy_dir;
    if (!File.exists(ImgDir)) 
	File.makeDirectory(ImgDir);
      
    if(File.exists(ipath)) {
	// File.copy(ipath, ImgDir + tp + "_" + mod + "_" + lvl + ".dcm");
	File.copy(ipath, ImgDir + tp + "_" + lvl + ".dcm");
    } else {
	// File.copy(ipath + ".dcm", ImgDir + tp + "_" + mod + "_" + lvl + ".dcm");
	File.copy(ipath + ".dcm", ImgDir + tp + "_" + lvl + ".dcm");
    }
    showStatus(lvl + " (" + id + ") saved!");
}

macro "L3 [k]" {
    init();
    savelvl("L3");
}

//------------------------------------ Fat related macros
// # Press [f] to set fat mask
// # If default threshold doesn't work well, use another routine:
//   Press [0] to set init data
//   Press [9] to duplicate the desired slice and set the title
//   Press [T] to apply threshold
//   Press [F] (Capital F) to overlay the original image
// # Press [f1] after remove all but Total Fat 
// # Press [f2] after remove Subcutaneous Fat 
// # Press [f3] after remove Intramuscular Fat 
// # Press [f4] after remove Retroperitoneal Fat 
// set fat threshold
/*
macro "AutoThreshold [a]" {
  setAutoThreshold();
}
*/

macro "Reload [R]" {
	run("Install...", "install=["+ getDirectory("macros") + "StartupMacros.fiji.ijm]");
}


/*
function init() {
    // get num_N num_n
    if (num_n == 0) {
	iname = getInfo("image.filename");
	if ("" + iname == "")  {
	    // directory
	    iname = getDir("image");
	    idir = File.getParent(iname);
	    list0 = getFileList(idir);
	} else {
	    idir = getDir("image");
	    list0 = getFileList(idir);
	}
    }



    if (0) {
	//run("Clear Results");
	TF = SF = VF = PF = RF = WVF = WF = 0;
	PatientName = getTag("0010,0010");
	PatientID = getTag("0010,0020");
	PatientsBirthDate = getTag("0010,0030");
	PatientSex = getTag("0010,0040");
	StudyDate = getTag("0008,0020");
	studyid = getTag("0020,0010");
	series = getTag("0020,0011");
	image = getTag("0020,0013");
	Modality = getTag("0008,0060");
	time = replace(getTime,"E12","");
	time = replace(time, "\\\.", "");

	ImageID = getImageID();
	Title = getTitle();
	idir = getDirectory("image");
	iid = get_iid();
	sid = get_sid();
	getDimensions(width, height, channels, slices, frames);
	roiManager("reset");
	if (nSlices > 1)
	    ipath = idir + getInfo("slice.label"); 
	else
	    ipath = idir + Title;

	if(!File.exists(ipath)) {
	    ipath = ipath + ".dcm";
	}
	if(!File.exists(ipath)) {
	    ipath = "";
	}
	nSlice = 0;
	workingSlice = 0;

	fat_title = Title+"_1fat";
	wvfat_title = Title+"_2wvfat";
	vfat_title = Title+"_3vfat";
	pfat_title = Title+"_4pfat";

	if (matches(Modality, ".*MR.*")){
	    Modality = "MR";
	    setOption("BlackBackground", true);
	    run("Colors...", "foreground=white background=black selection=red"); //set colors display
	    run("Options...", "iterations=1 black count=1"); //set white background vvv
	}
	else {
	    Modality = "CT";
	    setMinAndMax(-125, 225);
	    setOption("BlackBackground", false);
	    run("Colors...", "foreground=black background=white selection=red"); //set colors display
	    run("Options...", "iterations=1 count=1"); //set white background 
	}
	if (File.exists(create_series_path("_roi.zip"))) {
	    roiManager("Open", create_series_path("_roi.zip"));
	}
	update_results();
	//run("Original Scale");
	//setLocation(610, -10, width * 1.5, height*1.5);
	//setLocation(610, -10);
	Table.setLocationAndSize(0, 110, 300, 450, "Log");
	Table.setLocationAndSize(300, 110, 300, 450, "ROI Manager");
	if (RoiManager.size > 0) {
	    RoiManager.select(RoiManager.size - 1);
	    roiManager("Deselect");
	    RoiManager.selectGroup(group_psoas_3);
	}

    }

}
*/

function print_group(group_name, group_id) {
    RoiManager.selectGroup(group_id);
    print("[", RoiManager.selected , "]", group_name, "(", group_id, ")");
}

function get_length() {
    if (selectionType == 5) { // straight line
        getLine(x1, y1, x2, y2, lineWidth);
        // pixel_length = sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1));
        getPixelSize(unit, width, height, depth);
        x1*=width; y1*=height; x2*=width; y2*=height;
        scale_length = sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1));
	return scale_length;
    } else 
	return -1;
}

function set_result(row, id, ts, type, label, value) {
    setResult("id", row, id);
    setResult("timestamp", row, ts);
    setResult("type", row, type);
    setResult("label", row, label);
    setResult("value", row, value);
}

/* /work/ mode
function gen_sdir() {
    setBatchMode(true); 
    sdir = getDirectory("Choose Source Directory ");
    sdir = replace(sdir, "\\", "/");

    list0 = getFileList(sdir);
    list = list0;
    for (i = 0; i < list0.length; i++) {
	if (! File.isDirectory(sdir + list0[i]))
	    list = Array.deleteValue(list, list0[i]);
    }

    for (i = 0; i < list.length; i++) {
    //for (i = 0; i < 2; i++) {
	found_roi = -1;
	roi = "";
	check = getFileList(sdir + list[i] + "/work");
	for (j = 0; j < check.length; j++) {
	    if (endsWith(check[j], "roi.zip")) {
		found_roi = j;
		roi = check[j];
	    }
	}
	if (found_roi >= 0) {
	    print(sdir + list[i] + File.separator + "work" + File.separator + roi);
	    open(sdir + list[i]);
	    init();
	    generate_results();
	    gen_m_results();
	    gen_f_results();
	    close();
	}
    }
    //setBatchMode(false); 
}
*/

function gen_sdir() {
  // file mode
  setBatchMode(true); 
  sdir = getDirectory("Choose Source Directory ");
  sdir = replace(sdir, "\\", "/");

  ifiles = getFileList(sdir);

  for (i = 0; i < ifiles.length; i++) {
    if (xmode == 0) {
      if (endsWith(ifiles[i], "_roi.zip")) {
        ibase = ifiles[i].replace("_roi.zip","");
        idcm = ibase + ".dcm";
        showStatus(sdir + idcm);
        open(sdir + idcm);
        init();
        //generate_results();
        //gen_m_results();
        gen_f_results();
        //gen_results();
        close();
      }
    } else if (xmode == 2) {
      xdir = sdir + ifiles[i];
      if (File.isDirectory(xdir)) {
        ilist0 = getFileList(xdir);
        i_F = 0;
        i_W= 0;
        i_E = 0;
        for (j = 0; j < ilist0.length; j++) {
          if (ilist0[j].startsWith("03_F1") && File.isDirectory(xdir + ilist0[j])) {
            i_F = j;
          }
          if (ilist0[j].startsWith("04_W1") && File.isDirectory(xdir + ilist0[j])) {
            i_W = j;
          }
          if (ilist0[j].startsWith("09_MRE95") && File.isDirectory(xdir + ilist0[j])) {
            i_E = j;
          }
        }
        fat_path = xdir + ilist0[i_F];
        water_path = xdir + ilist0[i_W];
        mre_path = xdir + ilist0[i_E];
        //XXXXXXXXX

        open(fat_path);
        init_dixon();
        roifile = pathExt("", "_dixon.zip");
        if(File.exists(roifile)) {
          generate_dixon_results("fat");
        }
        close();

        open(water_path);
        init_dixon();
        roifile = pathExt("", "_dixon.zip");
        if(File.exists(roifile)) {
          generate_dixon_results("water");
        }
        close();

        open(mre_path);
        init_mre();
        roifile = pathExt("", "_mre.zip");
        if(File.exists(roifile)) {
          generate_mre_results();
        }
        close();
      }
    }
  }
  //setBatchMode(false); 
}

function generate_density_results() {
    setBatchMode(true);
    ImageID = getImageID();
    Table.create("lifestyle");
    Table.setLocationAndSize(0, 410, 600, 600, "lifestyle");
    Table.showRowNumbers(false);
    Table.showRowIndexes(false);
    id = newArray;
    ts = newArray;
    label = newArray;
    type = newArray;
    value = newArray;
    for (i=0; i < RoiManager.size; i++) {
        RoiManager.select(i);
        name = RoiManager.getName(i);
        if (startsWith(name, "rkfat") || startsWith(name, "lkfat")) {
            fat = measure_threshold(-250, -50);
            id = Array.concat(id, Roi.getProperty("id"));
            ts = Array.concat(ts, Roi.getProperty("timestamp"));
            label = Array.concat(label, name);
            type = Array.concat(type, "area");
            value = Array.concat(value, fat);
        } else if (startsWith(name, "rkthick") || startsWith(name, "lkthick")) {
            length = get_length();
            id = Array.concat(id, Roi.getProperty("id"));
            ts = Array.concat(ts, Roi.getProperty("timestamp"));
            label = Array.concat(label, name);
            type = Array.concat(type, "length");
            value = Array.concat(value, length);
        } else if (startsWith(name, "aorta")) {
	    aid = Roi.getProperty("id");
	    ats = Roi.getProperty("timestamp");
            ca1 = measure_threshold(130, 199);
            ca2 = measure_threshold(200, 299);
            ca3 = measure_threshold(300, 399);
            ca4 = measure_threshold(400, 1500);
            ca = ca1 + ca2 * 2 + ca3 * 3 + ca4 * 4;
            id = Array.concat(id, aid);
            ts = Array.concat(ts, ats);
            label = Array.concat(label, name);
            type = Array.concat(type, "ca1");
            value = Array.concat(value, ca1);
            id = Array.concat(id, aid);
            ts = Array.concat(ts, ats);
            label = Array.concat(label, name);
            type = Array.concat(type, "ca2");
            value = Array.concat(value, ca2);
            id = Array.concat(id, aid);
            ts = Array.concat(ts, ats);
            label = Array.concat(label, name);
            type = Array.concat(type, "ca3");
            value = Array.concat(value, ca3);
            id = Array.concat(id, aid);
            ts = Array.concat(ts, ats);
            label = Array.concat(label, name);
            type = Array.concat(type, "ca4");
            value = Array.concat(value, ca4);
            id = Array.concat(id, aid);
            ts = Array.concat(ts, ats);
            label = Array.concat(label, name);
            type = Array.concat(type, "ca");
            value = Array.concat(value, ca);
        } else {
            getStatistics(area, mean);
            id = Array.concat(id, Roi.getProperty("id"));
            ts = Array.concat(ts, Roi.getProperty("timestamp"));
            label = Array.concat(label, name);
            type = Array.concat(type, "area");
            value = Array.concat(value, area);
            id = Array.concat(id, Roi.getProperty("id"));
            ts = Array.concat(ts, Roi.getProperty("timestamp"));
            label = Array.concat(label, name);
            type = Array.concat(type, "mean");
            value = Array.concat(value, mean);
        }
    }

    Table.setColumn("id", id);
    Table.setColumn("timestamp", ts);
    Table.setColumn("label", label);
    Table.setColumn("type", type);
    Table.setColumn("value", value);
    Table.save(create_path("_results.csv"));
    selectImage(ImageID);
    //setBatchMode(false);

    //close("lifestyle");
}

function generate_dixon_results(phase) {
  setBatchMode(true);
  ImageID = getImageID();
  Table.create("Measurement");
  Table.setLocationAndSize(0, 410, 600, 600, "Measurement");
  Table.showRowNumbers(false);
  Table.showRowIndexes(false);
  id = newArray;
  xid = newArray;
  ts = newArray;
  label = newArray;
  type = newArray;
  value = newArray;
  for (i=0; i < RoiManager.size; i++) {
    RoiManager.select(i);
    name = RoiManager.getName(i);
    getStatistics(area, mean);
    Roi.setProperty("id", getTag("0010,0020"));
    Roi.setProperty("xid", getXid(""));
    roifile = pathExt("", "_dixon.zip");
    roiManager("Save", roifile);

    id = Array.concat(id, Roi.getProperty("id"));
    xid = Array.concat(xid, Roi.getProperty("xid"));
    ts = Array.concat(ts, Roi.getProperty("timestamp"));
    label = Array.concat(label, "" + phase + "-" + name);
    type = Array.concat(type, "area");
    value = Array.concat(value, area);

    id = Array.concat(id, Roi.getProperty("id"));
    xid = Array.concat(xid, Roi.getProperty("xid"));
    ts = Array.concat(ts, Roi.getProperty("timestamp"));
    label = Array.concat(label, "" + phase + "-" + name);
    type = Array.concat(type, "mean");
    value = Array.concat(value, mean);
  }

  Table.setColumn("id", id);
  Table.setColumn("xid", xid);
  Table.setColumn("timestamp", ts);
  Table.setColumn("label", label);
  Table.setColumn("type", type);
  Table.setColumn("value", value);
  Table.save(pathExt("", "_dixon_"+phase+".csv"));
  selectImage(ImageID);
  //setBatchMode(false);

  //close("lifestyle");
}

function generate_mre_results() {
  setBatchMode(true);
  ImageID = getImageID();
  Table.create("Measurement");
  Table.setLocationAndSize(0, 410, 600, 600, "Measurement");
  Table.showRowNumbers(false);
  Table.showRowIndexes(false);
  id = newArray;
  xid = newArray;
  ts = newArray;
  label = newArray;
  type = newArray;
  value = newArray;
  for (i=0; i < RoiManager.size; i++) {
    RoiManager.select(i);
    name = RoiManager.getName(i);
    getStatistics(area, mean);

    Roi.setProperty("xid", getXid(""));
    roifile = pathExt("", "_mre.zip");
    roiManager("Save", roifile);

    id = Array.concat(id, Roi.getProperty("id"));
    xid = Array.concat(xid, Roi.getProperty("xid"));
    ts = Array.concat(ts, Roi.getProperty("timestamp"));
    label = Array.concat(label, name);
    type = Array.concat(type, "area");
    value = Array.concat(value, area);

    id = Array.concat(id, Roi.getProperty("id"));
    xid = Array.concat(xid, Roi.getProperty("xid"));
    ts = Array.concat(ts, Roi.getProperty("timestamp"));
    label = Array.concat(label, name);
    type = Array.concat(type, "mean");
    value = Array.concat(value, mean);


  }

  Table.setColumn("id", id);
  Table.setColumn("xid", xid);
  Table.setColumn("timestamp", ts);
  Table.setColumn("label", label);
  Table.setColumn("type", type);
  Table.setColumn("value", value);
  Table.save(pathExt("", "_mre.csv"));
  selectImage(ImageID);
  //setBatchMode(false);

  //close("lifestyle");
}

function gen_m_results() {
  setBatchMode(true);
  ImageID = getImageID();
  setBatchMode(true);
  Table.create("lifestyle");
  Table.setLocationAndSize(0, 410, 600, 600, "lifestyle");
  Table.showRowNumbers(false);
  Table.showRowIndexes(false);
  id = newArray;
  variable = newArray;
  value = newArray;
  //sid = get_sid();
  sid = getXid("");

  run("Set Measurements...", "area mean standard perimeter median skewness kurtosis display redirect=None decimal=3");

  area = 0;
  mean = 0;
  selectImage(ImageID);
  roiManager("deselect");
  RoiManager.selectGroup(group_qlum_3);
  if (RoiManager.selected > 0) {
    getStatistics(area, mean, min, max, std, histogram);
    id = Array.concat(id, sid);
    variable = Array.concat(variable, "qlum_area");
    value = Array.concat(value, area);

    id = Array.concat(id, sid);
    variable = Array.concat(variable, "qlum_mean");
    value = Array.concat(value, mean);
  }

  selectImage(ImageID);
  roiManager("deselect");
  RoiManager.selectGroup(group_psoas_3);
  if (RoiManager.selected > 0) {
    i_psoas = roiManager("index");
    getStatistics(area, mean, min, max, std, histogram);
    id = Array.concat(id, sid);
    variable = Array.concat(variable, "psoas_area");
    value = Array.concat(value, area);
    id = Array.concat(id, sid);
    variable = Array.concat(variable, "psoas_mean");
    value = Array.concat(value, mean);
  }

  selectImage(ImageID);
  roiManager("deselect");
  RoiManager.selectGroup(group_back_3);
  if (RoiManager.selected > 0) {
    getStatistics(area, mean, min, max, std, histogram);
    id = Array.concat(id, sid);
    variable = Array.concat(variable, "back_area");
    value = Array.concat(value, area);
    id = Array.concat(id, sid);
    variable = Array.concat(variable, "back_mean");
    value = Array.concat(value, mean);
  }

  selectImage(ImageID);
  roiManager("deselect");
  RoiManager.selectGroup(group_aw_3);
  if (RoiManager.selected > 0) {
    getStatistics(area, mean, min, max, std, histogram);
    id = Array.concat(id, sid);
    variable = Array.concat(variable, "aw_area");
    value = Array.concat(value, area);
    id = Array.concat(id, sid);
    variable = Array.concat(variable, "aw_mean");
    value = Array.concat(value, mean);
  }

  selectImage(ImageID);
  modality = getTag("0008,0060");
  if (matches(modality, ".*CT.*")) {
    create_body_selection(-300, 2048);
    perim = getValue("Perim.");
    id = Array.concat(id, sid);
    variable = Array.concat(variable, "body_perimeter");
    value = Array.concat(value, perim);
    getStatistics(area, mean, min, max, std, histogram);
    id = Array.concat(id, sid);
    variable = Array.concat(variable, "body_area");
    value = Array.concat(value, area);

    getPixelSize(unit, uwidth, uheight, udepth);
    getSelectionBounds(x, y, width, height);
    width *= uwidth;
    height *= uheight;
    id = Array.concat(id, sid);
    variable = Array.concat(variable, "body_thickness");
    value = Array.concat(value, height);
    id = Array.concat(id, sid);
    variable = Array.concat(variable, "body_width");
    value = Array.concat(value, width);
  }

  Table.setColumn("id", id);
  Table.setColumn("variable", variable);
  Table.setColumn("value", value);
  //Table.save(create_path("_muscle.csv"));
  Table.save(pathExt("", "_muscle.csv"));
  selectImage(ImageID);
  setBatchMode(false);
}

function gen_f_results() {
  setBatchMode(true);
  ImageID = getImageID();
  setBatchMode(true);
  Table.create("lifestyle");
  Table.setLocationAndSize(0, 410, 600, 600, "lifestyle");
  Table.showRowNumbers(false);
  Table.showRowIndexes(false);
  id = newArray;
  variable = newArray;
  value = newArray;
  //sid = get_sid();
  sid = getXid("");

  run("Set Measurements...", "area mean standard perimeter median skewness kurtosis display redirect=None decimal=3");

  selectImage(ImageID);
  roiManager("deselect");
  RoiManager.selectGroup(group_sat_3);
  getStatistics(area, mean, min, max, std, histogram);
  id = Array.concat(id, sid);
  variable = Array.concat(variable, "sat_area");
  value = Array.concat(value, area);
  id = Array.concat(id, sid);
  variable = Array.concat(variable, "sat_mean");
  value = Array.concat(value, mean);

  selectImage(ImageID);
  roiManager("deselect");
  RoiManager.selectGroup(group_vat_3);
  getStatistics(area, mean, min, max, std, histogram);
  id = Array.concat(id, sid);
  variable = Array.concat(variable, "vat_area");
  value = Array.concat(value, area);
  id = Array.concat(id, sid);
  variable = Array.concat(variable, "vat_mean");
  value = Array.concat(value, mean);

  selectImage(ImageID);
  modality = getTag("0008,0060");
  if (matches(modality, ".*CT.*")) {
    create_body_selection(-300, 2048);
    perim = getValue("Perim.");
    id = Array.concat(id, sid);
    variable = Array.concat(variable, "body_perimeter");
    value = Array.concat(value, perim);
    getStatistics(area, mean, min, max, std, histogram);
    id = Array.concat(id, sid);
    variable = Array.concat(variable, "body_area");
    value = Array.concat(value, area);

    getPixelSize(unit, uwidth, uheight, udepth);
    getSelectionBounds(x, y, width, height);
    width *= uwidth;
    height *= uheight;
    id = Array.concat(id, sid);
    variable = Array.concat(variable, "body_thickness");
    value = Array.concat(value, height);
    id = Array.concat(id, sid);
    variable = Array.concat(variable, "body_width");
    value = Array.concat(value, width);
  }

  Table.setColumn("id", id);
  Table.setColumn("variable", variable);
  Table.setColumn("value", value);
  //Table.save(create_path("_fat.csv"));
  Table.save(pathExt("", "_fat.csv"));
  selectImage(ImageID);
  setBatchMode(false);
}

function gen_results() {
	setBatchMode(true);
	ImageID = getImageID();
	setBatchMode(true);
	Table.create("lifestyle");
	Table.setLocationAndSize(0, 410, 600, 600, "lifestyle");
	Table.showRowNumbers(false);
	Table.showRowIndexes(false);
	id = newArray;
	variable = newArray;
	value = newArray;
	//sid = get_sid();
	sid = getXid("");

	run("Set Measurements...", "area mean standard perimeter median skewness kurtosis display redirect=None decimal=3");

	selectImage(ImageID);
	roiManager("deselect");
	RoiManager.selectGroup(group_sat_3);
	if (RoiManager.selected > 0) {
	    getStatistics(area, mean, min, max, std, histogram);
	    id = Array.concat(id, sid);
	    variable = Array.concat(variable, "sat_area");
	    value = Array.concat(value, area);
	    id = Array.concat(id, sid);
	    variable = Array.concat(variable, "sat_mean");
	    value = Array.concat(value, mean);
	}

	selectImage(ImageID);
	roiManager("deselect");
	RoiManager.selectGroup(group_vat_3);
	if (RoiManager.selected > 0) {
	    getStatistics(area, mean, min, max, std, histogram);
	    id = Array.concat(id, sid);
	    variable = Array.concat(variable, "vat_area");
	    value = Array.concat(value, area);
	    id = Array.concat(id, sid);
	    variable = Array.concat(variable, "vat_mean");
	    value = Array.concat(value, mean);
	}

	selectImage(ImageID);
	modality = getTag("0008,0060");
	if (matches(modality, ".*CT.*")) {
	    create_body_selection(-300, 2048);
	    perim = getValue("Perim.");
	    id = Array.concat(id, sid);
	    variable = Array.concat(variable, "body_perimeter");
	    value = Array.concat(value, perim);
	    getStatistics(area, mean, min, max, std, histogram);
	    id = Array.concat(id, sid);
	    variable = Array.concat(variable, "body_area");
	    value = Array.concat(value, area);

	    getPixelSize(unit, uwidth, uheight, udepth);
	    getSelectionBounds(x, y, width, height);
	    width *= uwidth;
	    height *= uheight;
	    id = Array.concat(id, sid);
	    variable = Array.concat(variable, "body_thickness");
	    value = Array.concat(value, height);
	    id = Array.concat(id, sid);
	    variable = Array.concat(variable, "body_width");
	    value = Array.concat(value, width);
	}

	area = 0;
	mean = 0;
	selectImage(ImageID);
	roiManager("deselect");
	RoiManager.selectGroup(group_qlum_3);
	if (RoiManager.selected > 0) {
	    getStatistics(area, mean, min, max, std, histogram);
	    id = Array.concat(id, sid);
	    variable = Array.concat(variable, "qlum_muscle_area");
	    value = Array.concat(value, area);

	    id = Array.concat(id, sid);
	    variable = Array.concat(variable, "qlum_muscle_mean");
	    value = Array.concat(value, mean);
	}

	selectImage(ImageID);
	roiManager("deselect");
	RoiManager.selectGroup(group_psoas_3);
	if (RoiManager.selected > 0) {
	    i_psoas = roiManager("index");
	    getStatistics(area, mean, min, max, std, histogram);
	    id = Array.concat(id, sid);
	    variable = Array.concat(variable, "psoas_muscle_area");
	    value = Array.concat(value, area);
	    id = Array.concat(id, sid);
	    variable = Array.concat(variable, "psoas_muscle_mean");
	    value = Array.concat(value, mean);
	}

	selectImage(ImageID);
	roiManager("deselect");
	RoiManager.selectGroup(group_back_3);
	if (RoiManager.selected > 0) {
	    getStatistics(area, mean, min, max, std, histogram);
	    id = Array.concat(id, sid);
	    variable = Array.concat(variable, "back_muscle_area");
	    value = Array.concat(value, area);
	    id = Array.concat(id, sid);
	    variable = Array.concat(variable, "back_muscle_mean");
	    value = Array.concat(value, mean);
	}

	selectImage(ImageID);
	roiManager("deselect");
	RoiManager.selectGroup(group_aw_3);
	if (RoiManager.selected > 0) {
	    getStatistics(area, mean, min, max, std, histogram);
	    id = Array.concat(id, sid);
	    variable = Array.concat(variable, "aw_muscle_area");
	    value = Array.concat(value, area);
	    id = Array.concat(id, sid);
	    variable = Array.concat(variable, "aw_muscle_mean");
	    value = Array.concat(value, mean);
	}

	Table.setColumn("id", id);
	Table.setColumn("variable", variable);
	Table.setColumn("value", value);
	//Table.save(create_path("_fat.csv"));
	Table.save(pathExt("", "_result.csv"));
	selectImage(ImageID);
	setBatchMode(false);
}

function update_info() {
    setBatchMode(true);
    print("\\Clear");
    print("["+num_n+"/"+num_N+"] "+sid);
    print("");
    print_group("[ 1 ] [ Q ] Abdominal Wall L3", group_aw_3);
    print_group("[ 1 ] [ W ] Psoas L3", group_psoas_3);
    print_group("[ 1 ] [ E ] Back L3", group_back_3);
    print_group("[ 1 ] [ Q ] Quadratus Lumborum L3", group_qlum_3);
    print("");
    print_group("[ 1 ] [ t ] TAT L3", group_tat_3);
    print_group("[ 1 ] [ o ] OAT L3", group_oat_3);
    print_group("[ 1 ] [ v ] SAT L3", group_sat_3);
    print_group("[ 1 ] [ s ] VAT L3", group_vat_3);
    print_group("[ n ] [ z ] Liver MRE", group_liver_mre);
/*
    print("");
    print_group("[ 4 ] [ A ] Liver", group_liver);
    print_group("[ 3 ] [ S ] Pancreas", group_pancreas);
    print_group("[ 3 ] [ D ] Spleen", group_spleen);
    print("");
    print_group("[ 1 ] [ Q ] R Kidney Sinus_Fat", group_rkfat);
    print_group("[ 1 ] [ W ] L Kidney Sinus_Fat", group_lkfat);
    print_group("[ 1 ] [ E ] R Kidney Thickness", group_rkthick);
    print_group("[ 1 ] [ R ] L Kidney Thickness", group_lkthick);
    print_group("[ 8 ] [ G ] Aorta", group_aorta);
*/
    print("");
    print("[ xmode ] "+ xmode);
    print("[ ipath ] "+ getIpath());
    print("[ ROIpath ] "+ pathROI(getIpath()));
    print("[ dir0  ] "+ get0dir(""));
    print("[ xdir  ] "+ getXdir(""));
    print("[ idir  ] "+ getIdir(""));
    print("[ xid   ] "+ getXid(""));
    //xlist = getXlist("");
    //print("[ xlist[0]] "+ xlist[0]);
    //print("[ xlist[1]] "+ xlist[1]);

    print("");
    //generate_results();
    if (RoiManager.size > 0) {
	roiManager("select", RoiManager.size - 1);
	roiManager("Deselect");
    }
    setBatchMode(false);
}

macro "init [0]" {
  init();
}

macro "Duplicate for fat work [9]" {
  init();

  run("Select None");
  getLocationAndSize(x, y, width, height);
  run("Duplicate...", "title="+fat_title);
  setLocation(x+width+10, y);
  run("Set... ", "zoom=150");
  
  File.copy(ipath, create_path("_fat.dcm"));
}

/*
macro "Set Fat Mask [f]" {
  init();

  run("Select None");
  getLocationAndSize(x, y, width, height);
  run("Duplicate...", "title="+fat_title);
  setLocation(x+width+10, y);
  run("Set... ", "zoom=150");
  
  File.copy(ipath, create_path("_fat.dcm"));

  if (Modality.contains("MR")) {
    setThreshold(64, 1024);
    run("Make Binary");
  } else {
    setThreshold(-250, -50);
    run("Convert to Mask");
  }

  //run("Display...", " "); //do not use Inverting LUT
  // run("Convert to Mask");
  run("Create Selection");
  selectWindow(Title);
  run("Restore Selection");
  selectWindow(fat_title);
  run("Select None");
  run("Add Image...", "image="+Title+" x=0 y=0 opacity=60");
  showStatus("Next Step: Total Fat then press [1]");
}
*/

function createMask(lower, upper) {
    //setBatchMode(true);
    // 1. 
    // To get the selection of the largest particle
    run("Select None");
    run("Duplicate...", " ");
	setThreshold(-1024, 2048);
	run("Convert to Mask");
	run("Erode");
	run("Analyze Particles...", "size=5000-Infinity pixel show=Masks");
	    run("Dilate");
	    run("Fill Holes");
	    run("Create Selection");
	close();
    close();

    // 2. 
    // get/set metadata
    iid = getImageID();
    title = getTitle;

    id = getTag("0010,0020");
    series = getTag("0020,0011");
    InstanceNumber = getTag("0020,0013");
    modality = getTag("0008,0060");

    id = replace(id, " ", "");
    series = replace(series, " ", "");
    InstanceNumber = replace(InstanceNumber, " ", "");


    xid = getXid("");
    xdir = getXdir("");
    xpath = getIpath();
    workingSlice = getSliceNumber();
    run("Select None");
    getLocationAndSize(x, y, width, height);

    // 3.
    // Duplicate
    run("Duplicate...", "title="+getTitle + "_mask ignore duplicate");
    Property.set("xid", xid);
    Property.set("xdir", xdir);
    Property.set("xpath", xpath);
    //showMessage("set xpath = " + xpath);
    Property.set("id", id);
    Property.set("series", series);
    Property.set("InstanceNumber", InstanceNumber);
    Property.set("workingSlice", workingSlice);
    //run("Duplicate...", "title="+getTitle + "_mask duplicate"); //stack duplicate
    iid2 = getImageID();
    setLocation(x+width+10, y);
    setThreshold(lower, upper);
    
    //run("Convert to Mask");   // slice dup
    //run("Convert to Mask", "method=Default background=Light create");
    run("Convert to Mask", "method=Default background=Default");


    //run("Display...", " "); //do not use Inverting LUT
    // run("Convert to Mask");
    run("Restore Selection"); // Largest body
    run("Clear Outside", "slice");
    run("Create Selection");
    selectImage(iid);
    run("Restore Selection");
    selectImage(iid2);
    setBatchMode(false);
    //run("Select None");
    //run("Add Image...", "image="+title+" x=0 y=0 opacity=60");
}

function createMask1() {
    // Manual threshold for fat
    //setBatchMode(true);
    // 1. 
    // To get the selection of the largest particle
    run("Select None");
    run("Duplicate...", " ");
	setThreshold(-1024, 2048);
	run("Convert to Mask");
	run("Erode");
	run("Analyze Particles...", "size=5000-Infinity pixel show=Masks");
	    run("Dilate");
	    run("Fill Holes");
	    run("Create Selection");
	close();
    close();

    // 2. 
    // get/set metadata
    iid = getImageID();
    title = getTitle;

    id = getTag("0010,0020");
    series = getTag("0020,0011");
    InstanceNumber = getTag("0020,0013");
    modality = getTag("0008,0060");

    id = replace(id, " ", "");
    series = replace(series, " ", "");
    InstanceNumber = replace(InstanceNumber, " ", "");


    xid = getXid("");
    xdir = getXdir("");
    xpath = getIpath();
    workingSlice = getSliceNumber();
    run("Select None");
    getLocationAndSize(x, y, width, height);

    // 3.
    // Duplicate
    run("Duplicate...", "title="+getTitle + "_mask ignore duplicate");
    Property.set("xid", xid);
    Property.set("xdir", xdir);
    Property.set("xpath", xpath);
    //showMessage("set xpath = " + xpath);
    Property.set("id", id);
    Property.set("series", series);
    Property.set("InstanceNumber", InstanceNumber);
    Property.set("workingSlice", workingSlice);
    //run("Duplicate...", "title="+getTitle + "_mask duplicate"); //stack duplicate
    iid2 = getImageID();
    setLocation(x+width+10, y);
    run("Threshold...");
    title = "Wait";
    msg = "If necessary, use the \"Threshold\" tool to\nadjust the threshold, then click \"OK\".";
    waitForUser(title, msg);
    selectImage(iid2);
    getThreshold(lower, upper);
    // setThreshold(lower, upper);
    
    //run("Convert to Mask");   // slice dup
    //run("Convert to Mask", "method=Default background=Light create");
    run("Convert to Mask", "method=Default background=Default");


    //run("Display...", " "); //do not use Inverting LUT
    // run("Convert to Mask");
    run("Restore Selection"); // Largest body
    run("Clear Outside", "slice");
    run("Create Selection");
    selectImage(iid);
    run("Restore Selection");
    selectImage(iid2);
    setBatchMode(false);
    //run("Select None");
    //run("Add Image...", "image="+title+" x=0 y=0 opacity=60");
}


macro "Set Manual Fat Mask after duplicate and threshold [F]" {
  if (Modality.contains("MR")) {
    run("Make Binary");
  } else {
    run("Convert to Mask");
  }

  //run("Display...", " "); //do not use Inverting LUT
  // run("Convert to Mask");
  run("Create Selection");
  selectWindow(Title);
  run("Restore Selection");
  selectWindow(fat_title);
  run("Select None");
  run("Add Image...", "image="+Title+" x=0 y=0 opacity=60");
  showStatus("Next Step: Total Fat then press [F1]");
}

macro "SaveErrorFOV [f5]" {
  SF = -1;
  TF = -1;
  VF = -1;
  FatResults();
  showMessage(getTitle+" out of FOV saved!");
  save(create_path("_error.png"));
}

function saveROI() {

    run("Set Measurements...", "area mean standard perimeter median skewness kurtosis display redirect=None decimal=3");
    roiManager("Deselect");
    run("Clear Results");
    roiManager("Measure");
    saveAs("Results",  create_path("_results.csv"));
    roiManager("Save", create_path("_roi.zip"));

    if (endsWith(getInfo("image.filename"), ".nii.gz")) {
	showMessage(create_path("_results.csv") + " saved!");
    } else {
	showMessage(id + " saved!");
    }
  }
}


//macro "SelectFile [F8]" {
//  FatLogfile = File.openDialog("Select a File");
//}

//macro "Set Data Directory [0]" {
// setDir();
//}


macro "Calculate Aorta Calcification Ratio base [a]" {
  Patientname = getTag("0010,0010");
  PatientID = getTag("0010,0020");
  studyid = getTag("0020,0010");
  series = getTag("0020,0011");
  image = getTag("0020,0013");

  // if (AortaImgDir == "")
  //  setDir();
  // ImgDir = AortaImgDir + id + File.separator;
  ImgDir = getDirectory("image") + "work" + File.separator;
  if(!File.exists(ImgDir)) File.makeDirectory(ImgDir);

  save(ImgDir + id + "-S"+studyid+"s"+series+"i"+image + "-0Aorta.png");
}

/*
macro "Calculate Aorta Calcification Ratio [9]" {
  run("Duplicate...", "title="+getTitle());
  run("Set... ", "zoom=150");
  run("Make Inverse");
  setColor(-100);
  fill();
  run("Select None");
  getStatistics(nPixels, mean, min, max, std, histogram);
  name = getTag("0010,0010");
  id = getTag("0010,0020");
  studyid = getTag("0020,0010");
  series = getTag("0020,0011");
  image = getTag("0020,0013");

  Iid = getImageID();
  // if (AortaImgDir == "")
    setDir();
  ImgDir = AortaImgDir + id + File.separator;
  if(!File.exists(ImgDir)) File.makeDirectory(ImgDir);

  time = replace(getTime,"E12","");
  time = replace(time, "\\\.", "");
  save(ImgDir + id + "-S"+studyid+"s"+series+"i"+image + "-"+time + "-1Aorta.png");
  t = getTitle();
  run("Duplicate...", "title="+t+"-Ao");
  Aoid = getImageID();
  run("Duplicate...", "title="+t+"-Ca");
  Caid = getImageID();
  time = replace(getTime,"E12","");
  time = replace(time, "\\\.", "");

  // calculate aorta
  selectImage(Aoid);
  run("Set... ", "zoom=150");
  setThreshold(-25, 100);
  run("Convert to Mask");
  save(ImgDir + id + "-S"+studyid+"s"+series+"i"+image + "-"+time + "-2Aorta.png");
  setThreshold(255, 255);
  run("Create Selection");
  run("Measure");
  Ao = getResult("Area");
  //close();
  // calculate Calcification
  selectImage(Caid);
  run("Set... ", "zoom=150");
  setThreshold(100,1500);
  run("Convert to Mask");

  save(ImgDir + id + "-S"+studyid+"s"+series+"i"+image + "-"+time + "-3Aorta.png");
  if (max < 100) // in case there's no calficication at all
    Ca = 0;
  else
  {
    setThreshold(255, 255);
    run("Create Selection");
    run("Measure");
    Ca = getResult("Area");
  }
  //close();

  // log
  setDir();
  if (Ao == 0 && Ca == 0)
  {
    showMessage("Selection error!");
  }
  else
  {
    All = Ao + Ca;
    File.append("S"+studyid+"s"+series+"i"+image + "-"+time+","+id+","+name+","+All+","+Ao+","+Ca, AortaLogfile);
    // showMessage(getTitle+" saved! "+ " min: "+ min + ", max: " +max +", Ao: "+Ao+", Ca: "+Ca);
  close();
  close();
  close();
  }
}

macro "Calculate Calcification Area [8]" {
  run("Duplicate...", "title="+getTitle());
  run("Make Inverse");
  setColor(-100);
  fill();
  run("Select None");
  getStatistics(nPixels, mean, min, max, std, histogram);
  name = getTag("0010,0010");
  id = getTag("0010,0020");
  studyid = getTag("0020,0010");
  series = getTag("0020,0011");
  image = getTag("0020,0013");

  Iid = getImageID();
  if (CaImgDir == "")
  {
    CaImgDir = getDirectory("Choose a Directory");
    showMessage(CaImgDir);
  }
  ImgDir = CaImgDir + id + File.separator;
  if(!File.exists(ImgDir)) File.makeDirectory(ImgDir);

  time = replace(getTime,"E12","");
  time = replace(time, "\\\.", "");
  save(ImgDir + id + "-S"+studyid+"s"+series+"i"+image + "-"+time + "-1.png");

  selectImage(Iid);
  run("Set... ", "zoom=150");
  getStatistics(nPixels, mean, min, max, std, histogram);
  setThreshold(150,1500);
  run("Convert to Mask");

  save(ImgDir + id + "-S"+studyid+"s"+series+"i"+image + "-"+time + ".png");
  if (max < 100) // in case there's no calficication at all
    Ca = 0;
  else
  {
    setThreshold(255, 255);
    run("Create Selection");
    run("Measure");
    Ca = getResult("Area");
  }

  // log
  if (CaLogfile == "")
  {
    CaLogfile = getDirectory("Choose a Directory") + "stats.csv";
    showMessage(CaLogfile);
  }
  File.append("S"+studyid+"s"+series+"i"+image + "-"+time+","+id+","+name+","+Ca, CaLogfile);
  showMessage("Ca: " + Ca);
  close();

}

*/

macro "Duplicate [D]" {
  getLocationAndSize(x, y, width, height);
  run("Duplicate...", "title="+getTitle());
  //setLocation(x+200, y+50, width, height);
  //run("Set... ", "zoom=150");

}

//macro "Set Fat Shrethold [F12]" {
//  setThreshold(-250, -50);
//}

/*
macro "update results [s]" {
    run("Set Measurements...", "area mean standard min perimeter median display redirect=None decimal=3");
    roiManager("Deselect");
    run("Clear Results");
    roiManager("Measure");
    saveAs("Results",  create_path("_results.csv"));
    roiManager("Save", create_path("_roi.zip"));
}

macro "Convert to Mask [s]" {
//  setThreshold(-250, -50);
  if (matches(Modality, ".*MR.*")){
    setThreshold(50, 255);
//    run("Options...", "iterations=1 black count=1"); //set black background
//    run("Colors...", "foreground=white background=black selection=red"); //set colors
  }
  else {
    setThreshold(-250, -50);
  }


  run("Convert to Mask");
}
*/

macro "Fill [l]" {
  fill();
}


//macro "Pencil [p]" {
//  setTool(18);
//}

//macro "Brush [b]" {
//  setTool("brush");
//}

macro "Elliptical [E]" {
    setTool("oval");
    //setTool("polygon");
}

macro "Select None [r]" {
  run("Select None");
}

macro "WandSelect [c]" {
  wandSelect("4-connected");
}

macro "WandSelect [v]" {
  wandSelect("4-connected");
  //wandSelect("Legacy");
}

macro "WaterShed [W]" {
  run("Watershed");
}

macro "Wand [w]" {
  setTool("wand");
}

macro "Line [Z]" {
  setTool("Line");
}

macro "Clear Outside [X]" {
  run("Clear Outside", "slice");
}


macro "Show Info [I]" {
  name = getTag("0010,0010");
  id = getTag("0010,0020");
  date = getTag("0008,0020");
  //l = getInfo("slice.label");
  getDimensions(width, height, channels, slices, frames);
  // showMessage("  id: " + id + "\nname: " + name + "\nslices: "+ slices);
  // showMessage("  id: " + id + "\nname: " + name + "\nslices: "+ slices+ "\ndate: "+date);
  // showMessage("  id: " + id + "\nname: " + name + "\nslices: ", slices);
  showMessage(date);
}

function wandSelect(mode) {
  getCursorLoc(x, y, z, flags);
  setKeyDown("shift");
  doWand(x,y,0,mode);
  //doWand(x,y);
}


// This function returns the numeric value of the 
// specified tag (e.g., "0018,0050"). Returns NaN 
// (not-a-number) if the tag is not found or it 
// does not have a numeric value.
function getNumericTag(tag) {
    value = getTag(tag);
    if (value=="") return NaN;
    index3 = indexOf(value, "\\");
    if (index3>0)
      value = substring(value, 0, index3);
    value = 0 + value; // convert to number
    return value;
  }

// This function returns the value of the specified 
// tag  (e.g., "0010,0010") as a string. Returns "" 
// if the tag is not found.
function getTag(tag) {
    info = getImageInfo();
    index1 = indexOf(info, tag);
    if (index1==-1) return "";
    index1 = indexOf(info, ":", index1);
    if (index1==-1) return "";
    index2 = indexOf(info, "\n", index1);
    value = substring(info, index1+1, index2);
    value = replace(value, " ", "");
    return value;
}



function setDir ()
{
  if (DataDir == "")
      DataDir = getDirectory("Choose a Directory for Data Saving");

  FatImgDir = DataDir + "Fat" + File.separator;
  if(!File.exists(FatImgDir)) File.makeDirectory(FatImgDir);
  AortaImgDir = DataDir + "Aorta" + File.separator;
  if(!File.exists(AortaImgDir)) File.makeDirectory(AortaImgDir);
  AortaLogfile = DataDir + "aorta.csv";
}

/*
macro "TTT [v]" {
    showMessage(getImageInfo());
    showMessage(getTitle());
    showMessage(getInfo("image.subtitle"));
    getDimensions(width, height, channels, slices, frames);
    //ShowMessage(Dim[0]+Dim[1]+Dim[2]+Dim[3]+Dim[4]);
    showMessage(getSliceNumber()+"/"+slices);
}
*/


//macro "Create Selection [s]" {
//    run("Create Selection");
//}

macro "Scale Bar [B]" {
    run("Scale Bar...");
}

macro "Close All Other Image Windows [Q]" {
    close("\\Others");
}

function addROI(tag, group_id) {
    if (selectionType >= 0) {
	Roi.setName(tag);
	Roi.setGroupNames(tag);
	Roi.setGroup(group_id);

	Roi.setPosition(getSliceNumber());
	if (workingSlice > 1) 
	    Roi.setPosition(workingSlice);

	Roi.setProperty("timestamp", timestamp());
	Roi.setProperty("xid", Property.get("xid"));
	Roi.setProperty("xdir", Property.get("xdir"));
	Roi.setProperty("id", Property.get("id"));
	Roi.setProperty("studyid", Property.get("studyid"));
	Roi.setProperty("series", Property.get("series"));
	Roi.setProperty("InstanceNumber", Property.get("InstanceNumber"));
	Roi.setProperty("workingSlice", Property.get("workingSlice"));

	roiManager("add");
	showStatus("Added ROI: " + Property.get("xid") + ":" + tag);
    } else {
	showStatus("No ROI to add");
    }
}

function addROI1 (tag, group_id) {
    RoiManager.selectGroup(group_id);
    if (RoiManager.selected > 0) {
	roiManager("delete");
    }
    addROI(tag, group_id);
}

function addMask (tag, group_id) {
    if (selectionType >= 0) {
	run("Clear Outside", "slice");
    }
    run("Create Selection");
    addROI(tag, group_id);
    if (selectionType >= 0) {
	run("Undo");
    }
    run("Restore Selection");
    update_results();
}

function addMask1 (tag, group_id) {
    run("ROI Manager...");
    RoiManager.selectGroup(group_id);
    if (RoiManager.selected > 0) {
	roiManager("delete");
    }
    addMask(tag, group_id);
}


function create_path(ext) {
  WorkDir = idir + "work" + File.separator;
  if(!File.exists(WorkDir)) File.makeDirectory(WorkDir);

  filename = WorkDir + get_sid() + ext;
  return filename;
}

function create_series_path(ext) {
  WorkDir = idir + "work" + File.separator;
  if(!File.exists(WorkDir)) File.makeDirectory(WorkDir);

  filename = WorkDir + get_sid() + ext;
  return filename;
}


//--------------------------------------- For ROI measurement
// "ROI measurement Macro"
// [0] initialize 
// [1] create oval ROI sized 10 pixel centered on the mouse pointer
// [2] create oval ROI sized 20 pixel centered on the mouse pointer
// [3] create oval ROI sized 30 pixel centered on the mouse pointer
// [4] create oval ROI sized 40 pixel centered on the mouse pointer
// [5] create oval ROI sized 50 pixel centered on the mouse pointer
// [a] save ROI to _result.csv, roiManager, labeled as 'liver', clear and update roimanager measurement
// [s] save ROI to _result.csv, roiManager, labeled as 'pancreas', clear and update roimanager measurement
// [d] save ROI to _result.csv, roiManager, labeled as 'spleen', clear and update roimanager measurement
// [q] save ROI to _result.csv, roiManager, labeled as 'rkfat', clear and update roimanager measurement
// [w] save ROI to _result.csv, roiManager, labeled as 'lkfat', clear and update roimanager measurement
// [e] save ROI length to _result.csv, roiManager, labeled as 'rkthick', clear and update roimanager measurement
// [r] save ROI length to _result.csv, roiManager, labeled as 'lkthick', clear and update roimanager measurement
// [g] save calcium score to _result.csv, ROI to roiManager, labeled as 'Aorta', clear and update roimanager measurement
// [c] next slice
// [x] previous slice
// [C] open next case     
// [X] open previous case 
// [n] save ROI to roiManager, labeled as 'liver', clear and update roimanager measurement
// [Z] save ROI to roiManager, labeled as 'liver', clear and update roimanager measurement

macro "init [0]" {
	init();
}

macro "Oval_10 [1]" {
    setTool("oval");
    getCursorLoc(x, y, z, flags);
    makeOval(x-5, y-5, 10, 10); 
}

macro "Oval_20 [2]" {
    setTool("oval");
    getCursorLoc(x, y, z, flags);
    makeOval(x-10, y-10, 20, 20); 
}

macro "Oval_30 [3]" {
    setTool("oval");
    getCursorLoc(x, y, z, flags);
    makeOval(x-15, y-15, 30, 30); 
}

macro "Oval_40 [4]" {
    setTool("oval");
    getCursorLoc(x, y, z, flags);
    makeOval(x-20, y-20, 40, 40); 
}

macro "Oval_50 [5]" {
    setTool("oval");
    getCursorLoc(x, y, z, flags);
    makeOval(x-25, y-25, 50, 50); 
}




macro "update results [U]" {
    update_results();
}

function update_results() {
    roiManager("Deselect");
    ROIpath = pathROI("");
    if (RoiManager.size > 0) {
	roiManager("Save", pathROI(""));
    } else {
	if (File.exists(pathROI(""))) {
	    File.delete(pathROI(""));
	}
    }
    update_info();
    //if (!isActive(ImageID)) {
	//print("select", ImageID);
	//selectImage(ImageID);
    //}
}

function update_tarsus() {
    update_results();
    ImageID = getImageID();
    Title = getTitle();
    //setBatchMode(true);
    id = newArray;
    variable = newArray;
    value = newArray;
    sid = get_sid();

    run("Set Measurements...", "area mean standard perimeter median skewness kurtosis display redirect=None decimal=3");

    selectImage(ImageID);

    id = Array.concat(id, sid);
    variable = Array.concat(variable, "width");
    value = Array.concat(value, getWidth());

    id = Array.concat(id, sid);
    variable = Array.concat(variable, "height");
    value = Array.concat(value, getHeight());

    roiManager("deselect");
    RoiManager.selectGroup(group_ccn);
    if (RoiManager.selected == 1) {
	getLine(x1, y1, x2, y2, lineWidth);
	rid = Roi.getProperty("id");

	id = Array.concat(id, rid);
	variable = Array.concat(variable, "calcaneus_x1");
	value = Array.concat(value, x1);

	id = Array.concat(id, rid);
	variable = Array.concat(variable, "calcaneus_y1");
	value = Array.concat(value, y1);

	id = Array.concat(id, rid);
	variable = Array.concat(variable, "calcaneus_x2");
	value = Array.concat(value, x2);

	id = Array.concat(id, rid);
	variable = Array.concat(variable, "calcaneus_y2");
	value = Array.concat(value, y2);
    }
    RoiManager.selectGroup(group_5mt);
    if (RoiManager.selected == 1) {
	getLine(x1, y1, x2, y2, lineWidth);
	rid = Roi.getProperty("id");

	id = Array.concat(id, rid);
	variable = Array.concat(variable, "5mt_x1");
	value = Array.concat(value, x1);

	id = Array.concat(id, rid);
	variable = Array.concat(variable, "5mt_y1");
	value = Array.concat(value, y1);

	id = Array.concat(id, rid);
	variable = Array.concat(variable, "5mt_x2");
	value = Array.concat(value, x2);

	id = Array.concat(id, rid);
	variable = Array.concat(variable, "5mt_y2");
	value = Array.concat(value, y2);
    }

    Table.reset("Results");
    //Table.setLocationAndSize(0, 410, 600, 600, "lifestyle");
    Table.showRowNumbers(false);
    Table.showRowIndexes(false);
    Table.setColumn("id", id);
    Table.setColumn("variable", variable);
    Table.setColumn("value", value);
    Table.save(pathCSV(""));
    Table.reset("Results");
    selectImage(ImageID);
}

macro "Measure areas [A]" {
    setThreshold(255, 255);
    run("Create Selection");
    run("Measure");
}

macro "set_slice [V]" {
    nSlice = getSliceNumber();
}

var nSlice = 0;
var workingSlice = 0;
function mid_slice() {
    if (nSlice == 0) {
	nSlice = getSliceNumber();
    } else {
	n = floor((nSlice + getSliceNumber())/2);
	setSlice(n);
	setTool("polygon");
	nSlice = 0;
    }
}

function measure_threshold(lower, upper) {
    run("Duplicate...", "title="+getTitle());
    //? run("Make Inverse");
    getStatistics(area, mean, min, max);
    if (max < lower) {
	//close();
	return 0;
    }
    if (upper < min) {
	//close();
	return 0;
    }
    if (max < upper)
	upper = max;
    setThreshold(lower, upper);
    //run("Convert to Mask", "method=Default background=Default");
    //setThreshold(255, 255);
    run("Create Selection");
    getStatistics(area);
    close();
    return area;
}

macro "Delete last ROI Manager [h]" {
    slice_n = getSliceNumber();
    if (RoiManager.size > 0) {
	roiManager("Deselect");
        RoiManager.select(RoiManager.size - 1);
	roiManager("delete");
    }
    update_results();
    if (RoiManager.size > 0) {
        RoiManager.select(RoiManager.size - 1);
	roiManager("Deselect");
    }
    //setSlice(slice_n);

}

macro "Double Flip [H]" {
    run("Flip Horizontally", "stack");
    run("Flip Vertically", "stack");
}

function timestamp() {
     MonthNames = newArray("01","02","03","04","05","06","07","08","09","10","11","12");
     getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
     TimeString ="";
     if (dayOfMonth<10) {TimeString = TimeString+"0";}
     TimeString = ""+year+""+MonthNames[month]+""+dayOfMonth+""+TimeString;
     if (hour<10) {TimeString = TimeString+"0";}
     TimeString = TimeString+hour+"";
     if (minute<10) {TimeString = TimeString+"0";}
     TimeString = TimeString+minute+"";
     if (second<10) {TimeString = TimeString+"0";}
     TimeString = TimeString+second;

     return TimeString; // Prints the time stamp
}

/*
macro "Create fat mask [f]" {
    createMask(-250, -50);
}

macro "test [9]" {
    // print("["+getInfo("image.filename")+"]");
    // print(File.name);
    // print(getInfo("image.directory"));
    border2selection();
}
*/

/*
macro "Load [0]" {
    // print("["+getInfo("image.filename")+"]");
    // print(File.name);
    // print(getInfo("image.directory"));
    //border2selection();
    roiManager("reset");
    roiManager("Open", getDir("image")+File.getNameWithoutExtension(getInfo("image.filename"))+".zip");
    //RoiManager.select(0);
    nextROI();
}

macro "test [8]" {
    updateROI("Grade1", 1);
}

macro "Set Grade 1 [1]" {
    updateROI("Grade1", 1);
}

macro "Set Grade 2 [2]" {
    updateROI("Grade2", 2);
}

macro "Set Grade 3 [3]" {
    updateROI("Grade3", 3);
}

macro "Set Grade 4 [4]" {
    updateROI("Grade4", 4);
}

macro "Set Grade 5 [5]" {
    updateROI("Grade5", 5);
}

macro "Select Grade 1 [a]" {
    selectROI("Grade1");
}
macro "Select Grade 2 [b]" {
    selectROI("Grade2");
}
macro "Select Grade 3 [c]" {
    selectROI("Grade3");
}
macro "Select Grade 4 [d]" {
    selectROI("Grade4");
}
macro "Select Grade 5 [e]" {
    selectROI("Grade5");
}

macro "save masks [s]" {
    save_mask();
}

macro "Show all ROIs [A]" {
    roiManager("select", Array.getSequence(RoiManager.size));
    roiManager("Combine");
}

macro "next ROI [n]" {
    nextROI();
}

macro "mask2selection [9]" {
    mask2selection(1);
}

function border2selection () {
    dir1 = getDirectory("Choose Source Directory ");
    list = getFileList(dir1);
    setBatchMode(true);
    for (j=0; j<list.length; j++) {
	showProgress(j+1, list.length);
	if (endsWith(list[j], "png")) {
	    roiManager("reset");
	    open(dir1+list[j]);
	    //run("Duplicate...", "title="+getTitle);
	    //run("Color Threshold...");
	    // Color Thresholder 2.1.0/1.53k
	    // Autogenerated macro, single images only!
	    min=newArray(3);
	    max=newArray(3);
	    filter=newArray(3);
	    a=getTitle();
	    run("RGB Stack");
	    run("Convert Stack to Images");
	    selectWindow("Red");
	    rename("0");
	    selectWindow("Green");
	    rename("1");
	    selectWindow("Blue");
	    rename("2");
	    min[0]=255;
	    max[0]=255;
	    filter[0]="pass";
	    min[1]=0;
	    max[1]=0;
	    filter[1]="pass";
	    min[2]=0;
	    max[2]=0;
	    filter[2]="pass";
	    for (i=0;i<3;i++){
	      selectWindow(""+i);
	      setThreshold(min[i], max[i]);
	      run("Convert to Mask");
	      if (filter[i]=="stop")  run("Invert");
	    }
	    imageCalculator("AND create", "0","1");
	    imageCalculator("AND create", "Result of 0","2");
	    for (i=0;i<3;i++){
	      selectWindow(""+i);
	      close();
	    }
	    selectWindow("Result of 0");
	    close();
	    selectWindow("Result of Result of 0");
	    rename(a);
	    // Colour Thresholding-------------
	    // run("Close");
	    run("Fill Holes");
	    run("Create Selection");
	    
	    Roi.setName("All");
	    Roi.setGroup(7);
	    Roi.setPosition(getSliceNumber());
	    Roi.setProperty("timestamp", timestamp());
	    Roi.setProperty("id", a);
	    Roi.setGroupNames("All");
	    Roi.setStrokeColor("white");
	    roiManager("add");
	    RoiManager.select(0);
	    run("Analyze Particles...", "clear composite");
	    if (nResults > 1) {
		roiManager("Split");
		RoiManager.select(0);
		roiManager("delete");
	    }
	    i_del = newArray();
	    for (i = 0; i < RoiManager.size; i++) {
		RoiManager.select(i);
		getStatistics(area);
		if (area < 16)
		    i_del = Array.concat(i_del, i);
	    }
	    if (i_del.length > 0) {
		roiManager("select", i_del);
		roiManager("delete");
	    }
	    roiManager("select", Array.getSequence(RoiManager.size));
	    RoiManager.setGroup(7);
	    roiManager("Save", dir1+File.getNameWithoutExtension(list[j])+".zip");
	    close();
	}
    }
    setBatchMode(false);
}

function mask2selection(value) {
    dir1 = getDirectory("Choose Source Directory ");
    list = getFileList(dir1);
    setBatchMode(true);
    for (j=0; j<list.length; j++) {
	showProgress(j+1, list.length);
	if (endsWith(list[j], "tif")) {
	    roiManager("reset");
	    open(dir1+list[j]);
	    setThreshold(value, value);
	    //run("Duplicate...", "title="+getTitle);
	    //run("Color Threshold...");
	    // Color Thresholder 2.1.0/1.53k
	    // Autogenerated macro, single images only!
	    run("Create Selection");
	    
	    Roi.setName("Psoriasis");
	    Roi.setGroup(7);
	    Roi.setPosition(getSliceNumber());
	    Roi.setProperty("timestamp", timestamp());
	    Roi.setProperty("id", getTitle());
	    Roi.setGroupNames("All");
	    Roi.setStrokeColor("white");
	    roiManager("add");
	    RoiManager.select(0);
	    run("Analyze Particles...", "clear composite");
	    if (nResults > 1) {
		roiManager("Split");
		RoiManager.select(0);
		roiManager("delete");
	    }
	    roiManager("select", Array.getSequence(RoiManager.size));
	    RoiManager.setGroup(7);
	    roiManager("Save", dir1+File.getNameWithoutExtension(list[j])+".zip");
	    close();
	}
    }
    setBatchMode(false);
}

function updateROI(tag, group_id) {
    ix = roiManager("index");
    if (selectionType >= 0) {
	Roi.setName(tag);
	Roi.setGroup(group_id);
	Roi.setGroupNames(tag);
	//Roi.setPosition(getSliceNumber());
	Roi.setProperty("timestamp", timestamp());
	Roi.setProperty("id", getInfo("image.filename"));
	if (ix >= 0) {
	    // roiManager("add");
	    // RoiManager.select(ix);
	    // roiManager("delete");
	    roiManager("update");
	    roiManager("rename", tag);
	    roiManager("Save", getDir("image")+File.getNameWithoutExtension(getInfo("image.filename"))+".zip");
	    // RoiManager.select(ix+1);
	    nextROI();
	}
    } 
}

function selectROI(Name) {
    ix = newArray();
    for (i = 0; i < RoiManager.size; i++) {
	if (startsWith(RoiManager.getName(i), Name)) {
	    ix = Array.concat(ix, i);
	}
    }
    roiManager("select", ix);
    roiManager("Combine");
}

function nextROI() {
    if (RoiManager.size > 0) {
	for (i = roiManager("index")+1; i < RoiManager.size; i++) {
	    if (!startsWith(RoiManager.getName(i), "Grade")) {
		RoiManager.select(i);
		run("To Selection");
		run("Out [-]");
		current_zoom = getZoom();
		getSelectionBounds(sx, sy, sw, sh); 
		if (sw < 500 || sh < 500)
		    run("Out [-]");
		exit();
	    }
	}
    }
}

function save_mask() {
    grades = newArray("Grade1", "Grade2", "Grade3", "Grade4", "Grade5");
    setBatchMode(true);
    for (i = 0; i < grades.length; i++) {
	m_file = getDir("image")+File.getNameWithoutExtension(getInfo("image.filename"))+"_grade"+ (i+1) +".png";
	selectROI(grades[i]);
	run("Create Mask");
	run("Invert");
	save(m_file);
	close();
    }
    setBatchMode(false);
}


function overlay_selection() {
    cwd = getDirectory("Choose Source Directory ");
    setBatchMode(true); 
    list = getFileList(cwd);
    for (i = 0; i < list.length; i++) {
	if (endsWith(list[i], "JPG")) {
	    print(i + ": " + list[i]);
	    fname = File.getNameWithoutExtension(list[i]);
	    ly2roi = "LY2_" + fname + "_roi.zip";
	    lw2roi = "LW2_" + fname + "_roi.zip";
	    lyroi = "LY_" + fname + "_roi.zip";
	    lwroi = "LW_" + fname + "_roi.zip";

	    open(cwd + list[i]);

	    Overlay.clear;
	    roiManager("reset");
	    if (File.exists(cwd + ly2roi)) {
		roiManager("open", cwd+ly2roi);
		for (j = 0; j < RoiManager.size; j++) {
		    if (matches(RoiManager.getName(j), ".*lesion.*")) {
			RoiManager.select(j);
		        Overlay.addSelection("blue", 5);
		    }
		}
	    }
	    roiManager("reset");
	    if (File.exists(cwd + lw2roi)) {
		roiManager("open", cwd+lw2roi);
		for (j = 0; j < RoiManager.size; j++) {
		    if (matches(RoiManager.getName(j), ".*lesion.*")) {
			RoiManager.select(j);
		        Overlay.addSelection("red", 5);
		    }
		}
	    }
	    roiManager("reset");
	    if (File.exists(cwd + lyroi)) {
		roiManager("open", cwd+lyroi);
		for (j = 0; j < RoiManager.size; j++) {
		    if (matches(RoiManager.getName(j), ".*lesion.*")) {
			RoiManager.select(j);
		        Overlay.addSelection("cyan", 5);
		    }
		}
	    }
	    roiManager("reset");
	    if (File.exists(cwd + lwroi)) {
		roiManager("open", cwd+lwroi);
		for (j = 0; j < RoiManager.size; j++) {
		    if (matches(RoiManager.getName(j), ".*lesion.*")) {
			RoiManager.select(j);
		        Overlay.addSelection("green", 5);
		    }
		}
	    }
	    Overlay.flatten;
	    //print(list[i] + ": done");
	    save(cwd + fname + "_overlay.jpg");
	    close();
	    close();
	}
    }
    setBatchMode(false); 
}
*/


//group colors
//0 default
//1 blue
//2 red
//3 green
//4 #000033 dark blue
//5 #ff00b6 magenta
//6 #005300 dark green
//7 #ffd300 yellow
//8 #009fff sky blue
//9 #9a4d42 gray
//10 #00ffbe light green

function addSeg() {
    for_vat = 1;
    if (for_vat == 1) {
	seg = newArray("bg", "SAT_u", "VAT_u", "soft_u", "bone_u", "psoas_u", "back_u", "aw_u", "body_u");
	gid = newArray(0, group_sat_u, group_vat_u, group_soft_u, group_bone_u, group_psoas_u, group_back_u, group_aw_u, group_body_u);
	for (i = 1; i <= 7; i++) {
	    setThreshold(i, i);
	    run("Create Selection");
	    if (selectionType >= 0) {
		Roi.setName(seg[i]);
		Roi.setGroup(gid[i]);
		//Roi.setPosition(getSliceNumber());
		//Roi.setProperty("timestamp", timestamp());
		//Roi.setProperty("id", get_sid());
		Roi.setGroupNames(seg[i]);
		roiManager("add");
		//showStatus("Added ROI: " + sid + ":" + tag);
	    } else {
		showStatus("No ROI to add");
	    }
	}
    } else {
	getStatistics(area, mean, min, max);
	return 0;
    }
}

function addLargest() {
    setBatchMode(true);
    run("Select None");
    run("Duplicate...", " ");
	setThreshold(-300, 2048);
	run("Convert to Mask");
	run("Erode");
	run("Analyze Particles...", "size=5000-Infinity pixel show=Masks");
	    run("Dilate");
	    run("Fill Holes");
	    run("Create Selection");
	    Roi.setName("body");
	    Roi.setGroup(group_body);
	    Roi.setGroupNames("body");
	    roiManager("add");
	close();
    close();
}

function loadSeg() {
    run("ROI Manager...");
    setBatchMode(true);
    fname = getInfo("image.filename");
    idir = getDir("image");
    iname = replace(fname, "_0anatomy.nii.gz", "");
    iname = replace(iname, "_0anatomy.dcm", "");
    lname = iname + "_7label.nii.gz";
    run("Bio-Formats Windowless Importer", "open="+idir+lname +" color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
    //open(idir + lname);
    selectWindow(lname);
    roiManager("reset");
    addSeg();
    close();
    addLargest();
    setBatchMode(false);
}

function create_body_selection(lower, upper) {
    setBatchMode(true);
    iter = 2;
    run("Select None");
    run("Duplicate...", " ");
	setThreshold(lower, upper);
	run("Convert to Mask");
	//run("Erode");
	run("Options...", "iterations="+ iter +" count=2 do=Erode");
	run("Analyze Particles...", "size=5000-Infinity pixel show=Masks");
	    //run("Dilate");
	    run("Options...", "iterations="+ iter +" count=2 do=Dilate");
	    run("Fill Holes");
	    run("Create Selection");
	    run("Fill Holes");
	close();
    close();
    run("Restore Selection");
}

function gen_fat_results() {
	ImageID = getImageID();
	setBatchMode(true);
	Table.create("lifestyle");
	Table.setLocationAndSize(0, 410, 600, 600, "lifestyle");
	Table.showRowNumbers(false);
	Table.showRowIndexes(false);
	id = newArray;
	variable = newArray;
	value = newArray;

	run("Set Measurements...", "area mean standard perimeter median skewness kurtosis display redirect=None decimal=3");

	roiManager("deselect");
	RoiManager.selectGroup(group_sat_u);
	getStatistics(area, mean, min, max, std, histogram);
	if (endsWith(getInfo("image.filename"), "gz")) {
	    area /= 1000000;
	}
	id = Array.concat(id, getInfo("image.filename"));
	variable = Array.concat(variable, "sat_area");
	value = Array.concat(value, area);
	id = Array.concat(id, getInfo("image.filename"));
	variable = Array.concat(variable, "sat_mean");
	value = Array.concat(value, mean);

	roiManager("deselect");
	RoiManager.selectGroup(group_vat_u);
	getStatistics(area, mean, min, max, std, histogram);
	if (endsWith(getInfo("image.filename"), "gz")) {
	    area /= 1000000;
	}
	id = Array.concat(id, getInfo("image.filename"));
	variable = Array.concat(variable, "vat_area");
	value = Array.concat(value, area);
	id = Array.concat(id, getInfo("image.filename"));
	variable = Array.concat(variable, "vat_mean");
	value = Array.concat(value, mean);

	roiManager("deselect");
	RoiManager.selectGroup(group_body_u);
	perim = getValue("Perim.");
	if (endsWith(getInfo("image.filename"), "gz")) {
	    perim /= 1000;
	}
	id = Array.concat(id, getInfo("image.filename"));
	variable = Array.concat(variable, "body_perimeter");
	value = Array.concat(value, perim);
	getStatistics(area, mean, min, max, std, histogram);
	if (endsWith(getInfo("image.filename"), "gz")) {
	    area /= 1000000;
	}
	id = Array.concat(id, getInfo("image.filename"));
	variable = Array.concat(variable, "body_area");
	value = Array.concat(value, area);

        getPixelSize(unit, uwidth, uheight, udepth);
	getSelectionBounds(x, y, width, height);
	width *= uwidth;
	height *= uheight;
	if (endsWith(getInfo("image.filename"), "gz")) {
	    width /= 1000;
	    height /= 1000;
	}
	id = Array.concat(id, getInfo("image.filename"));
	variable = Array.concat(variable, "body_height");
	value = Array.concat(value, height);
	id = Array.concat(id, getInfo("image.filename"));
	variable = Array.concat(variable, "body_width");
	value = Array.concat(value, width);


    Table.setColumn("id", id);
    Table.setColumn("variable", variable);
    Table.setColumn("value", value);
    idir = getDir("image");
    iname = replace(getInfo("image.filename"), "_0anatomy.nii.gz", "");
    iname = replace(iname, "_0anatomy.dcm", "");
    lname = iname + "_7label.nii.gz";
    Table.save(idir + iname + "_results.csv");
    setBatchMode(false);
    selectImage(ImageID);
}

function processFat() {
    idir = getDir("image");
    iname = replace(getInfo("image.filename"), "_0anatomy.nii.gz", "");
    iname = replace(iname, "_0anatomy.dcm", "");
    setMinAndMax(-125, 225);
    loadSeg();
    if (RoiManager.size > 0) {
	    gen_fat_results();
	    RoiManager.selectGroup(group_sat_u);
	    Overlay.addSelection("red");
	    RoiManager.selectGroup(group_vat_u);
	    Overlay.addSelection("green");
	    RoiManager.selectGroup(group_body_u);
	    Overlay.addSelection("cyan");
	    Overlay.flatten;
		save(idir + iname + "_overlay.jpg");
		close();
    }
}

function scanFatdir() { 
    fat_dir = getDirectory("Choose Main Fat Directory ");
    fatdir = getFileList(fat_dir);
    run("ROI Manager...");
    setBatchMode(true);
    for (i=0; i<fatdir.length; i++) {
    	showProgress(i+1, fatdir.length);
    	if (File.isDirectory(fat_dir + fatdir[i]) && endsWith(fatdir[i], ".fat" + File.separator)) {
    		ifiles = getFileList(fat_dir + fatdir[i]);
    		for (j=0; j<ifiles.length; j++) {
    			if (endsWith(ifiles[j], "0anatomy.nii.gz") || endsWith(ifiles[j], "0anatomy.dcm")) {
			    	setBatchMode(true);
			    	setBatchMode("hide");
    				iname = replace(ifiles[j], "_0anatomy.nii.gz", "");
    				iname = replace(iname, "_0anatomy.dcm", "");
				    run("Bio-Formats Windowless Importer", "open="+ fat_dir + fatdir[i] + ifiles[j] +" color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
				processFat();
			    	close();
				}
    		}
    	}
    }
}


macro "softMask [F]" {
    createMask(0, 90);
}

macro "Set Fat Mask [f]" {
    createMask( -250, -50);
}

macro "processFat [8]" {
    processFat();
}

macro "Clear overlay [O]" {
	Overlay.hide;
	Overlay.clear;
}

macro "overlay seg [o]" {
	overlaySeg();
}

macro "umbilical seg [u]" {
	addUFat();
}

function addUFat() {
	setBatchMode(true);
	workingSlice = getSliceNumber();
	idir = getDir("image");
	files = getFileList(idir + "work");
	for (i=0; i < files.length; i++) {
		print(files[i]);
		if (endsWith(files[i], "label.nii.gz")) {
			lname = files[i];
			run("Bio-Formats Windowless Importer", "open="+idir + "work/" + lname +" color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
			seg = newArray("bg", "SAT_u", "VAT_u", "soft_u", "bone_u", "psoas_u", "back_u", "aw_u", "body_u");
			gid = newArray(0, group_sat_u, group_vat_u, group_soft_u, group_bone_u, group_psoas_u, group_back_u, group_aw_u, group_body_u);
			for (i = 1; i <= 7; i++) {
			    setThreshold(i, i);
			    run("Create Selection");
			    if (selectionType >= 0) {
				addROI(seg[i], gid[i]);
			    }
			}
			close();
			update_results();
		}
	}
	workingSlice = 0;
}

function overlaySeg() {
	idir = getDir("image");
	files = getFileList(idir + "work");
	for (i=0; i < files.length; i++) {
		print(files[i]);
		if (endsWith(files[i], "label.nii.gz")) {
			//fname = getInfo("image.filename");
			//idir = getDir("image");
			//iname = replace(fname, "_0anatomy.nii.gz", "");
			//iname = replace(iname, "_0anatomy.dcm", "");
			lname = files[i];
			run("Bio-Formats Windowless Importer", "open="+idir + "work/" + lname +" color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
			//open(idir + lname);
			//selectWindow(lname);
			oSeg();
			Overlay.copy();
			close();
			Overlay.paste();
			setBatchMode(false);
		}
	}
    
}

function oSeg() {
    for_vat = 1;
    if (for_vat == 1) {
	seg = newArray("bg", "SAT_u", "VAT_u", "soft_u", "bone_u", "psoas_u", "back_u", "aw_u", "body_u");
	gid = newArray(0, group_sat_u, group_vat_u, group_soft_u, group_bone_u, group_psoas_u, group_back_u, group_aw_u, group_body_u);
	for (i = 1; i <= 7; i++) {
	    setThreshold(i, i);
	    run("Create Selection");
	    if (selectionType >= 0) {
		Overlay.addSelection("green");
	    } else {
		showStatus("No ROI to add");
	    }
	}
    } else {
	getStatistics(area, mean, min, max);
	return 0;
    }
}

macro "scanFatdir [9]" {
	scanFatdir();
}

//macro "Pencil [p]" {
//  setTool(18);
//}

macro "Brush [b]" {
  setTool("brush");
}

macro "Elliptical [E]" {
    setTool("oval");
    //setTool("polygon");
}

macro "Select None [r]" {
  run("Select None");
}

macro "WandSelect [c]" {
  wandSelect("4-connected");
}

macro "WandSelect [v]" {
  wandSelect("Legacy");
}

macro "WaterShed [W]" {
  run("Watershed");
}

macro "Line [Z]" {
  setTool("Line");
}

macro "Clear [x]" {
  run("Clear", "slice");
}

macro "Clear Outside [X]" {
  run("Clear Outside", "slice");
}

/* sarcopenia, vat, sat
macro "add mask aw_3 [q]" {
//    if (is("area")) {
//	addROI("qlum_3", group_qlum_3);
//	update_results();
//    } else {
//	showStatus("No ROI to add");
//    }
    addMask("aw_3", group_aw_3);
}

macro "add ROI psoas_3 [w]" {
    addMask("psoas_3", group_psoas_3);
}

macro "add ROI back_3 [e]" {
    addMask("back_3", group_back_3);
}

macro "add ROI sat_u [s]" {
    addMask("sat_u", group_sat_u);
}

macro "add ROI vat_u [v]" {
    addMask("vat_u", group_vat_u);
}
*/

macro "gen_sdir [9]" {
    gen_sdir();
}

macro "test body [7]" {
    gen_m_results();
}

///*** For organ density
/*
macro "Liver [a]" {
    if (is("area")) {
	addROI("liver", group_liver);
	update_results();
    } else {
	showStatus("No ROI to add");
    }
}

macro "Pancreas [s]" {
    if (is("area")) {
	addROI("pancreas", group_pancreas);
	update_results();
    } else {
	showStatus("No ROI to add");
    }
}

macro "Spleen [d]" {
    if (is("area")) {
	addROI("spleen", group_spleen);
	update_results();
    } else {
	showStatus("No ROI to add");
    }
}
*/

/*
macro "Right Renal Sinus Fat [q]" {
    if (is("area")) {
	addROI("rkfat", group_rkfat); //right perirenal sinus fat
	update_results();
    } else {
	showStatus("No ROI to add");
    }
}

macro "Left Renal Sinus Fat [w]" {
    if (is("area")) {
	addROI("lkfat", group_lkfat); //right perirenal sinus fat
	update_results();
    } else {
	showStatus("No ROI to add");
    }
}

macro "Right Perirenal Thickness [e]" {
    if (is("line")) {
	addROI("rkthick", group_rkthick); //right perirenal thickness
	update_results();
    } else {
	print("!!! Draw a straight line first !!!");
    }
}

macro "Left Perirenal Thickness [r]" {
    if (is("line")) {
	addROI("lkthick", group_lkthick); //right perirenal thickness
	update_results();
    } else {
	print("!!! Draw a straight line first !!!");
    }
}

macro "Agatston Score [g]" {
    if (is("area")) {
	addROI("aorta", group_aorta);
	update_results();
	run("Previous Slice [<]");
    } else {
	showStatus("No ROI to add");
    }
}

macro "mid_slice [v]" {
    mid_slice();
}
*/

///*** For organ density

///*** Overlay and save skin images

/*
var group_lw = 1;
var group_ly = 2;
var group_template = 3;

function skinOverlay () {
    // xx: "LW", "LY"
    iname = getInfo("image.filename");
    fname = File.getNameWithoutExtension(iname);
    idir = getDir("image");

    Overlay.remove;
    roiManager("reset");
    xx = "LW";
    color = "green";
    group = group_lw;
    roi = idir + "../" + xx + "/" + fname + "_roi.zip";
    if (File.exists(roi)) {
	roiManager("open", roi);
	i = -1;
	for (j = 0; j < RoiManager.size; j++) {
	    if (matches(RoiManager.getName(j), ".*lesion.*")) {
		i = j;
	    }
	}
	if (i >= 0) {
	    RoiManager.select(i);
	    roiManager("rename", xx);
	    RoiManager.setGroup(group);
	    roiManager("save selected", idir + fname + "_" + xx + ".zip");
	    Overlay.addSelection(color, 5);
	}
    }
    roiManager("reset");
    xx = "LY";
    color = "red";
    group = group_ly;
    roi = idir + "../" + xx + "/" + fname + "_roi.zip";
    if (File.exists(roi)) {
	roiManager("open", roi);
	i = -1;
	for (j = 0; j < RoiManager.size; j++) {
	    if (matches(RoiManager.getName(j), ".*lesion.*")) {
		i = j;
	    }
	}
	if (i >= 0) {
	    RoiManager.select(i);
	    roiManager("rename", xx);
	    RoiManager.setGroup(group);
	    roiManager("save selected", idir + fname + "_" + xx + ".zip");
	    Overlay.addSelection(color, 5);
	}
    }
    roiManager("reset");
    roiManager("open", idir + fname + "_LW.zip");
    roiManager("open", idir + fname + "_LY.zip");
    run("Select None");

}

function skinOverlayTemplate () {
    // xx: "LW", "LY"
    iname = getInfo("image.filename");
    fname = File.getNameWithoutExtension(iname);
    idir = getDir("image");
    WorkDir = idir + "work/";

    Overlay.remove;
    roiManager("reset");
    color = "red";
    group = group_template;
    roi = WorkDir + fname + "_template.zip";

    if (File.exists(roi)) {
	Overlay.remove;
	roiManager("open", roi);
	RoiManager.selectGroup(group_template);
	Overlay.addSelection("006600", 5);
	roiManager("reset");
    }
    run("Select None");
}

function skinSaveOverlay (color) {
    iname = getInfo("image.filename");
    fname = File.getNameWithoutExtension(iname);
    idir = getDir("image");
    WorkDir = idir + "work/";
    if(!File.exists(WorkDir)) File.makeDirectory(WorkDir);

    roi = WorkDir + fname + "_template.zip";

    
    if (color == "blue") {
	if (is("area")) {
	    group = group_wy;
	    Roi.setName("template");
	    Roi.setGroup(group_template);
	    roiManager("add");
	} else return 0;
	
    } else if (color == "green") {
	xx = "LW";
	group = group_lw;
    } else if (color == "red") {
	xx = "LY";
	group = group_ly;
    } 
    RoiManager.selectGroup(group);
    Roi.setName("template");
    Roi.setGroup(group_template);
    roiManager("add");
    RoiManager.selectGroup(group_template);
    roiManager("save selected", roi);

    Overlay.remove;
    RoiManager.selectGroup(group_template);
    Overlay.addSelection("red", 5);
    Overlay.flatten;
    save(WorkDir + iname);
    close();
    skinOverlay();
}

function grid_overlay(tileLength) {
    //setBatchMode(true);
    color = "green";
    tileWidth = 250;

    getPixelSize(unit, pw, ph, pd);
    if (unit=="cm") {
        tileWidth= tileLength/pw;
        tileHeight = tileWidth;
    } else {
      showMessage("Please set scale (cm) first!!!");
      setTool("Line");
      return;
    }

    if (nImages>0) {
        //run("Remove Overlay");
	Overlay.clear;
        width = getWidth;
        height = getHeight;

	getCursorLoc(x, y, z, flags);

        xoff=x % tileWidth;
        while (true && xoff<width) { // draw vertical lines
          makeLine(xoff, 0, xoff, height);
	  Overlay.addSelection("green");
          //run("Add Selection...", "stroke="+color);
          xoff += tileWidth;
        }
        yoff=y % tileWidth;
        while (true && yoff<height) { // draw horizonal lines
          makeLine(0, yoff, width, yoff);
	  Overlay.addSelection("green");
          //run("Add Selection...", "stroke="+color);
          yoff += tileHeight;
        }
        run("Select None");
    }
    setBatchMode(false);
}

macro "Load [0]" {
    roiManager("reset");
    skinOverlay();
    skinOverlayTemplate();
}

function openSkin(dir) {
    // dir: 0 [next undo], -1 [prev], 1 [next]
    idir = getDir("image");
    iname = getInfo("image.filename");
    getFileList(idir);
    WorkDir = idir + "work/";
    ifiles0 = getFileList(idir);

    ifiles = newArray;
    for (i = 0; i < ifiles0.length; i++) {
	if (endsWith(ifiles0[i], "jpg") || endsWith(ifiles0[i], "JPG")) {
	    ifiles = Array.concat(ifiles, ifiles0[i]);
	}
    }

    i = -1;
    for (j=0; j<ifiles.length; j++) {
	if (dir == 0) {
	    fname = File.getNameWithoutExtension(ifiles[j]);
	    roi = WorkDir + fname + "_template.zip";
	    target_file = roi;
	    if(!File.exists(target_file)) {
		i = j;
	    }
	} else {
	    if (iname == ifiles[j]) {
		i = j + dir;
		if (i < 0) {
		    i = 0;
		} else if (i == ifiles.length) {
		    i = ifiles.length - 1;
		}
	    }
	}
	if (i >= 0) {
	    close("*");
	    open(idir + ifiles[i]);
	    skinOverlayTemplate();
	    return 0;
	}
    }
}

macro "undo [a]" {
    openSkin(0);
}

macro "next [n]" {
    openSkin(1);
}

macro "previous [p]" {
    openSkin(1);
}

macro "Save Overlay [g]" {
    skinSaveOverlay("green");
}

macro "Save Overlay [r]" {
    skinSaveOverlay("red");
}

macro "Save Selection [b]" {
    skinSaveOverlay("blue");
}
*/

///*** Overlay and save skin images

function append_result(Logfile, sid, roi, type, label, value) {
// create_path("_misc.csv"), get_id(), "area", "liver", value 
  if(!File.exists(Logfile)) 
    File.append("id,roi,type,label,value", Logfile);
  File.append(sid+","+roi+","+type+","+label+","+value, Logfile);
}


//************ For flat foot tarsal calcaneal measurement
/*
function initVar() {
    roidir = File.getParent(pathROI(""));
}


function val_case(direction) {
    // direction = 1 (forward), 0 (find first undone), -1 (backward)

    iFilename = getInfo("image.filename");
    if (iFilename == "") { // assume it is a directory
	filemode = 0;
	iFilename = getInfo("image.title");
	idir = File.getParent(getInfo("image.directory")) + File.separator;
	idir = replace(idir, "\\", "/");

	ifiles0 = getFileList(idir);
	ifiles = newArray;
	for (i = 0; i < ifiles0.length; i++) {
	    if (File.isDirectory(idir + ifiles0[i]))
		itmp = replace(ifiles0[i], "\\", "");
		itmp = replace(itmp, "/", "");
		ifiles = Array.concat(ifiles, itmp);
	}
    } else {
	idir = getInfo("image.directory");
	filemode = 1;
	iName = File.getNameWithoutExtension(iFilename);
	iExt = replace(iFilename, iName + ".", "");

	ifiles0 = getFileList(idir);
	idir = replace(idir, "\\", "/");

	ifiles = ifiles0;
	for (i = 0; i < ifiles0.length; i++) {
	    if (!endsWith(ifiles0[i], iExt))
		ifiles = Array.deleteValue(ifiles, ifiles0[i]);
	}
    }

    num_n = -1;
    for (i = 0; i < ifiles.length; i++) {
	// find first undo
	ipath = idir + ifiles[i];
	if (direction == 0) {
	    if (! existCSV(ipath)) { num_n = i + 1; }
	} else {
	    if (iFilename == ifiles[i]) {
		if (direction == 1) {
		    if (i == ifiles.length - 1) {
			showMessage("Done");
			return 0;
		    } else {
			num_n = i + 2;
		    }
		} else { // direction == -1
		    if (i == 0) {
			showMessage("Already the first");
			return 0;
		    } else {
			num_n = i;
		    }
		}
	    }
	}
	if (num_n >= 0) {
	    num_N = ifiles.length;
	    getLocationAndSize(x, y, width, height);
	    call("ij.gui.ImageWindow.setNextLocation", x, y);
	    nZoom = getZoom() * 100;
	    close("*");
	    open(idir + ifiles[num_n-1]);
	    //setLocation(x, y, width, height);
	    setLocation(x, y);
	    run("Set... ", "zoom="+ nZoom);
	    init();
	    showStatus("[" + num_n + "/" + ifiles.length + "] " + idir + ifiles[num_n-1]);
	    return idir + ifiles[num_n-1];
	}
    }
}

function get_id(lvl) {
    if (Title == "") Title = getTitle();

    iFilename = getInfo("image.filename");
    if (xmode == 0) {
	return iFilename;
    //} else if (xmode == 1) {
    } else {
	PatientName = getTag("0010,0010");
	PatientID = getTag("0010,0020");
	PatientsBirthDate = getTag("0010,0030");
	PatientSex = getTag("0010,0040");
	StudyDate = getTag("0008,0020");
	studyid = getTag("0020,0010");
	series = getTag("0020,0011");
	image = getTag("0020,0013");
	Modality = getTag("0008,0060");
	date = getTag("0008,0020");

	if (lvl == "date")
	  xid = PatientID + "_" + date;
	else if (lvl == "series")
	  xid = PatientID + "_" + date + "-S"+studyid + "_s"+series;
	else if (lvl == "dcm")
	  xid = "S"+studyid + "_s"+series + "_i"+image;
	else if (lvl == "image")
	  xid = PatientID + "_" + date + "-S"+studyid + "_s"+series + "_i"+image;
        return xid;
    }
}

function get_did() {
    xid = get_id("date");
    return xid;
}

function get_sid() {
    xid = get_id("series");
    return xid;
}

function get_iid() {
    xid = get_id("image");
    return xid;
}

function addLine(tag, group_id) {
    if (selectionType == 5) {
	Roi.setName(tag);
	Roi.setGroup(group_id);
	Roi.setPosition(getSliceNumber());
	Roi.setProperty("timestamp", timestamp());
	Roi.setProperty("id", get_sid());
	Roi.setGroupNames(tag);
	roiManager("add");
	showStatus("Added ROI: " + get_sid() + ":" + tag);
    } else {
	showStatus("No Line selection to add. ");
    }
}

function setLine(tag, group_id) {
    if (selectionType == 5) {
	Roi.setName(tag);
	Roi.setGroup(group_id);
	Roi.setPosition(getSliceNumber());
	Roi.setProperty("timestamp", timestamp());
	Roi.setProperty("id", get_sid());
	Roi.setGroupNames(tag);
	roiManager("deselect");
	RoiManager.selectGroup(group_id);
	if (RoiManager.selected == 0) {
	    roiManager("add"); 
	    showStatus("Added ROI: " + get_sid() + ":" + tag);
	} else {
	    run("Restore Selection");
	    roiManager("Update");
	    showStatus("Updated ROI: " + get_sid() + ":" + tag);
	} 
    } else {
	showStatus("No Line selection to add. ");
    }
}

function tidyROI() {
    sid = get_sid();
    for (i = 0; i < RoiManager.size; i++) {
	RoiManager.select(i);
	aid = Roi.getProperty("id");
	if (aid != sid) {
	    Roi.setGroup(99);
	}
	print("aid: " + aid);
	print("sid: " + sid);
    }
    RoiManager.selectGroup(99);

    if (RoiManager.selected > 0) {
	roiManager("delete");
    }
}

function update_results() {
    roiManager("Deselect");
    sid = get_sid();
    // check valid data
    tidyROI();

    if (RoiManager.size > 0) {
	roidir = File.getParent(pathROI(""));
	if (!File.exists(roidir))  {
	    File.makeDirectory(roidir);
	}
	roiManager("Save", pathROI(""));
    } else {
	if (File.exists(pathROI(""))) {
	    File.delete(pathROI(""));
	}
    }
    update_info();
}

function set_exclude() {
    sid = get_sid();
    xpath = pathExt("", ".json");
    File.append('{"id":"' + sid + '", "status":"excluded"}', xpath);
}

function update_info() {
    //setBatchMode(true);
    print("\\Clear");
    print("["+num_n+"/"+num_N+"] "+get_sid());
    print("");
    print("[1] Calcaneal line");
    print("[2] 5MT line");
    print("[3] Next undone");
    print("");
    print("[q] Prev");
    print("[w] Next");
    print("[e] Next undone");
    //setBatchMode(false);
}

}

/*
macro "Next Case [N]" {
    update_results();
    open_case(1);
}

macro "Prev Case [P]" {
    update_results();
    open_case(-1);
}

macro "init [0]" {
    init();
}

macro "Set calcaneal line [1]" {
    setLine("Calcaneal", group_ccn);
    update_results();
}

macro "Set 5mt line [2]" {
    setLine("5MT", group_5mt);
    update_results();
}

macro "Next Undone Case [3]" {
    update_results();
    open_case(0);
}

macro "Exclude [9]" {
    set_exclude();
}

macro "Next Case [w]" {
    update_results();
    open_case(1);
}

macro "Prev Case [q]" {
    update_results();
    open_case(-1);
}

macro "Next Undone [e]" {
    update_results();
    open_case(0);
}

macro "Prev Case [z]" {
    open_case(-1);
}

macro "Next Case [x]" {
    open_case(1);
}

macro "Check Tarsus and Next [c]" {
    update_tarsus();
    open_case(1);
}

macro "Next Unchecked Case [v]" {
    val_case(0);
}
*/

macro "info [i]" {
    //print("pathImage: " + pathImage(""));
    print("pathROI: " + pathROI(""));
    print("pathCSV: " + pathCSV(""));
}


function set_class(label) {
    Logfile = pathCSV("");
    if(File.exists(Logfile)) 
    	File.delete(Logfile);
    File.append("filename,class", Logfile);
    File.append(getInfo("image.filename") + "," + label, Logfile);
}

/*
macro "set 1 [1]" {
	set_class(1);
}

macro "set 2 [2]" {
	set_class(2);
}

macro "set 3 [3]" {
	set_class(3);
}

macro "set 4 [4]" {
	set_class(4);
}

macro "set 5 [5]" {
	set_class(5);
}
*/

macro "Next case [f]" {
	update_results();
	open_case(1);
}

macro "Previous case [d]" {
	update_results();
	open_case(-1);
}

macro "Next undone [n]" {
    update_results();
    open_case(0);
    //createMask(1, 4096);
    createMask1();
    roiManager("reset");
    loadROI("");
}


function gen_sat(level) {
    roiManager("deselect");
    i1 = -1;
    i2 = -1;
    if (level == 3) {
	i1 = RoiManager.getIndex("tat_3");
	i2 = RoiManager.getIndex("ovat_3");
    } else {
	i1 = RoiManager.getIndex("tat_u");
	i2 = RoiManager.getIndex("ovat_u");
    }
    if (i1 >= 0 && i2 >=0) {
	roiManager("Select", newArray(i1, i2));
	if (RoiManager.selected == 2) {
	    roiManager("XOR");
	    if (level == 3) {
		addROI1("sat_3", group_sat_3);
	    } else {
		addROI1("sat_u", group_sat_3);
	    }
	}
    }
}

function gen_oat(level) {
    roiManager("deselect");
    i1 = -1;
    i2 = -1;
    if (level == 3) {
	i1 = RoiManager.getIndex("vat_3");
	i2 = RoiManager.getIndex("ovat_3");
    } else {
	i1 = RoiManager.getIndex("vat_u");
	i2 = RoiManager.getIndex("ovat_u");
    }
    if (i1 >= 0 && i2 >=0) {
	roiManager("Select", newArray(i1, i2));
	if (RoiManager.selected == 2) {
	    roiManager("XOR");
	    if (level == 3) {
		addROI1("oat_3", group_oat_3);
	    } else {
		addROI1("oat_u", group_oat_3);
	    }
	}
    }
}

/*
var xmode = 0;
macro "Total adipose tissue [t]" {
    addMask1("tat_3", group_tat_3);
    update_results();
}

macro "Other+visceral adipose tissue [o]" {
    addMask1("ovat_3", group_ovat_3);
    gen_sat(3);
    update_results();
}

macro "Visceral adipose tissue [v]" {
    addMask1("vat_3", group_vat_3);
    gen_oat(3);
    update_results();
}

macro "Subcutaneous adipose tissue [s]" {
    addMask1("sat_3", group_sat_3);
    update_results();
}
*/

/*
macro "Set xmode[0] [F1]" {
    xmode = 0;
}

macro "Set xmode[0] [F2]" {
    xmode = 1;
}

macro "Set xmode[0] [F3]" {
    xmode = 0;
}
*/

// var xmode = 0;
//var defaultSeries = "02_I1";
var defaultSeries = "09_MRE95";

macro "Create soft tissue mask [g]" {
    createMask(50, 300);
}

// sarcopenia, vat, sat 
/*
macro "add mask aw_3 [w]" {
    addMask1("aw_3", group_aw_3);
    update_results();
}

macro "add ROI psoas_3 [s]" {
    addMask1("psoas_3", group_psoas_3);
    update_results();
}

macro "add ROI back_3 [b]" {
    addMask1("back_3", group_back_3);
    update_results();
}

macro "add ROI qlum_3 [q]" {
    addMask1("qlum_3", group_qlum_3);
    update_results();
}
*/

/*
macro "add ROI sat_u [s]" {
    addMask1("sat_u", group_sat_u);
    update_results();
}

macro "add ROI vat_u [v]" {
    addMask1("vat_u", group_vat_u);
    update_results();
}
*/
macro "gen_sdir [9]" {
    gen_sdir();
}

///*** For organ density
macro "Liver [a]" {
    if (is("area")) {
	addROI("liver", group_liver);
	update_results();
    } else {
	showStatus("No ROI to add");
    }
}

macro "Pancreas [s]" {
    if (is("area")) {
	addROI("pancreas", group_pancreas);
	update_results();
    } else {
	showStatus("No ROI to add");
    }
}

///*** For MRE
macro "Create MRE mask [g]" {
    createMask(1, 4096);
    roiManager("reset");
    loadROI("");
}

macro "wand and Liver MRE [z]" {
    run("Select None");
    wandSelect("4-connected");
    if (is("area")) {
	addMask("MRE", group_liver_mre);
	update_results();
    } else {
	showStatus("No ROI to add");
    }
    run("Next Slice [>]");
}

macro "Liver MRE [e]" {
    if (is("area")) {
	addMask("MRE", group_liver_mre);
	update_results();
    } else {
	showStatus("No ROI to add");
    }
    run("Next Slice [>]");
}


/*
macro "Next Slice [c]" {
    run("Next Slice [>]");
}

macro "Previous Slice [x]" {
    run("Previous Slice [<]");
}
*/

macro "WandSelect [v]" {
    wandSelect("4-connected");
}

/// For Fat segmentation
var xmode = 0;

macro "Create fat mask [F]" {
    createMask(100, 800);
    //createMask(230, 65535);
    roiManager("reset");
    loadROI("");
}

macro "Create fat mask manual threshold [G]" {
    createMask1();
    //createMask(230, 65535);
    roiManager("reset");
    loadROI("");
}

macro "Total adipose tissue [t]" {
    addMask1("tat_3", group_tat_3);
    update_results();
}

macro "Other+visceral adipose tissue [o]" {
    addMask1("ovat_3", group_ovat_3);
    gen_sat(3);
    update_results();
}

macro "Visceral adipose tissue [v]" {
    addMask1("vat_3", group_vat_3);
    gen_oat(3);
    update_results();
}

macro "Subcutaneous adipose tissue [s]" {
    addMask1("sat_3", group_sat_3);
    update_results();
}

function overlay_roi(roi_name, color) {
    for (j = 0; j < RoiManager.size; j++) {
	if (RoiManager.getName(j) == roi_name) {
	    RoiManager.select(j);
	    Overlay.addSelection("", 0, color);
	    //Overlay.fill(color)
	}
    }
}
function overlay_fatroi() {
	xpath = getIpath();
	path = pathExt(xpath, "_roi.png");
	Overlay.clear;
	overlay_roi("vat_3", "#7F00FF00");
	overlay_roi("sat_3", "#7FFF0000");
	Overlay.flatten;
	save(path);
	close();
}

function gen_overlay_sdir() {
  // file mode
  setBatchMode(true); 
  sdir = getDirectory("Choose Source Directory ");
  sdir = replace(sdir, "\\", "/");

  ifiles = getFileList(sdir);

  for (i = 0; i < ifiles.length; i++) {
    if (xmode == 0) {
      if (endsWith(ifiles[i], "_roi.zip")) {
        ibase = ifiles[i].replace("_roi.zip","");
        idcm = ibase + ".dcm";
        showStatus(sdir + idcm);
        open(sdir + idcm);
        init();
        //generate_results();
        //gen_m_results();
        //gen_f_results();
        //gen_results();
	overlay_fatroi();
        close();
      }
    } else if (xmode == 2) {
      xdir = sdir + ifiles[i];
      if (File.isDirectory(xdir)) {
        ilist0 = getFileList(xdir);
        i_F = 0;
        i_W= 0;
        i_E = 0;
        for (j = 0; j < ilist0.length; j++) {
          if (ilist0[j].startsWith("03_F1") && File.isDirectory(xdir + ilist0[j])) {
            i_F = j;
          }
          if (ilist0[j].startsWith("04_W1") && File.isDirectory(xdir + ilist0[j])) {
            i_W = j;
          }
          if (ilist0[j].startsWith("09_MRE95") && File.isDirectory(xdir + ilist0[j])) {
            i_E = j;
          }
        }
        fat_path = xdir + ilist0[i_F];
        water_path = xdir + ilist0[i_W];
        mre_path = xdir + ilist0[i_E];
        //XXXXXXXXX

        open(fat_path);
        init_dixon();
        roifile = pathExt("", "_dixon.zip");
        if(File.exists(roifile)) {
          generate_dixon_results("fat");
        }
        close();

        open(water_path);
        init_dixon();
        roifile = pathExt("", "_dixon.zip");
        if(File.exists(roifile)) {
          generate_dixon_results("water");
        }
        close();

        open(mre_path);
        init_mre();
        roifile = pathExt("", "_mre.zip");
        if(File.exists(roifile)) {
          generate_mre_results();
        }
        close();
      }
    }
  }
  //setBatchMode(false); 
}

macro "Overlay sat/vat [y]" {
    gen_overlay_sdir();
}

