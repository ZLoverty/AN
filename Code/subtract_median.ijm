folder = "E:/AN/10172022"
for (i=4;i<19;i++){
	run("Close All");
	run("Image Sequence...", "open=%s/%02d/raw/00000.tif sort");
	run("Z Project...", "projection=Median");
	selectWindow("raw");
	selectWindow("MED_raw-1");
	imageCalculator("Divide create 32-bit stack", "raw","MED_raw-1");
	selectWindow("Result of raw");
	run("Image Sequence... ", "format=TIFF digits=5 use");
	run("Image Sequence... ", "format=TIFF name=[] digits=5 use save=E:/AN/10172022/05/remove-background/00000.tif");
	open("E:/AN/10172022/05/remove-background/00000.tif");
	selectWindow("00000.tif");
	close();
	run("8-bit");
	run("Image Sequence... ", "format=TIFF name=[] use");
	run("Image Sequence... ", "format=TIFF name=[] digits=5 save=E:/AN/10172022/05/remove-background/00000.tif");
	open("E:/AN/10172022/05/remove-background/00000.tif");
	selectWindow("00000.tif");
	close();
