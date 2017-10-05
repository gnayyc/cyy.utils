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
	dummy = call("fiji.FijiTools.openEditor", title, text);
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
var Title = "";
var FatLogfile = "";
var FatImgDir = "";
var AortaLogfile = "";
var AortaImgDir = "";
var CaLogfile = "";
var CaImgDir = "";
var f_title = "";
var fat_title = "";
var wvfat_title = "";
var vfat_title = "";
var pfat_title = "";

//------------------------------------ Fat related macros
// # Press [f] to set fat mask
// # Press [1] after remove all but Total Fat 
// # Press [2] after remove Subcutaneous Fat 
// # Press [3] after remove Intramuscular Fat 
// # Press [4] after remove Retroperitoneal Fat 
// # Press [0] to set the data dir
// set fat threshold
/*
macro "AutoThreshold [a]" {
  setAutoThreshold();
}
*/

macro "Set Fat Mask [f]" {
  f_title = getTitle();
  id = getTag("0010,0020");
  studyid = getTag("0020,0010");
  series = getTag("0020,0011");
  image = getTag("0020,0013");
  modality = getTag("0008,0060");
  id = replace(id, " ", "");
  studyid = replace(studyid, " ", "");
  series = replace(series, " ", "");
  image = replace(image, " ", "");
  getDimensions(width, height, channels, slices, frames);
  if (slices > 1)
      ipath = getDirectory("image") + getInfo("slice.label"); 
  else
      ipath = getDirectory("image") + f_title;

  fat_title = title+"_fat1";
  wvfat_title = title+"_wvfat2";
  vfat_title = title+"_vfat3";
  pfat_title = title+"_pfat4";


  run("Select None");
  run("View 100%");
  run("Duplicate...", "title="+fat_title);
  run("View 100%");
  if (FatImgDir == "")
    setDir();

  time = replace(getTime,"E12","");
  time = replace(time, "\\\.", "");

  ImgDir = FatImgDir + id + File.separator;
  if(!File.exists(ImgDir)) File.makeDirectory(ImgDir);
  
  if(File.exists(ipath)) 
	File.copy(ipath, ImgDir + id + "-S" + studyid + "s" + series + "i" + image + ".dcm");
  else
	File.copy(ipath + ".dcm", ImgDir + id + "-S" + studyid + "s" + series + "i" + image + ".dcm");

  save(ImgDir + id + "-S"+studyid+"s"+series+"i"+image + "-"+ time + "-0.png");
  run("Options...", "iterations=1 white count=1"); //set black background
  run("Colors...", "foreground=black background=white selection=red"); //set colors
  run("Display...", " "); //do not use Inverting LUT

  if (matches(modality, ".*MR.*"))
	setThreshold(300, 1000);
  else
    setThreshold(-250, -50);
  run("Convert to Mask");
  run("Create Selection");
  selectWindow(f_title);
  run("Restore Selection");
  selectWindow(fat_title);
  showStatus("Next Step: Total Fat then press [1]");
}


macro "TotalFat [1]" {
  setThreshold(255, 255);
  run("Create Selection");
  run("Measure");
  TF = getResult("Area");
  SF = VF = PF = RF = WVF = WF = 0;
  run("Convert to Mask");
  FatResults();
  if (FatImgDir == "")
    setDir();
  id = getTag("0010,0020");
  studyid = getTag("0020,0010");
  series = getTag("0020,0011");
  image = getTag("0020,0013");
  id = replace(id, " ", "");
  studyid = replace(studyid, " ", "");
  series = replace(series, " ", "");
  image = replace(image, " ", "");
  time = replace(getTime,"E12","");
  time = replace(time, "\\\.", "");

  ImgDir = FatImgDir + id + File.separator;
  if(!File.exists(ImgDir)) File.makeDirectory(ImgDir);

  save(ImgDir + id + "-S"+studyid+"s"+series+"i"+image + "-"+time + "-fat.png");
  run("Out [-]");
  run("Out [-]");
  run("Duplicate...", "title="+wvfat_title);
  run("Create Selection");
  selectWindow(f_title);
  run("Restore Selection");
  selectWindow(wvfat_title);
  showStatus("Next Step: Remove Subcutaneous Fat then press [2]");
}

macro "WallVisceralFat [2]" { // Get Subcutaneous Fat
  setThreshold(255, 255);
  run("Create Selection");
  run("Measure");
  WVF = getResult("Area"); // wall and visceral fat
  SF = TF - WVF;
  run("Convert to Mask");
  FatResults();
  if (FatImgDir == "")
    setDir();
  id = getTag("0010,0020");
  studyid = getTag("0020,0010");
  series = getTag("0020,0011");
  image = getTag("0020,0013");
  id = replace(id, " ", "");
  studyid = replace(studyid, " ", "");
  series = replace(series, " ", "");
  image = replace(image, " ", "");
  time = replace(getTime,"E12","");
  time = replace(time, "\\\.", "");

  ImgDir = FatImgDir + id + File.separator;
  if(!File.exists(ImgDir)) File.makeDirectory(ImgDir);

  save(ImgDir + id + "-S"+studyid+"s"+series+"i"+image + "-"+time + "-wvfat.png");
  run("Out [-]");
  run("Out [-]");
  run("Duplicate...", "title="+vfat_title);
  run("Create Selection");
  selectWindow(f_title);
  run("Restore Selection");
  selectWindow(vfat_title);
  showStatus("Next Step: Remove Wall Fat then press [3]");

}

