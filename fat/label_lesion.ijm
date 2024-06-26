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
var sid = "";
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
    if (slices > 1)
	ipath = idir + getInfo("slice.label"); 
    else
	ipath = idir + Title;

    if(!File.exists(ipath)) {
	ipath = ipath + ".dcm";
    }
    if(!File.exists(ipath)) {
	ipath = "";
    }

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
    }
}

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

function generate_results() {
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
            ca1 = measure_threshold(130, 199);
            ca2 = measure_threshold(200, 299);
            ca3 = measure_threshold(300, 399);
            ca4 = measure_threshold(400, 1500);
            ca = ca1 + ca2 * 2 + ca3 * 3 + ca4 * 4;
            id = Array.concat(id, Roi.getProperty("id"));
            ts = Array.concat(ts, Roi.getProperty("timestamp"));
            label = Array.concat(label, name);
            type = Array.concat(type, "ca1");
            value = Array.concat(value, ca1);
            id = Array.concat(id, Roi.getProperty("id"));
            ts = Array.concat(ts, Roi.getProperty("timestamp"));
            label = Array.concat(label, name);
            type = Array.concat(type, "ca2");
            value = Array.concat(value, ca2);
            id = Array.concat(id, Roi.getProperty("id"));
            ts = Array.concat(ts, Roi.getProperty("timestamp"));
            label = Array.concat(label, name);
            type = Array.concat(type, "ca3");
            value = Array.concat(value, ca3);
            id = Array.concat(id, Roi.getProperty("id"));
            ts = Array.concat(ts, Roi.getProperty("timestamp"));
            label = Array.concat(label, name);
            type = Array.concat(type, "ca4");
            value = Array.concat(value, ca4);
            id = Array.concat(id, Roi.getProperty("id"));
            ts = Array.concat(ts, Roi.getProperty("timestamp"));
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
    //close("lifestyle");
}

