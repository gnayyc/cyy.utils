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
var id = "";
var tp = "";
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
  tp = id + "_" + date;

  getDimensions(width, height, channels, slices, frames);
  if (slices > 1)
      ipath = getDirectory("image") + getInfo("slice.label"); 
  else
      ipath = getDirectory("image") + Title;

  fat_title = Title+"_1fat";
  wvfat_title = Title+"_2wvfat";
  vfat_title = Title+"_3vfat";
  pfat_title = Title+"_4pfat";


  run("Select None");
  run("View 100%");
  run("Duplicate...", "title="+fat_title);
  run("View 100%");

  time = replace(getTime,"E12","");
  time = replace(time, "\\\.", "");

  //setDir();
  // ImgDir = FatImgDir + id + File.separator;
  // ImgDir = getDirectory("image") + "work" + File.separator;
  // if(!File.exists(ImgDir)) File.makeDirectory(ImgDir);
  
  if(File.exists(ipath)) 
  	File.copy(ipath, create_path("_fat.dcm");
  else
    File.copy(ipath + ".dcm", create_path("_fat.dcm"));


  run("Options...", "iterations=1 white count=1"); //set black background
  run("Colors...", "foreground=black background=white selection=red"); //set colors
  run("Display...", " "); //do not use Inverting LUT

  if (matches(modality, ".*MR.*")) {
  	//setThreshold(300, 1000);
    setThreshold(50, 500);
  }
  else
    setThreshold(-250, -50);
  run("Convert to Mask");
  run("Create Selection");
  selectWindow(Title);
  run("Restore Selection");
  selectWindow(fat_title);
  run("Select None");
  run("Add Image...", "image="+Title+" x=0 y=0 opacity=80");
  showStatus("Next Step: Total Fat then press [1]");
}


macro "TotalFat [1]" {
  setThreshold(255, 255);
  run("Create Selection");
  addROI("fat");
  getStatitstics(TF);
  SF = VF = PF = RF = WVF = WF = 0;
  run("Convert to Mask");
  FatResults();

  run("Hide Overlay");
  save(create_path("_1fat.png"))
  run("Show Overlay");
  run("Out [-]");
  run("Out [-]");
  run("Duplicate...", "title="+wvfat_title);
  run("Create Selection");
  selectWindow(Title);
  run("Restore Selection");
  selectWindow(wvfat_title);
  run("Select None");
  showStatus("Next Step: Remove Subcutaneous Fat then press [2]");
}

macro "WallVisceralFat [2]" { // Get Subcutaneous Fat
  setThreshold(255, 255);
  run("Create Selection");
  addROI("WVF");
  getStatitstics(WVF); // wall and visceral fat
  SF = TF - WVF;
  run("Convert to Mask");
  FatResults();

  run("Hide Overlay");
  save(create_path("_2wvfat.png"))
  run("Show Overlay");
  run("Out [-]");
  run("Out [-]");
  run("Duplicate...", "title="+vfat_title);
  run("Create Selection");
  selectWindow(Title);
  run("Restore Selection");
  selectWindow(vfat_title);
  run("Select None");
  showStatus("Next Step: Remove Wall Fat then press [3]");

}

macro "VisceralFat [3]" { // Get wall fat
  setThreshold(255, 255);
  run("Create Selection");
  addROI("VF");
  getStatitstics(VF); // visceral fat
  WF = WVF - VF;
  run("Convert to Mask");
  FatResults();

  run("Hide Overlay");
  save(create_path("_3vfat.png"))
  run("Show Overlay");
  run("Out [-]");
  run("Out [-]");
  run("Duplicate...", "title="+pfat_title);
  run("Create Selection");
  selectWindow(Title);
  run("Restore Selection");
  selectWindow(pfat_title);
  run("Select None");
  showStatus("Next Step: Remove Retroperitoneal Fat then press [4]");
}

macro "PeritonealFat [4]" {
  setThreshold(255, 255);
  run("Create Selection");
  addROI("PF");
  getStatitstics(PF); // peritoneal fat
  RF = VF - PF;
  run("Convert to Mask");
  FatResults();

  run("Hide Overlay");
  save(create_path("_4pfat.png"))
  run("Show Overlay");
  saveResult();
}

macro "SaveResult [5]" {
  saveResult();
}

