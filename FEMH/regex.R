rad.regex = function(word = "") {
    .m = "^\\w((?![Nn]o)[\\w\\s])*"
    #regex(paste0(.m, word), ignore_case=T)
    .e = "[\\w\\s]*[\\.]"
    word = tolower(word)
    .w0 = substr(word, 1, 1) 
    .w1 = paste0("[",toupper(.w0), .w0, "]")
    .w2 = substr(word, 2, nchar(word))
    .w = paste0(.w1, .w2)
    paste0(.m, .w)

}

# x[year == 2014][
#    str_detect(report, "[Pp]neumothorax")][
#    !str_detect(report, "[Nn]o\\s[\\w\\s]*[Pp]neumothorax")]

# i="pneumothorax";
# e=paste0("\\s([Nn]o|or|without)\\s[\\w\\s,]*",i);
# x[str_detect(report, i)][!str_detect(report, e)]
#  [1:40,str_extract(report, paste0(".{40}",a,".{40}"))]

str_extract(report, "(\\w*\\s*){5}([Tt]racheal*\\s*deviat|[Dd]eviat[\\w\\s]*trachea)(\\w*\\s*){5}")
x[XTYPE == "CXR"][str_detect(report, "([Tt]racheal*\\s*deviat|[Dd]eviat[\\w\\s]*trachea)")][,m := str_extract(report, ".{25}([Tt]racheal*\\s*deviat|[Dd]eviat[\\w\\s]*trachea).{10}")]
