// Plugins >> New >> Macro

requires("1.51w");
setBatchMode(true);
run("Median...", "radius=1");
run("Unsharp Mask...", "radius=3 mask=0.6");
setAutoThreshold("Intermodes");
getThreshold(lowT, upT);
setThreshold(40, upT);
setOption("BlackBackground", false);
run("Convert to Mask");
run("Median...", "radius=1");
doWand(0, getHeight()*0.5);
run("Duplicate...", "title=cropped");
run("Make Inverse");
run("Set...", "value=0");
run("Select None");
run("Invert LUT");
getStatistics( ar, mn );
totFatArea = ar * mn / 255;
run("Select None");
run("Analyze Particles...", "size=15000-Infinity pixel show=[Outlines]");
run("Make Binary");
run("Fill Holes");
run("Invert LUT");
doWand(getWidth()*0.5, getHeight()*0.5);
close();
run("Restore Selection");
getStatistics( ar, mn );
vscFatArea = ar * mn / 255;
close();
run("Revert");
print( "Total Fat Area: "+d2s(totFatArea,0)+"mm^2" );
print( "Visceral Fat Area: "+d2s(vscFatArea,0)+"mm^2" );
setBatchMode(false);
exit();

