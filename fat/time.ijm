macro "Set time [1]" {
    settime(1);
}

macro "Set time [2]" {
    settime(2);
}

macro "Set time [3]" {
    settime(3);
}

macro "Set time [5]" {
    settime(4);
}

macro "Set time [5]" {
    settime(3);
}

function settime(E) {
    getDateAndTime(year, month, wday, mday, hour, minute, second, msec);
    date = "" + year;
    month = month + 1;
    if (month<10) {date = date+"0";}
	date = date + month;
    if (mday<10) {date = date+"0";}
	date = date + mday;
    time = "";
    if (hour < 10) {time = time + "0"};
	time = time + hour;
    if (minute<10) {time = time + "0";}
	time = time + minute;
    if (second<10) {time = time + "0";}
	time= time + second;

    TimeLogfile = create_path("_time.csv");
    if(!File.exists(TimeLogfile)) 
	File.append("file,event,date,time", TimeLogfile);
    File.append(getTitle() + "," + E + "," + date + "," + time, TimeLogfile);
     showStatus(getTitle() + "," + E + "," + date + "," + time);
}

function create_path(ext) {
  ImgDir = getDirectory("image") + File.separator;
  tname= getTitle;
  dotIndex = indexOf(tname, ".");
  title = substring(tname, 0, dotIndex);
  filename = ImgDir + title + ext;
  return filename;
}

function saveROI() {
    run("Set Measurements...", "area mean standard perimeter median skewness kurtosis display redirect=None decimal=3");
    saveAs("Results",  create_path("_results.csv"));
    roiManager("Save", create_path("_roi.zip"));

    if (endsWith(getInfo("image.filename"), ".nii.gz")) {
	showMessage(create_path("_results.csv") + " saved!");
    } else {
	showMessage(id + " saved!");
    }
  }
}