function saveResult() {
  name = replace(getTag("0010,0010"), " ", "");
  id = replace(getTag("0010,0020"), " ", "");
  date = replace(getTag("0008,0020"), " ", "");
  tp = id + "_" + date;

  SF = TF - VF;
  RF = VF - PF;
  colnames = 0;
  // setDir();
  // ImgDir = FatImgDir + id + File.separator;
  // ImgDir = getDirectory("image") + "work" + File.separator;
  // if(!File.exists(ImgDir)) File.makeDirectory(ImgDir);

  if (TF*SF*VF*PF*RF == 0)
  {
  	showMessage("Measurement not completed!");
  }
  else
  {
    FatLogfile = create_path("_fat.csv");
  	if(!File.exists(FatLogfile)) 
	    File.append("filename,date,id,name,Total.Fat,Subcutaneous.Fat,Visceral.Fat,Wall.Fat,Peritoneal.Fat,Extraperitoneal.Fat", FatLogfile);
  	File.append(getTitle()+","+date+","+id+","+name+","+TF+","+SF+","+VF+","+WF+","+PF+","+RF, FatLogfile);

    run("Set Measurements...", "area mean standard min perimeter median display redirect=None decimal=3");
    roiManager("Deselect");
    run("Clear Results");
    roiManager("Measure");
    saveAs("Results",  create_path("_results.csv"));
    roiManager("Save", create_path("_roi.zip"));

    showMessage(id + " saved!");
  }
}


function get_id(lvl) {
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
  tp = id + "_" + date;

  getDimensions(width, height, channels, slices, frames);
  idir = getDirectory("image");
  if (slices > 1)
      ipath = getDirectory("image") + getInfo("slice.label"); 
  else
      ipath = getDirectory("image") + Title;

  if (matches(modality, ".*MR.*"))
    mod = "MR";
  else
    mod = "CT";

  time = replace(getTime,"E12","");
  time = replace(time, "\\\.", "");

  if (lvl == "date")
    iid = id + "_" + date;
  else if (lvl == "series")
    iid = id + "_" + date + "-S"+studyid + "_s"+series;
  else if (lvl == "image")
    iid = id + "_" + date + "-S"+studyid + "_s"+series + "_i"+image;
  return iid;
}

function get_sid() {
    id = get_id("date");
    return id;
}

function get_iid() {
    id = get_id("image");
    return id;
}


macro "SaveErrorFOV [6]" {
  // if (DataDir == "")
  //  setDir();
  // ImgDir = FatImgDir + id + File.separator;
  ImgDir = getDirectory("image") + "work" + File.separator;
  FatLogfile = ImgDir + id + "_fat.csv");
  if(!File.exists(FatLogfile)) 
    File.append("filename,date,id,name,Total.Fat,Subcutaneous.Fat,Visceral.Fat,Wall.Fat,Peritoneal.Fat,Extraperitoneal.Fat", FatLogfile);
  File.append(getTitle()+","+date+","+id+","+name+",0,0,0,0,0,out of FOV", FatLogfile);
  showMessage(getTitle+" out of FOV saved!");
  // if (FatImgDir == "")
  //  setDir();
  id = getTag("0010,0020");
  studyid = getTag("0020,0010");
  series = getTag("0020,0011");
  image = getTag("0020,0013");
  id = replace(id, " ", "");
  studyid = replace(studyid, " ", "");
  series = replace(series, " ", "");
  image = replace(image, " ", "");
  ImgDir = getDirectory("image") + "work" + File.separator;
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

  // if (AortaImgDir == "")
  //  setDir();
  // ImgDir = AortaImgDir + id + File.separator;
  ImgDir = getDirectory("image") + "work" + File.separator;
  if(!File.exists(ImgDir)) File.makeDirectory(ImgDir);

  save(ImgDir + id + "-S"+studyid+"s"+series+"i"+image + "-0Aorta.png");
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
  run("View 100%");
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
  run("View 100%");
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

macro "Reload [R]" {
    run("Install...", "install="+getDirectory("imagej") + "/macros/StartupMacros.fiji.ijm");
    //runMacro(;
}

macro "Create Selection [s]" {
    run("Create Selection");
}

macro "Scale Bar [B]" {
    run("Scale Bar...");
}



macro "Close All Windows [Q]" {
    
    while (nImages>0) { 
	selectImage(nImages); 
	close(); 
    } 
}

function addROI(tag) {
    roiManager("add");
    roiManager("select", roiManager("count") - 1);
    roiManager("rename", tag);
    showStatus("Added ROI: " + tag);
}

function create_path(ext) {
  idir = getDirectory("image");
  WorkDir = idir + "work" + File.separator;
  if(!File.exists(WorkDir)) File.makeDirectory(WorkDir);

  filename = WorkDir + get_iid() + ext;
  return filename;
}



/* for 3d stacks
macro "Fat [f]" {
    Title = getTitle();
    run("Duplicate...", "title="+Title+"_fat duplicate");
    setThreshold(-250, -50);
    run("Convert to Mask", "method=Default background=Default");
}

macro "Muscle [g]" {
    Title = getTitle();
    run("Duplicate...", "title="+Title+"_muscle duplicate");
    setThreshold(-49, 80);
    run("Convert to Mask", "method=Default background=Default");
}

macro "Measure areas [a]" {
	setThreshold(255, 255);
	run("Create Selection");
	run("Measure");
}

macro "Clear Outside [X]" {
  run("Clear Outside", "slice");
}


*/

