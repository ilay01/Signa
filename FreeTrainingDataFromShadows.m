files = getAllFiles('C:\Users\Jan\Desktop\Training\CarImages\');
store = fullfile('C:\Users\Jan\Desktop\Training\ShadowStore');


for i=1:length(files)
    if IsShadowImage(files(i))
        [filepath,name,ext] = fileparts(char(files(i)));
        movefile(char(files(i)), char(store + "\" + name + ext));
    end
end