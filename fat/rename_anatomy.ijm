// "rename filename by anatomy"
// 1. Load dicom stacks
// 2. use shortcut to rename file by corresponding antomy.
//    for T12, L1, L2, L3, L4, L5, umbilical

//--------------------------------------- 

// "CT measurement Macro"
macro "L1 [1]" {
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
  
  /*
  if(File.exists(ipath)) 
	File.copy(ipath, ImgDir + tp + "_" + mod + "_L1_" + "s" + series + "i" + image + ".dcm");
  else
	File.copy(ipath + ".dcm", ImgDir + tp + "_" + mod + "_L1_" + "s" + series + "i" + image + ".dcm");
  */
  if(File.exists(ipath)) 
	File.copy(ipath, ImgDir + tp + "_" + mod + "_L1.dcm");
  else
	File.copy(ipath + ".dcm", ImgDir + tp + "_" + mod + "_L1.dcm");

  showStatus("L1 saved!");
}

macro "L2 [2]" {
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
	File.copy(ipath, ImgDir + tp + "_" + mod + "_L2.dcm");
  else
	File.copy(ipath + ".dcm", ImgDir + tp + "_" + mod + "_L2.dcm");

  showStatus("L2 saved!");
}

macro "L3 [3]" {
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
	File.copy(ipath, ImgDir + tp + "_" + mod + "_L3.dcm");
  else
	File.copy(ipath + ".dcm", ImgDir + tp + "_" + mod + "_L3.dcm");

  showStatus("L3 saved!");
}

macro "L4 [4]" {
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
	File.copy(ipath, ImgDir + tp + "_" + mod + "_L4.dcm");
  else
	File.copy(ipath + ".dcm", ImgDir + tp + "_" + mod + "_L4.dcm");

  showStatus("L4 saved!");
}

macro "L5 [5]" {
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
	File.copy(ipath, ImgDir + tp + "_" + mod + "_L5.dcm");
  else
	File.copy(ipath + ".dcm", ImgDir + tp + "_" + mod + "_L5.dcm");

  showStatus("L5 saved!");
}

macro "T12 [q]" {
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
	File.copy(ipath, ImgDir + tp + "_" + mod + "_T12.dcm");
  else
	File.copy(ipath + ".dcm", ImgDir + tp + "_" + mod + "_T12.dcm");

  showStatus("T12 saved!");
}

macro "Umbilical [r]" {
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
	File.copy(ipath, ImgDir + tp + "_" + mod + "_U.dcm");
  else
	File.copy(ipath + ".dcm", ImgDir + tp + "_" + mod + "_U.dcm");

  showStatus("Umbilical saved!");
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
