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


// for Skin ROI measurement and timing

var iid = "";
var scale = 0;
var roi = 0;
var grid = 0;

function create_path(ext) {
    idir = getDirectory("image");
    title = getTitle;
    dotIndex = indexOf(title, ".");
    if (dotIndex > 0)
	title = substring(title, 0, dotIndex);
    filename = idir + title + ext;
    return filename;
}


function saveROI() {
    // run("Set Measurements...", "area mean standard perimeter median skewness kurtosis display redirect=None decimal=3");
    run("Set Measurements...", "area feret's display redirect=None decimal=3");
    saveAs("Results",  create_path("_results.csv"));
    roiManager("Save", create_path("_roi.zip"));

    if (endsWith(getInfo("image.filename"), ".nii.gz")) {
	showMessage(create_path("_results.csv") + " saved!");
    } else {
	showMessage(id + " saved!");
    }
}
}

function append_result(Logfile, iid, timestr, type, label, value) {
    // create_path("_misc.csv"), get_id(), "area", "liver", value 
    if(!File.exists(Logfile)) 
	File.append("id,timestr,type,label,value", Logfile);
    File.append(iid+","+timestr+","+type+","+label+","+value, Logfile);
}

function saveResult () {
    run("Set Measurements...", "area feret's display redirect=None decimal=3");
    roiManager("Deselect");
    run("Clear Results");
    roiManager("Measure");
    saveAs("Results",  create_path("_roi.csv"));
    roiManager("Save", create_path("_roi.zip"));
    run("Restore Selection");
}

var init_time = "";

var id = newArray;
var ts = newArray;
var label = newArray;
var type = newArray;
var value = newArray;

function init() {
    if (nImages == 0) {
	print("\\Clear");
	print("\\Update0:Please open an image and Press [1]");
	print("\\Update1:");
	print("\\Update2:[X][1] Time = " + ymd_hms());
	print("\\Update3:[X][2] Scale = X ---> Draw line -> [2]");
	print("\\Update4:[X][3]   ROI = X ---> Draw ROI -> [3] ");
	print("\\Update5:[X][4]  Grid = X ---> [4]");
	print("\\Update6:");
	print("\\Update7:[g] Create/hide grid.");
	call("ij.gui.ImageWindow.setNextLocation", ImageX, ImageY);
	roiManager("reset");
	Table.setLocationAndSize(0, 110, 300, 300, "ROI Manager");
	Table.setLocationAndSize(300, 110, 300, 300, "Log");
    } else {
	roiManager("reset");
	run("Clear Results");

	iid = getTitle();
	idir = getDirectory("image");
	ipath = idir + iid;

	print("\\Clear");
	print("\\Update0:" + iid + " (" + ymd_hms() + ")");
	print("\\Update1:");
	print("\\Update2:[X][1] Time = " + ymd_hms());
	print("\\Update3:[X][2] Scale = X ---> Draw line -> [2]");
	print("\\Update4:[X][3]   ROI = X ---> Draw ROI -> [3] ");
	print("\\Update5:[X][4]  Grid = X ---> [4]");
	print("\\Update6:");
	print("\\Update7:[g] Create/hide grid.");

	if (File.exists(create_path("_roi.zip")))
	    roiManager("Open", create_path("_roi.zip"));
	run("Set Measurements...", "area feret's display redirect=None decimal=3");
	roiManager("Deselect");
	run("Clear Results");
	roiManager("Measure");
	run("Set Scale...", "distance=0 known=0 unit=pixel");

	// run("Remove Overlay");
	Overlay.clear;
	init_time = ymdhms();
	append_result(create_path("_time.csv"), iid, init_time, "init", "event", init_time);
	scale = 0;
	roi = 0;
	grid = 0;
	setTool("Line");
	Table.setLocationAndSize(0, 110, 300, 400, "ROI Manager");
	Table.setLocationAndSize(300, 110, 300, 300, "Log");
	ImageX = 600;
	ImageY = -110;
	setLocation(610, -10, width, height);
    }
}

macro "init [1]" {
  init();
}

function check_id () {
    if (iid != getTitle) {
	print("\\Update0:XXXXXXXXXX (Please press [1] to set up environmentfirst !!!)");
	exit();
    }

}

function addROI(tag) {
    roiManager("add");
    roiManager("select", roiManager("count") - 1);
    // roiManager("rename", iid + ":" + tag);
    roiManager("rename", tag);
    showStatus("Added ROI: " + iid + ":" + tag);
}


