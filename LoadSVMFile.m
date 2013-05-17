function [X, Y] = LoadSVMFile( fname )
%LOADSVMFILE Load svm_light data format into two matrices (data and labels)
fid = fopen(fname, 'r');
assert(fid >= 0, ['File "' fname '" could not be opened']);
X=[]; Y=[];
while 1
    l = fgetl(fid);
    if ~ischar(l), break, end
    [cl, ~, ~, nxt] = sscanf(l, '%d', 1);
    f = sscanf(l(nxt:end), '%*d:%d', inf);
    X = [X; f'];
    Y = [Y; cl];
end
fclose(fid);
end