function update_info() {
    setBatchMode(true);
    print("\\Clear");
    print("["+num_n+"/"+num_N+"] "+sid);
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


macro "TotalFat [f1]" {
  setThreshold(255, 255);
  run("Create Selection");
  addROI("fat");
  run("Measure");
  getStatistics(TF);
  SF = VF = PF = RF = WVF = WF = 0;
  run("Convert to Mask");
  //FatResults();

  run("Hide Overlay");
  save(create_path("_1fat.png"));
  run("Show Overlay");
  getLocationAndSize(x, y, width, height);
  run("Duplicate...", "title="+wvfat_title);
  setLocation(x, y+50);
  run("Set... ", "zoom=150");
  run("Create Selection");
  selectWindow(Title);
  run("Restore Selection");
  selectWindow(wvfat_title);
  run("Select None");
  showStatus("Next Step: Remove Subcutaneous Fat then press [F2]");
}

macro "WallVisceralFat [f2]" { // Get Subcutaneous Fat
  setThreshold(255, 255);
  run("Create Selection");
  addROI("WVF");
  getStatistics(WVF); // wall and visceral fat
  SF = TF - WVF;
  run("Convert to Mask");
  //FatResults();

  run("Hide Overlay");
  save(create_path("_2wvfat.png"));
  run("Show Overlay");
  getLocationAndSize(x, y, width, height);
  run("Duplicate...", "title="+vfat_title);
  setLocation(x, y+50);
  run("Set... ", "zoom=150");
  run("Create Selection");
  selectWindow(Title);
  run("Restore Selection");
  selectWindow(vfat_title);
  run("Select None");
  showStatus("Next Step: Remove Wall Fat then press [F3]");

}

macro "VisceralFat [f3]" { // Get wall fat
  setThreshold(255, 255);
  run("Create Selection");
  addROI("VF");
  getStatistics(VF); // visceral fat
  WF = WVF - VF;
  run("Convert to Mask");

  run("Hide Overlay");
  save(create_path("_3vfat.png"));
  run("Show Overlay");
  FatResults();

/*
  run("Out [-]");
  run("Out [-]");
  run("Duplicate...", "title="+pfat_title);
  run("Set... ", "zoom=150");
  run("Create Selection");
  selectWindow(Title);
  run("Set... ", "zoom=150");
  run("Restore Selection");
  selectWindow(pfat_title);
  run("Set... ", "zoom=150");
  run("Select None");
  showStatus("Next Step: Remove Retroperitoneal Fat then press [4]");
*/
}

macro "PeritonealFat [f4]" {
  setThreshold(255, 255);
  run("Create Selection");
  addROI("PF");
  getStatistics(PF); // peritoneal fat
  RF = VF - PF;
  run("Convert to Mask");
  FatResults();

  run("Hide Overlay");
  save(create_path("_4pfat.png"));
  run("Show Overlay");
}

macro "SaveErrorFOV [f5]" {
  SF = -1;
  TF = -1;
  VF = -1;
  FatResults();
  showMessage(getTitle+" out of FOV saved!");
  save(create_path("_error.png"));
}


function FatResults() {
  SF = TF - VF;
  RF = VF - PF;
  colnames = 0;

  if (TF*SF*VF == 0)
  {
    showMessage("Measurement not completed!");
  }
  else
  {
    FatLogfile = create_path("_fat.csv");
    if(!File.exists(FatLogfile)) 
      File.append("StudyDate,PatientID,PatientName,PatientsBirthDate,PatientSex,Total.Fat,Subcutaneous.Fat,Visceral.Fat,Wall.Fat,iid", FatLogfile);
    File.append(StudyDate+","+PatientID+","+PatientName+","+PatientsBirthDate+","+PatientSex+","+TF+","+SF+","+VF+","+WF,+",",iid, FatLogfile);

    selectWindow(Title);
    saveROI();
  }
}


macro "Save ROIs [S]" {
  saveROI();
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


function get_id(lvl) {
  if (Title == "")
    Title = getTitle();

  if (endsWith(getInfo("image.filename"), ".nii.gz"))
    return getInfo("image.filename");
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
  setLocation(x+200, y+50, width, height);
  run("Set... ", "zoom=150");

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
    //setTool("oval");
    setTool("polygon");
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

macro "TTT [v]" {
    showMessage(getImageInfo());
    showMessage(getTitle());
    showMessage(getInfo("image.subtitle"));
    getDimensions(width, height, channels, slices, frames);
    //ShowMessage(Dim[0]+Dim[1]+Dim[2]+Dim[3]+Dim[4]);
    showMessage(getSliceNumber()+"/"+slices);
}


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
	Roi.setGroup(group_id);
	Roi.setPosition(getSliceNumber());
	Roi.setProperty("timestamp", timestamp());
	Roi.setProperty("id", get_sid());
	Roi.setGroupNames(tag);
	roiManager("add");
	showStatus("Added ROI: " + sid + ":" + tag);
    } else {
	showStatus("No ROI to add");
    }
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




macro "Liver [a]" {
    if (is("area")) {
	addROI("liver", group_liver);
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

macro "Pancreas [s]" {
    if (is("area")) {
	addROI("pancreas", group_pancreas);
	update_results();
    } else {
	showStatus("No ROI to add");
    }
}


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

macro "update results[9]" {
    update_results();
}

function update_results() {
    roiManager("Deselect");
    if (RoiManager.size > 0)
	roiManager("Save", create_series_path("_roi.zip"));
    else {
	if (File.exists(create_series_path("_roi.zip"))) {
	    File.delete(create_series_path("_roi.zip"));
	}
    }
    update_info();
    if (!isActive(ImageID)) {
	print("select", ImageID);
	selectImage(ImageID);
    }
}

macro "Measure areas [A]" {
    setThreshold(255, 255);
    run("Create Selection");
    run("Measure");
}

macro "set_slice [V]" {
    nSlice = getSliceNumber();
}

macro "mid_slice [v]" {
    mid_slice();
}

var nSlice = 0;
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


macro "Next Slice [c]" {
    run("Next Slice [>]");
}

macro "Previous Slice [x]" {
    run("Previous Slice [<]");
}

macro "Next Case [C]" {
  open_case(1);
}

macro "Prev Case [X]" {
  open_case(-1);
}

macro "Next Undon Case [n]" {
  open_case(0);
}

function append_result(Logfile, sid, roi, type, label, value) {
// create_path("_misc.csv"), get_id(), "area", "liver", value 
  if(!File.exists(Logfile)) 
    File.append("id,roi,type,label,value", Logfile);
  File.append(sid+","+roi+","+type+","+label+","+value, Logfile);
}


function open_case(direction) {
    ImageX = 600;
    ImageY = -110;
    // direction = 1 (forward), 0 (find first undone), -1 (backward)

    idir = getDirectory("image");
    if (endsWith(getInfo("image.filename"), ".nii.gz")) {
	filemode = 1;
    } else { filemode = 0; }

    if (filemode == 1) { // nii.gz
	iname = getInfo("image.filename");
	list0 = getFileList(idir);
	idir = replace(idir, "\\", "/");

	list = list0;
	for (i = 0; i < list0.length; i++) {
	    if (!endsWith(list0[i], "nii.gz"))
		list = Array.deleteValue(list, list0[i]);
	}
	num_N = list.length;

	getLocationAndSize(x, y, width, height);
	call("ij.gui.ImageWindow.setNextLocation", ImageX, ImageY)
	x = ImageX;
	y = ImageY;
	for (i = 0; i < list.length; i++) {
	    if (direction == 0) {
		// XXXXX not yet done
		if (!File.exists(pdir + list[i] + "/work")) {
		    run("Close");
		    open(pdir + list[i]);
			    num_n = i + 1;
			    open(idir + list[num_n-1]);
		    setLocation(x, y, width, height);
		    //showStatus(idir + list[i] + " (" + i+1 + "/" + list.length + ")");
		    init();
		    showStatus("[" + i+1 + "/" + list.length + "] " + idir + list[i]);
		    return pdir + list[i];
		}
	    } else if (endsWith(list[i], "nii.gz")) {
		if (iname == list[i]) {
		    if (direction == 1) {
			if (i == list.length - 1) {
			    showMessage("Done");
			    return 0;
			} else {
			    run("Close");
			    num_n = i + 2;
			    open(idir + list[num_n-1]);
			    setLocation(x, y, width, height);
			    //showStatus(idir + list[i+1]);
			    //showStatus(idir + list[i+1] + " (" + i+2 + "/" + list.length + ")");
			    init();
			    showStatus("[" + i+2 + "/" + list.length + "] " + idir + list[i+1]);
			    return idir + list[i+1];
			}
		    } else { // direction == -1
			if (i == 0) {
			    showMessage("Already the first");
			    return 0;
			} else {
			    run("Close");
			    num_n = i;
			    open(idir + list[num_n-1]);
			    setLocation(x, y, width, height);
			    //showStatus(idir + list[i-1]);
			    //showStatus(idir + list[i-1] + " (" + i + "/" + list.length + ")");
			    init();
			    showStatus("[" + i + "/" + list.length + "] " + idir + list[i-1]);
			    return idir + list[i-1];
			}
		    }
		}
	    }
	}
    } else { // dirmode
	pdir = File.getParent(idir) + File.separator;
	list0 = getFileList(pdir);
	idir = replace(idir, "\\", "/");
	pdir = replace(pdir, "\\", "/");
	getLocationAndSize(x, y, width, height);
	call("ij.gui.ImageWindow.setNextLocation", x, y);

	list = list0;
	for (i = 0; i < list0.length; i++) {
	    if (! File.isDirectory(pdir + list0[i]))
		list = Array.deleteValue(list, list0[i]);
	}
	num_N = list.length;

	for (i = 0; i < list.length; i++) {
	    if (direction == 0) {
		if (!File.isDirectory(pdir + list[i] + "/work")) {
		    run("Close");
		    num_n = i + 1;
		    open(pdir + list[num_n-1]);
		    setLocation(x, y, width, height);
		    init();
		    showStatus("[" + i+1 + "/" + list.length + "] " + pdir + list[i]);
		    return pdir + list[i];
		} else {
		    found_roi = 0;
		    check = getFileList(pdir + list[i] + "/work");
		    for (j = 0; j < check.length; j++) {
			if (endsWith(check[j], "roi.zip")) found_roi = 1;
		    }
		    if (found_roi == 0) {
			run("Close");
			num_n = i + 2;
			open(pdir + list[num_n-1]);
			setLocation(x, y, width, height);
			init();
			showStatus("[" + i+1 + "/" + list.length + "] " + pdir + list[i]);
			return pdir + list[i];
		    }
		}
	    } else if (endsWith(list[i], "/")) {
		tmpdir = pdir + list[i];
		//showMessage("idir: "+ idir + "; list[i]: " + tmpdir);
		if (idir == tmpdir) {
		    if (direction == 1) {
			if (i == list.length - 1) {
			    showMessage("Done");
			    return 0;
			} else {
			    run("Close");
			    num_n = i + 2;
			    open(pdir + list[num_n-1]);
			    setLocation(x, y, width, height);
			    init();
			    showStatus("[" + i+2 + "/" + list.length + "] " + pdir + list[i+1]);
			    return pdir + list[i+1];
			}
		    } else { // direction == -1
			if (i == 0) {
			    showMessage("Already the first");
			    return 0;
			} else {
			    run("Close");
			    num_n = i;
			    open(pdir + list[num_n-1]);
			    setLocation(x, y, width, height);
			    init();
			    showStatus("[" + i + "/" + list.length + "] " + pdir + list[i-1]);
			    return pdir + list[i-1];
			}
		    }
		}
	    }
	}
    }
}

function measure_threshold(lower, upper) {
    run("Duplicate...", "title="+getTitle());
    //? run("Make Inverse");
    getStatistics(area, mean, min, max);
    if (max < lower) {
	close();
	return 0;
    }
    if (upper < min) {
	close();
	return 0;
    }
    if (max < upper)
	upper = max;
    setThreshold(lower, upper);
    run("Convert to Mask", "method=Default background=Default");
    setThreshold(255, 255);
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

macro "Abdominal window [f]" {
    setMinAndMax(-125, 225);
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

/*
macro "grid [t]" {
    if (Overlay.size > 0) {
	if (Overlay.hidden)
	    grid_overlay(0.5);
	else 
	    Overlay.hide;
    } else
	grid_overlay(0.5);
}
*/

macro "test [9]" {
    // print("["+getInfo("image.filename")+"]");
    // print(File.name);
    // print(getInfo("image.directory"));
    border2selection();
}

macro "Init [0]" {
    // print("["+getInfo("image.filename")+"]");
    // print(File.name);
    // print(getInfo("image.directory"));
    //border2selection();
    roiManager("reset");
    roiManager("Open", getDir("image")+File.getNameWithoutExtension(getInfo("image.filename"))+".zip");
    nextROI(0);
    //RoiManager.select(0);
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

macro "Set Grade X [5]" {
    updateROI("GradeX", 5);
}

macro "Set Grade R [6]" {
    updateROI("GradeR", 6);
}

macro "Select Grade 1 [a]" {
    //selectROI("Grade1");
    selectROI(1);
}
macro "Select Grade 2 [b]" {
    //selectROI("Grade2");
    selectROI(2);
}
macro "Select Grade 3 [c]" {
    //selectROI("Grade3");
    selectROI(3);
}
macro "Select Grade 4 [d]" {
    //selectROI("Grade4");
    selectROI(4);
}
macro "Select Grade 5 [e]" {
    //selectROI("Grade5");
    selectROI(5);
}

macro "save masks [s]" {
    save_mask();
}

macro "Show all ROIs [A]" {
    roiManager("select", Array.getSequence(RoiManager.size));
    roiManager("Combine");
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
	    roiManager("update");
	    roiManager("rename", tag);
	    roiManager("Save", getDir("image")+File.getNameWithoutExtension(getInfo("image.filename"))+".zip");
	    nextROI(0);
	} else {
	    roiManager("add");
	}
    } 
}

function selectROI(group_id) {
    //ix = newArray();
    //for (i = 0; i < RoiManager.size; i++) {
//	if (startsWith(RoiManager.getName(i), Name)) {
//	    ix = Array.concat(ix, i);
//	}
 //   }
    //roiManager("select", ix);
    RoiManager.selectGroup(group_id);
    roiManager("Combine");
}

macro "next ROI [n]" {
    nextROI(1);
}

macro "prev ROI [p]" {
    nextROI(-1);
}

function nextROI(direction) {
    if (RoiManager.size > 0) {
	ix = roiManager("index");
	if (direction == 0) {
	    for (i = 0; i < RoiManager.size; i++) {
		if (!startsWith(RoiManager.getName(i), "Grade")) {
		    RoiManager.select(i);
		    run("To Selection");
		    run("Out [-]");
		    current_zoom = getZoom();
		    getSelectionBounds(sx, sy, sw, sh); 
		    if (sw < 1000 || sh < 1000) {
			run("Out [-]");
			run("Out [-]");
			run("Out [-]");
			run("Out [-]");
		    }
		    RoiManager.select(i);
		    exit();
		}
	    }
	} else if (direction == -1) {
	    for (i = roiManager("index")-1; i >= 0; i--) {
		if (!startsWith(RoiManager.getName(i), "Grade")) {
		    RoiManager.select(i);
		    run("To Selection");
		    run("Out [-]");
		    current_zoom = getZoom();
		    getSelectionBounds(sx, sy, sw, sh); 
		    if (sw < 1000 || sh < 1000) {
			run("Out [-]");
			run("Out [-]");
			run("Out [-]");
			run("Out [-]");
		    }
		    RoiManager.select(i);
		    exit();
		}
	    }
	} else {
	    for (i = roiManager("index")+1; i < RoiManager.size; i++) {
		if (!startsWith(RoiManager.getName(i), "Grade")) {
		    RoiManager.select(i);
		    run("To Selection");
		    run("Out [-]");
		    current_zoom = getZoom();
		    getSelectionBounds(sx, sy, sw, sh); 
		    if (sw < 1000 || sh < 1000) {
			run("Out [-]");
			run("Out [-]");
			run("Out [-]");
			run("Out [-]");
		    }
		    RoiManager.select(i);
		    exit();
		}
	    }
	}
    }
}

function save_mask() {
    //grades = newArray("Grade1", "Grade2", "Grade3", "Grade4", "Grade5");
    setBatchMode(true);
    for (i = 0; i < 5; i++) {
	m_file = getDir("image")+File.getNameWithoutExtension(getInfo("image.filename"))+"_grade"+ (i+1) +".png";
	//RoiManager.selectGroup();
	//selectROI(grades[i]);
	selectROI(i+1);
	if (RoiManager.selected > 0) {
	    run("Create Mask");
	    run("Invert");
	    save(m_file);
	    close();
	}
    }
    setBatchMode(false);
}



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
