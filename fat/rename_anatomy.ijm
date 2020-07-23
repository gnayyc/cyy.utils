// "rename filename by anatomy"
// 1. Load dicom stacks
// 2. use shortcut to rename file by corresponding antomy.
//    for T12, L1, L2, L3, L4, L5, umbilical

//--------------------------------------- 

// "CT measurement Macro"
macro "L1 [1]" {
  savelvl("L1");
}

macro "L2 [2]" {
  savelvl("L2");
}

macro "L3 [3]" {
  savelvl("L3");
}

macro "L4 [4]" {
  savelvl("L4");
}

macro "L5 [5]" {
  savelvl("L5");
}

macro "T12 [q]" {
  savelvl("T12");
}

macro "Spleen [v]" {
  savelvl("Spleen");
}

macro "Pancreas Head [z]" {
  savelvl("ps1");
}

macro "Pancreas Body [x]" {
  savelvl("ps2");
}

macro "Pancreas Tail [c]" {
  savelvl("ps3");
}

macro "Umbilical [r]" {
  savelvl("Umbilicus");
}

macro "Next Slice [f]" {
    run("Next Slice [>]");
}

macro "Previous Slice [d]" {
    run("Previous Slice [<]");
}

macro "Next Case [s]" {
  open_dir(1);
}

macro "Prev Case [a]" {
  open_dir(-1);
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

  ImgDir = idir + "anatomy" + File.separator;
  if(!File.exists(ImgDir)) File.makeDirectory(ImgDir);
  
  if(File.exists(ipath)) 
	File.copy(ipath, ImgDir + tp + "_" + mod + "_" + lvl + ".dcm");
  else
	File.copy(ipath + ".dcm", ImgDir + tp + "_" + mod + "_" + lvl + ".dcm");

  showStatus(lvl + " (" + id + ") saved!");
}

function open_dir(direction) {
  // direction = 1 (forward), 0 (current), -1 (backward)
  idir = getDirectory("image");
  pdir = File.getParent(idir) + "/";
  list = getFileList(pdir);

  idir = replace(idir, "\\", "/");
  pdir = replace(pdir, "\\", "/");
  
  for (i=0; i<list.length; i++) {
  	if (endsWith(list[i], "/")) {
      tmpdir = pdir + list[i];
      //showMessage("idir: "+ idir + "; list[i]: " + tmpdir);
  	    if (idir == tmpdir) {
      		if (direction == 1) {
              run("Close");
      		    open(pdir + list[i+1]);
              showStatus(pdir + list[i+1]);
      		    return pdir + list[i+1];
      		} else if (direction == 0) {
              run("Close");
      		    open(pdir + list[i]);
              showStatus(pdir + list[i]);
      		    return pdir + list[i];
      		} else {
              run("Close");
      		    open(pdir + list[i-1]);
              showStatus(pdir + list[i-1]);
      		    return pdir + list[i-1];
      		}
  	    }
  	}
  }
}

