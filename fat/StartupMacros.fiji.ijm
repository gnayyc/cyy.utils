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

var iid = "";
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


function init() {
  roiManager("reset");
  run("Clear Results");
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


  Title = getTitle();
  idir = getDirectory("image");
  iid = get_iid();
  getDimensions(width, height, channels, slices, frames);
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
  run("Set... ", "zoom=200");
  
  File.copy(ipath, create_path("_fat.dcm"));
}

macro "Set Fat Mask [f]" {
  init();

  run("Select None");
  getLocationAndSize(x, y, width, height);
  run("Duplicate...", "title="+fat_title);
  setLocation(x+width+10, y);
  run("Set... ", "zoom=200");
  
  File.copy(ipath, create_path("_fat.dcm"));

  if (modality.contains("MR")) {
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
  if (modality.contains("MR")) {
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
  run("Set... ", "zoom=200");
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
  run("Set... ", "zoom=200");
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
  run("Set... ", "zoom=200");
  run("Create Selection");
  selectWindow(Title);
  run("Set... ", "zoom=200");
  run("Restore Selection");
  selectWindow(pfat_title);
  run("Set... ", "zoom=200");
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
  run("Set... ", "zoom=200");
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
  run("Set... ", "zoom=200");
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
  run("Set... ", "zoom=200");
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
  run("Set... ", "zoom=200");
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

macro "Duplicate [d]" {
  getLocationAndSize(x, y, width, height);
  run("Duplicate...", "title="+getTitle());
  setLocation(x+200, y+50);
  run("Set... ", "zoom=200");

}

//macro "Set Fat Shrethold [F12]" {
//  setThreshold(-250, -50);
//}

/*
macro "saveResult [s]" {
    run("Set Measurements...", "area mean standard min perimeter median display redirect=None decimal=3");
    roiManager("Deselect");
    run("Clear Results");
    roiManager("Measure");
    saveAs("Results",  create_path("_results.csv"));
    roiManager("Save", create_path("_roi.zip"));
}
*/

macro "Convert to Mask [s]" {
//  setThreshold(-250, -50);
  if (matches(modality, ".*MR.*")){
    setThreshold(50, 255);
//    run("Options...", "iterations=1 black count=1"); //set black background
//    run("Colors...", "foreground=white background=black selection=red"); //set colors
  }
  else {
    setThreshold(-250, -50);
  }


  run("Convert to Mask");
}

macro "Fill [l]" {
  fill();
}


//macro "Pencil [p]" {
//  setTool(18);
//}

//macro "Brush [b]" {
//  setTool("brush");
//}

macro "Elliptical [e]" {
  setTool("oval");
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



macro "Close All Duplicated Windows [Q]" {
  n = nImages;
  for(i = 1; i <= n; i++){
    selectImage(i);
    t0 = getTitle();
    if (matches(t0, ".*fat.*"))
      close();
  }
}

function addROI(tag) {
    roiManager("add");
    roiManager("select", roiManager("count") - 1);
    roiManager("rename", iid + ":" + tag);
    showStatus("Added ROI: " + iid + ":" + tag);
}

function create_path(ext) {
  WorkDir = idir + "work" + File.separator;
  if(!File.exists(WorkDir)) File.makeDirectory(WorkDir);

  filename = WorkDir + get_iid() + ext;
  return filename;
}

function create_series_path(ext) {
  WorkDir = idir + "work" + File.separator;
  if(!File.exists(WorkDir)) File.makeDirectory(WorkDir);

  filename = WorkDir + get_sid() + ext;
  return filename;
}


// For ROI measurement

macro "init [0]" {
	init();
}

macro "Oval_10 [1]" {
    getCursorLoc(x, y, z, flags);
    makeOval(x, y, 10, 10); 
}

macro "Oval_20 [2]" {
    getCursorLoc(x, y, z, flags);
    makeOval(x, y, 20, 20); 
}

macro "Oval_30 [3]" {
    getCursorLoc(x, y, z, flags);
    makeOval(x, y, 30, 30); 
}

macro "Oval_40 [4]" {
    getCursorLoc(x, y, z, flags);
    makeOval(x, y, 40, 40); 
}

macro "Oval_50 [5]" {
    getCursorLoc(x, y, z, flags);
    makeOval(x, y, 50, 50); 
}




macro "Liver [j]" {
    addROI("liver");
    getStatistics(area, mean);
    roi = timestamp();
    append_result(create_series_path("_measurement_results.csv"), get_iid(), roi, "area", "liver", area);
    append_result(create_series_path("_measurement_results.csv"), get_iid(), roi, "mean", "liver", mean);
}

macro "Spleen [l]" {
    addROI("spleen");
    getStatistics(area, mean);
    roi = timestamp();
    append_result(create_series_path("_measurement_results.csv"), get_iid(), roi, "area", "spleen", area);
    append_result(create_series_path("_measurement_results.csv"), get_iid(), roi, "mean", "spleen", mean);
}

macro "Pancreas [k]" {
    addROI("pancreas");
    getStatistics(area, mean);
    roi = timestamp();
    append_result(create_series_path("_measurement_results.csv"), get_iid(), roi, "area", "pancreas", area);
    append_result(create_series_path("_measurement_results.csv"), get_iid(), roi, "mean", "pancreas", mean);

}


macro "Right Renal Sinus Fat [u]" {
    addROI("rkfat"); //right perirenal sinus fat
    fat = measure_threshold(-250, -50);
    roi = timestamp();
    append_result(create_series_path("_measurement_results.csv"), get_iid(), roi, "area", "rkfat", fat);

}

macro "Left Renal Sinus Fat [i]" {
    addROI("lkfat"); //right perirenal sinus fat
    fat = measure_threshold(-250, -50);
    roi = timestamp();
    append_result(create_series_path("_measurement_results.csv"), get_iid(), roi, "area", "lkfat", fat);

}

macro "Right Perirenal Thickness [o]" {
    addROI("rkthick"); //right perirenal thickness
    getStatistics(length);
    roi = timestamp();
    append_result(create_series_path("_measurement_results.csv"), get_iid(), roi, "length", "rkthick", length);
}

macro "Left Perirenal Thickness [p]" {
    addROI("lkthick "); //right perirenal thickness
    getStatistics(length);
    roi = timestamp();
    append_result(create_series_path("_measurement_results.csv"), get_iid(), roi, "length", "lkthick", length);
}

macro "Agatston Score [g]" {
    Title = getTitle();
    ca1 = measure_threshold(130, 199);
    ca2 = measure_threshold(200, 299);
    ca3 = measure_threshold(300, 399);
    ca4 = measure_threshold(400, 1500);
    ca = ca1 + ca2 * 2 + ca3 * 3 + ca4 * 4;
    append_result(create_series_path("_measurement_results.csv"), get_iid(), roi, "area", "ca1", ca1);
    append_result(create_series_path("_measurement_results.csv"), get_iid(), roi, "area", "ca2", ca2);
    append_result(create_series_path("_measurement_results.csv"), get_iid(), roi, "area", "ca3", ca3);
    append_result(create_series_path("_measurement_results.csv"), get_iid(), roi, "area", "ca4", ca4);
    append_result(create_series_path("_measurement_results.csv"), get_iid(), roi, "ca", "ca", ca);
}

macro "saveResult [s]" {
    run("Set Measurements...", "area mean standard min perimeter median display redirect=None decimal=3");
    roiManager("Deselect");
    run("Clear Results");
    roiManager("Measure");
    saveAs("Results",  create_series_path("_measurement.csv"));
    roiManager("Save", create_series_path("_measurement_roi.zip"));
}

macro "Measure areas [a]" {
    setThreshold(255, 255);
    run("Create Selection");
    run("Measure");
}


/*
macro "Next Slice [f]" {
    run("Next Slice [>]");
}

macro "Previous Slice [d]" {
    run("Previous Slice [<]");
}
*/

macro "Next Case [F]" {
  open_case(1);
  run("Set... ", "zoom=200");
}

macro "Prev Case [D]" {
  open_case(-1);
  run("Set... ", "zoom=200");
}

function append_result(Logfile, iid, roi, type, label, value) {
// create_path("_misc.csv"), get_id(), "area", "liver", value 
  if(!File.exists(Logfile)) 
    File.append("id,roi,type,label,value", Logfile);
  File.append(iid+","+roi+","+type+","+label+","+value, Logfile);
}


function open_case(direction) {
  // direction = 1 (forward), 0 (current), -1 (backward)

  idir = getDirectory("image");
  if (endsWith(getInfo("image.filename"), ".nii.gz")) {
	filemode = 1;
  } else { filemode = 0; }
  if (filemode == 1) {
      iname = getInfo("image.filename");
      list = getFileList(idir);
      idir = replace(idir, "\\", "/");

      getLocationAndSize(x, y, width, height);
      for (i=0; i<list.length; i++) {
	if (endsWith(list[i], "nii.gz")) {
	    if (iname == list[i]) {
		if (direction == 1) {
		  if (i == list.length - 1) {
		    showMessage("Done");
		    return 0;
		  } else {
		    run("Close");
		    open(idir + list[i+1]);
		    setLocation(x, y, width, height);
		    showStatus(idir + list[i+1]);
		    init();
		    return idir + list[i+1];
		  }
		} else if (direction == 0) {
		  run("Close");
		  open(idir + list[i]);
		  setLocation(x, y, width, height);
		  showStatus(idir + list[i]);
		  init();
		  return idir + list[i];
		} else {
		  run("Close");
		  open(idir + list[i-1]);
		  setLocation(x, y, width, height);
		  showStatus(idir + list[i-1]);
		  init();
		  return idir + list[i-1];
		}
	    }
	}
      }
  } else { // dirmode
      pdir = File.getParent(idir) + "/";
      list = getFileList(pdir);

      idir = replace(idir, "\\", "/");
      pdir = replace(pdir, "\\", "/");
      
      getLocationAndSize(x, y, width, height);
      for (i=0; i<list.length; i++) {
	if (endsWith(list[i], "/")) {
	  tmpdir = pdir + list[i];
	  //showMessage("idir: "+ idir + "; list[i]: " + tmpdir);
	    if (idir == tmpdir) {
		if (direction == 1) {
		  if (i == list.length - 1) {
		    showMessage("Done");
		    return 0;
		  } else {
		    run("Close");
		    open(pdir + list[i+1]);
		    setLocation(x, y, width, height);
		    showStatus(pdir + list[i+1]);
		    init();
		    return pdir + list[i+1];
		  }
		} else if (direction == 0) {
		  run("Close");
		  open(pdir + list[i]);
		  setLocation(x, y, width, height);
		  showStatus(pdir + list[i]);
		  init();
		  return pdir + list[i];
		} else {
		  if (i == 0) {
		    showMessage("Already tthe first");
		    return 0;
		  } else {
		    run("Close");
		    open(pdir + list[i-1]);
		    setLocation(x, y, width, height);
		    showStatus(pdir + list[i-1]);
		    init();
		    return pdir + list[i-1];
		  }
		}
	    }
	}
      }
  }
}

function measure_threshold(lower, upper) {
    run("Duplicate...", "title="+getTitle()+" duplicate");
    //? run("Make Inverse");
    setThreshold(lower, upper);
    run("Convert to Mask", "method=Default background=Default");
    setThreshold(255, 255);
    run("Create Selection");
    getStatistics(area);
    close();
    return area;
}

macro "Delete last ROI Manager [N]" {
  if (roiManager("count") > 0) {
      roiManager("select", roiManager("count") - 1);
      roiManager("delete");
  }
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

     return(TimeString); // Prints the time stamp
}
