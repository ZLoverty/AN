function gen_compact_piv(folder)
%{
This function converts PIV data from multiple text files into more compact
.mat file, in order to reduce the number of files to store. The behavior is
consistent with pivLib.compact_PIV.to_mat() function in my Python library.
The resulting .mat data contains ("x", "y", "labels", "u", "v", "mask"),
where x, y are 2D arrays of velocity centers;
u, v are 3D arrays of velocities at each time step, with the first
dimension as time steps;
labels are the filenames of the original text file names, without
extensions;
and mask is an optional 2D array that provides the locations where
velocities are valid (within boundaries).

Usage
-----

gen_compact_piv(folder)

Input argument:

folder -- the folder directory that contains PIV data in text files (.txt)

Expected behavior:

Save a .mat file in the same directory as the input folder, with the same
name. For example, we have PIV data saved in /piv/data/path/, then the
output .mat file will be /piv/data/path.mat

Optionally, the function deletes the original text files. 

Note
----

The function assumes the .txt file name format to be "_%d.txt", where %d is
consecutive ascending integers. 

The function also assumes that the data in the text files are N x 16
matrices, where the first four columns are x, y, u, v.

In cases where the data are stored in other formats, this function has to
be modified!

Test
----
gen_compact_piv("test_files\pivtxt")

%}
disp("Generating compact PIV data from raw data in " + folder);
disp("The output will be saved as " + strip(folder, "right", filesep) + ".mat");
pivfiles = dir(fullfile(folder, "*.txt"));
nfiles = numel(pivfiles);
% generate labels array and number array
filenames = cell([1 nfiles]);
labels = cell([1 nfiles]);
numbers = zeros([1 nfiles]);
for i = 1:nfiles
    name = pivfiles(i).name;
    filenames{i} = name;
    sa = string(split(name, "."));
    labels{i} = sa(1, 1);
    number = strip(labels{i}, "_");
    numbers(i) = str2num(number);
end
filenames = string(filenames);
labels = string(labels);

% get field shape
filename = filenames(1);
fulldir = fullfile(folder, filename);
tb = readtable(fulldir, "Delimiter", " ", "Range", "A:D");
width = numel(unique(tb.Var1));
height = numel(unique(tb.Var2));

% get x, y
x = reshape(tb.Var1, [height width]);
y = reshape(tb.Var2, [height width]);

% initiate u, v
u = zeros([nfiles height width]);
v = zeros([nfiles height width]);

% sort filename array by number

[B, I] = sort(numbers);
for i = 1:nfiles
    ind = I(i);
    filename = filenames(ind);
    fulldir = fullfile(folder, filename);
    tb = readtable(fulldir, "Delimiter", " ", "Range", "A:D");
    % get u, v
    u(i,:,:) = reshape(tb.Var3, [height width]);
    v(i,:,:) = reshape(tb.Var4, [height width]);
end

% handle mask
% in my Python implementation, mask is applied as an additional column to
% the x, y, u, v data. Such column is not yet available in the immediate
% ImageJ PIV results, so here we leave the "mask" field blank.

save(strip(folder, "right", filesep) + ".mat", "x", "y", "u", "v", "labels", "-v6");

end