macro "VisceralFat [3]" { // Get wall fat
  setThreshold(255, 255);
  run("Create Selection");
  run("Measure");
  VF = getResult("Area");
  WF = WVF - VF;
  run("Convert to Mask");
  FatResults();
  if (FatImgDir == "")
    setDir();
  id = getTag("0010,0020");
  studyid = getTag("0020,0010");
  series = getTag("0020,0011");
  image = getTag("0020,0013");
  id = replace(id, " ", "");
  studyid = replace(studyid, " ", "");
  series = replace(series, " ", "");
  image = replace(image, " ", "");
  time = replace(getTime,"E12","");
  time = replace(time, "\\\.", "");

  ImgDir = FatImgDir + id + File.separator;
  if(!File.exists(ImgDir)) File.makeDirectory(ImgDir);

  save(ImgDir + id + "-S"+studyid+"s"+series+"i"+image + "-"+time + "-vfat.png");
  run("Out [-]");
  run("Out [-]");
  run("Duplicate...", "title="+pfat_title);
  run("Create Selection");
  selectWindow(f_title);
  run("Restore Selection");
  selectWindow(pfat_title);
  showStatus("Next Step: Remove Retroperitoneal Fat then press [4]");
}

macro "PeritonealFat [4]" {
  setThreshold(255, 255);
  run("Create Selection");
  run("Measure");
  PF = getResult("Area");
  RF = VF - PF;
  run("Convert to Mask");
  FatResults();
  if (FatImgDir == "")
    setDir();
  id = getTag("0010,0020");
  studyid = getTag("0020,0010");
  series = getTag("0020,0011");
  image = getTag("0020,0013");
  id = replace(id, " ", "");
  studyid = replace(studyid, " ", "");
  series = replace(series, " ", "");
  image = replace(image, " ", "");
  time = replace(getTime,"E12","");
  time = replace(time, "\\\.", "");
  ImgDir = FatImgDir + id + File.separator;
  if(!File.exists(ImgDir)) File.makeDirectory(ImgDir);

  run("Create Selection");
  selectWindow(f_title);
  run("Restore Selection");
  selectWindow(pfat_title);
  save(ImgDir + id + "-S"+studyid+"s"+series+"i"+image + "-"+time + "-pfat.png");
}

macro "SaveResult [5]" {
  name = replace(getTag("0010,0010"), " ", "");
  id = replace(getTag("0010,0020"), " ", "");
  date = replace(getTag("0008,0020"), " ", "");

  SF = TF - VF;
  RF = VF - PF;
  colnames = 0;
  if (FatImgDir == "")
    setDir();
  ImgDir = FatImgDir + id + File.separator;
  if(!File.exists(ImgDir)) File.makeDirectory(ImgDir);

  if (TF*SF*VF*PF*RF == 0)
  {
	showMessage("Measurement not completed!");
  }
  else
  {
	FatLogfile = ImgDir + id + "_fat.csv";
	if(!File.exists(FatLogfile)) 
	    File.append("filename,date,id,name,Total.Fat,Subcutaneous.Fat,Visceral.Fat,Wall.Fat,Peritoneal.Fat,Extraperitoneal.Fat", FatLogfile);
	File.append(getTitle()+","+date+","+id+","+name+","+TF+","+SF+","+VF+","+WF+","+PF+","+RF, FatLogfile);
	showMessage(id + " saved!");
  }
}


macro "SaveErrorFOV [6]" {
  if (DataDir == "")
    setDir();
  ImgDir = FatImgDir + id + File.separator;
  FatLogfile = ImgDir + id + "_fat.csv");
  if(!File.exists(FatLogfile)) 
    File.append("filename,date,id,name,Total.Fat,Subcutaneous.Fat,Visceral.Fat,Wall.Fat,Peritoneal.Fat,Extraperitoneal.Fat", FatLogfile);
  File.append(getTitle()+","+date+","+id+","+name+",0,0,0,0,0,out of FOV", FatLogfile);
  showMessage(getTitle+" out of FOV saved!");
  if (FatImgDir == "")
    setDir();
  id = getTag("0010,0020");
  studyid = getTag("0020,0010");
  series = getTag("0020,0011");
  image = getTag("0020,0013");
  id = replace(id, " ", "");
  studyid = replace(studyid, " ", "");
  series = replace(series, " ", "");
  image = replace(image, " ", "");
  ImgDir = FatImgDir + id + File.separator;
  if(!File.exists(ImgDir)) File.makeDirectory(ImgDir);

  save(ImgDir + id + "-S"+studyid+"s"+series+"i"+image + "-error.png");
}

//macro "SelectFile [F8]" {
//  FatLogfile = File.openDialog("Select a File");
//}

macro "Set Data Directory [0]" {
  setDir();
}


