run("Close All");
run("Clear Results");
//open();
setBatchMode(true);
//coucou=File.directory;
dir = getDirectory("Choose a Directory ");
PIV_folder = File.getParent(dir) + "\\PIV"
if (File.exists(PIV_folder)==false) File.makeDirectory(PIV_folder);
batchPIV(dir, PIV_folder); 

function batchPIV(dir, PIV_folder) {
    list = getFileList(dir);
    for (i=0; i<list.length; i++) { 
	    if (endsWith(list[i], ".tif")) {
			//print("list.length");
			run("Close All");
			run("Clear Results");
			path2 = dir + "\\" + list[i];
			open(path2);
			rename("PIV Analysis");
			newdir = PIV_folder + "\\" + File.getNameWithoutExtension(list[i]);
			if (File.exists(newdir)==false) File.makeDirectory(newdir);
			for(j=1;j<=nSlices-1;j+=1) {
				i_f = j + 1;
				selectWindow("PIV Analysis");
				//run("Duplicate...", "duplicate range=j-i_f");
				run("Duplicate...", "title=PIV_2_slides.tif duplicate range=j-i_f");
				jack = newdir + "\\_" + j + ".txt";
				//file_name='C:/Users/Jerome Hardouin/Desktop/Claire ratchet/AN/AN_speed_p5_Noise_0.5/PIV_images/PIV_images-1.txt';
				print(jack);
				selectWindow("PIV_2_slides.tif");
				run("iterative PIV(Cross-correlation)...", "piv1=128 piv2=64 piv3=32 what=[Accept this PIV and output] noise=0.20 threshold=5 c1=3 c2=1 save=[jack]");
				//run("iterative PIV(Cross-correlation)...", "piv1=128 piv2=64 piv3=32 what=[Accept this PIV and output] noise=0.20 threshold=5 c1=3 c2=1 save=[C:/Users/Jerome Hardouin/Desktop/Claire ratchet/AN/AN_speed_p5_Noise_0.5/PIV_images/PIV_images-1.txt]");
				selectWindow("PIV Analysis");
				close("\\Others");
			}		       
		}
	updateResults;
	}
}
