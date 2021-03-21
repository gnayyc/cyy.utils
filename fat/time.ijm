macro "Set time [1]" {
    var E = 1;
    ImgDir = getDirectory("image") + File.separator;
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
    tname= getTitle;
    dotIndex = indexOf(tname, ".");
    title = substring(tname, 0, dotIndex);
    TimeLogfile = ImgDir + title + "_time.csv";
    if(!File.exists(TimeLogfile)) 
	File.append("file,event,date,time", TimeLogfile);
    File.append(getTitle() +",E,"+ date +","+ time, TimeLogfile);
    showStatus(getTitle() +",E,"+ date +","+ time);
}
macro "Set time [2]" {
    var E = 2;
    ImgDir = getDirectory("image") + File.separator;
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
    tname= getTitle;
    dotIndex = indexOf(tname, ".");
    title = substring(tname, 0, dotIndex);
    TimeLogfile = ImgDir + title + "_time.csv";
    #TimeLogfile = ImgDir + getTitle() + "_time.csv";
    if(!File.exists(TimeLogfile)) 
	File.append("file,event,date,time", TimeLogfile);
    File.append(getTitle() +",E,"+ date +","+ time, TimeLogfile);
    showStatus(getTitle() +",E,"+ date +","+ time);
}
macro "Set time [3]" {
    var E = 3;
    ImgDir = getDirectory("image") + File.separator;
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
    tname= getTitle;
    dotIndex = indexOf(tname, ".");
    title = substring(tname, 0, dotIndex);
    TimeLogfile = ImgDir + title + "_time.csv";
    #TimeLogfile = ImgDir + getTitle() + "_time.csv";
    if(!File.exists(TimeLogfile)) 
	File.append("file,event,date,time", TimeLogfile);
    File.append(getTitle() +",E,"+ date +","+ time, TimeLogfile);
    showStatus(getTitle() +",E,"+ date +","+ time);
}

