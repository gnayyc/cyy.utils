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

macro "Liver [q]" {
    addROI("liver");
    getStatistics(area, mean);
    append_result(create_path("_results.csv"), get_iid(), "area", "liver", length);
    append_result(create_path("_results.csv"), get_iid(), "mean", "liver", mean);
}

macro "Spleen [w]" {
    addROI("spleen");
    getStatistics(area, mean);
    append_result(create_path("_results.csv"), get_iid(), "area", "spleen", length);
    append_result(create_path("_results.csv"), get_iid(), "mean", "spleen", mean);
}

macro "Pancreas [e]" {
    addROI("pancreas");
    getStatistics(area, mean);
    append_result(create_path("_results.csv"), get_iid(), "area", "pancreas", length);
    append_result(create_path("_results.csv"), get_iid(), "mean", "pancreas", mean);

}


macro "Right Renal Sinus Fat [r]" {
    addROI("rkf"); //right perirenal sinus fat
    fat = measure_threshold(-250, -50);
    append_result(create_path("_results.csv"), get_iid(), "area", "rkf", fat);

}

macro "Left Renal Sinus Fat [t]" {
    addROI("lkf"); //right perirenal sinus fat
    fat = measure_threshold(-250, -50);
    append_result(create_path("_results.csv"), get_iid(), "area", "lkf", fat);

}

macro "Right Perirenal Thickness [g]" {
    addROI("rkt"); //right perirenal thickness
    getStatistics(length);
    append_result(create_path("_results.csv"), get_iid(), "length", "rkt", length);
}

macro "Left Perirenal Thickness [h]" {
    addROI("lkt"); //right perirenal thickness
    getStatistics(length);
    append_result(create_path("_results.csv"), get_iid(), "length", "lkt", length);
}

macro "Agatston Score [c]" {
    Title = getTitle();
    ca1 = measure_threshold(130, 199);
    ca2 = measure_threshold(200, 299);
    ca3 = measure_threshold(300, 399);
    ca4 = measure_threshold(400, 1500);
    ca = ca1 + ca2 * 2 + ca3 * 3 + ca4 * 4;
    append_result(create_path("_results.csv"), get_iid(), "area", "ca1", ca1);
    append_result(create_path("_results.csv"), get_iid(), "area", "ca2", ca2);
    append_result(create_path("_results.csv"), get_iid(), "area", "ca3", ca3);
    append_result(create_path("_results.csv"), get_iid(), "area", "ca4", ca4);
    append_result(create_path("_results.csv"), get_iid(), "ca", "ca", ca);
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


macro "saveResult [s]" {
    run("Set Measurements...", "area mean standard min perimeter median display redirect=None decimal=3");
    roiManager("Deselect");
    run("Clear Results");
    roiManager("Measure");
    saveAs("Results",  create_path("_results.csv"));
    roiManager("Save", create_path("_roi.zip"));
}

macro "Measure areas [a]" {
    setThreshold(255, 255);
    run("Create Selection");
    run("Measure");
}


macro "Next Slice [f]" {
    run("Next Slice [>]");
}

macro "Previous Slice [d]" {
    run("Previous Slice [<]");
}

macro "Next Case []]" {
  open_dir(1);
}

macro "Prev Case [[]" {
  open_dir(-1);
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
    return get_id("date")
}

function get_iid() {
    return get_id("image")
}

function create_path(ext) {
  WorkDir = idir + "work" + File.separator;
  if(!File.exists(WorkDir)) File.makeDirectory(WorkDir);

  filename = WorkDir + get_iid() + ext;
  return filename;
}

function append_result(Logfile, iid, type, label, value) {
// create_path("_misc.csv"), get_id(), "area", "liver", value 
  if(!File.exists(Logfile)) 
    File.append("id,type,label,value", Logfile);
  File.append(iid+","+type+","+label+","+value, FatLogfile);
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


function addROI(tag) {
    roiManager("add");
    roiManager("select", roiManager("count") - 1);
    roiManager("rename", tag);
    showStatus("Added ROI: " + tag);
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