macro "Calculate Aorta Calcification Ratio base [a]" {
  name = getTag("0010,0010");
  id = getTag("0010,0020");
  studyid = getTag("0020,0010");
  series = getTag("0020,0011");
  image = getTag("0020,0013");
  id = replace(id, " ", "");
  studyid = replace(studyid, " ", "");
  series = replace(series, " ", "");
  image = replace(image, " ", "");

  if (AortaImgDir == "")
    setDir();
  ImgDir = AortaImgDir + id + File.separator;
  if(!File.exists(ImgDir)) File.makeDirectory(ImgDir);

  save(ImgDir + id + "-S"+studyid+"s"+series+"i"+image + "-0.png");
}


macro "Calculate Aorta Calcification Ratio [9]" {
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
  id = replace(id, " ", "");
  studyid = replace(studyid, " ", "");
  series = replace(series, " ", "");
  image = replace(image, " ", "");

  Iid = getImageID();
  if (AortaImgDir == "")
    setDir();
  ImgDir = AortaImgDir + id + File.separator;
  if(!File.exists(ImgDir)) File.makeDirectory(ImgDir);

  time = replace(getTime,"E12","");
  time = replace(time, "\\\.", "");
  save(ImgDir + id + "-S"+studyid+"s"+series+"i"+image + "-"+time + "-1.png");
  t = getTitle();
  run("Duplicate...", "title="+t+"-Ao");
  Aoid = getImageID();
  run("Duplicate...", "title="+t+"-Ca");
  Caid = getImageID();
  time = replace(getTime,"E12","");
  time = replace(time, "\\\.", "");

  // calculate aorta
  selectImage(Aoid);
  run("View 100%");
  setThreshold(-25, 100);
  run("Convert to Mask");
  save(ImgDir + id + "-S"+studyid+"s"+series+"i"+image + "-"+time + "-2.png");
  setThreshold(255, 255);
  run("Create Selection");
  run("Measure");
  Ao = getResult("Area");
  //close();
  // calculate Calcification
  selectImage(Caid);
  run("View 100%");
  setThreshold(100,1500);
  run("Convert to Mask");

  save(ImgDir + id + "-S"+studyid+"s"+series+"i"+image + "-"+time + "-3.png");
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
  if (AortaLogfile == "")
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
  id = replace(id, " ", "");
  studyid = replace(studyid, " ", "");
  series = replace(series, " ", "");
  image = replace(image, " ", "");

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
  run("View 100%");
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

macro "Duplicate [d]" {
  run("Duplicate...", "title="+getTitle());
}

//macro "Set Fat Shrethold [F12]" {
//  setThreshold(-250, -50);
//}


macro "Convert to Mask [s]" {
  setThreshold(-250, -50);
  run("Convert to Mask");
}

macro "Fill [l]" {
  fill();
}


macro "Pencil [p]" {
  setTool(18);
}

macro "Brush [b]" {
  setTool("brush");
}

macro "Elliptical [e]" {
  setTool("elliptical");
}

macro "Elliptical [o]" {
  setTool("oval");
}

macro "Select None [r]" {
  run("Select None");
}

macro "WandSelect [c]" {
  wandSelect("8-connected");
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
  run("Clear Outside");
}

//macro "SaveBat [o]" {
//  name = getTag("0010,0010");
// BatFile = "c:\\tmp\\fat.bat";
//  File.append("copy D:\\IMAGES\\"+getTitle+" C:\\tmp\\images", BatFile);
//}

macro "Show Info [I]" {
  name = getTag("0010,0010");
  id = getTag("0010,0020");
  //l = getInfo("slice.label");
  getDimensions(width, height, channels, slices, frames);
  showMessage("  id: " + id + "\nname: " + name + "\nslices: ", slices);
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
    return value;
}


function FatResults() {
    id = getTag("0010,0020");
//    setResult("file", nResults -1, getTitle);
    setResult("SF", nResults - 1, SF);
    setResult("VF", nResults - 1, VF);
    setResult("id", nResults - 1, id);
    setResult("TF", nResults - 1, TF);
    setResult("PF", nResults - 1, PF);
    setResult("RF", nResults - 1, RF);
    updateResults();
}


function setDir ()
{
  DataDir = getDirectory("Choose a Directory for Data Saving");

  FatImgDir = DataDir + "Fat" + File.separator;
  if(!File.exists(FatImgDir)) File.makeDirectory(FatImgDir);
  // FatLogfile = DataDir + "fat.csv";
  // if(!File.exists(FatLogfile)) 
  //    File.append("filename,date,id,name,Total.Fat,Subcutaneous.Fat,Visceral.Fat,Wall.Fat,Peritoneal.Fat,Extraperitoneal.Fat", FatLogfile);


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

macro "Reload [R]" {
    run("Install...", "install="+getDirectory("imagej") + "/macros/StartupMacros.fiji.ijm");
    //runMacro(;
}

macro "Create Selection [s]" {
    run("Create Selection");
}

macro "Close All Windows [Q]" {
    
    while (nImages>0) { 
	selectImage(nImages); 
	close(); 
    } 
}