function set_scale () {
    check_id();

    if (selectionType == 5) { // straight line
	addROI("scale"); 
	getLine(x1, y1, x2, y2, lineWidth);
	//getPixelSize(unit, width, height, depth);
	//x1*=width; y1*=height; x2*=width; y2*=height; 
	pixel_length = sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1));

	run("Set Scale...");

	getPixelSize(unit, width, height, depth);
	x1*=width; y1*=height; x2*=width; y2*=height; 
	scale_length = sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1));

	append_result(create_path("_time.csv"), iid, ymdhms(), "pixel_length", "scale", pixel_length);
	append_result(create_path("_time.csv"), iid, ymdhms(), "scale_length", "scale", scale_length);
	append_result(create_path("_time.csv"), iid, ymdhms(), "x1", "scale", x1);
	append_result(create_path("_time.csv"), iid, ymdhms(), "y1", "scale", y1);
	append_result(create_path("_time.csv"), iid, ymdhms(), "x2", "scale", x2);
	append_result(create_path("_time.csv"), iid, ymdhms(), "y2", "scale", y2);
	saveResult();

	tiff_path = create_path(".tiff");
	run("Duplicate...", "title="+iid);
	saveAs("Tiff", tiff_path);
	close();

	print("\\Update3:[O][2] Scale = "+ pixel_length + " pixels ("+ scale_length+" cm)");
	setTool("freehand");
	scale = 1;
    } else {
	print("\\Update3:[X][2] Scale = X ---> Draw a straight scale line and do again!!");
    }
}

function check_scale () {
    if (scale == 0) {
	print("\\Update3:[X][2] Scale = X ---> Set scale first!!");
	exit();
    }
}

macro "Update scale [2]" {
    set_scale();
}

macro "Update ROI [3]" {
    check_id();
    check_scale();

    if (is("area")) {
	addROI("lesion"); 
	getStatistics(area);
	append_result(create_path("_time.csv"), iid, ymdhms(), "area", "lesion", area);
	saveResult();
	print("\\Update4:[O][3]   ROI = " + area + " (cm2)");
	run("Select None");
	roi = 1;
    } else {
	print("\\Update4:[O][3]   ROI = X ---> Need an area ROI!!");
    }
}

function check_roi () {
    if (roi == 0) {
	print("\\Update4:[X][3]   ROI = X ---> Draw ROI first!!");
	exit();
    }
}

macro "Grid [4]" {
    check_id();
    check_scale();
    check_roi();

    grid_overlay(0.5);
    count = 0;
    count = getNumber("Count:", count);
    if (count > 0) {
	append_result(create_path("_time.csv"), iid, ymdhms(), "count", "lesion", count);
	print("\\Update5:[O][4]  Grid = " + count + " (units)");
    } else
	print("\\Update5:[X][4]  Grid = Number must > 0");
}

function ymd_hms() {
    getDateAndTime(year, month, wday, mday, hour, minute, second, msec);

    month = month + 1;
    if (month <10) {month  = "0" + month;}
    if (mday  <10) {mday   = "0" + mday;}
    if (hour  <10) {hour   = "0" + hour;}
    if (minute<10) {minute = "0" + minute;}
    if (second<10) {second = "0" + second;}

    date = "" + year + "-" + month + "-" + mday;
    datetime = date + " " + hour + ":" + minute + ":" + second;

    return datetime;
}

function ymdhms() {
    getDateAndTime(year, month, wday, mday, hour, minute, second, msec);

    month = month + 1;
    if (month <10) {month  = "0" + month;}
    if (mday  <10) {mday   = "0" + mday;}
    if (hour  <10) {hour   = "0" + hour;}
    if (minute<10) {minute = "0" + minute;}
    if (second<10) {second = "0" + second;}

    datetime = "" + year + "" + month + "" + mday + "" + hour + "" + minute + "" + second;
    return datetime;
}

function grid_overlay(tileLength) {
    setBatchMode(true);
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
macro "Grid Overlay [g]" {
    if (Overlay.size > 0) {
	if (Overlay.hidden)
	    grid_overlay(0.5);
	else 
	    Overlay.hide;
    } else
	grid_overlay(0.5);
}


macro "Reload [R]" {
	run("Install...", "install=["+ getDirectory("macros") + "StartupMacros.fiji.ijm]");
}


