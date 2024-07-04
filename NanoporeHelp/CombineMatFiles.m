%Saving Multiple .mat files into one

inputdir='/Users/victor/Documents/CSULBPhys/KlotzLab/04_04_2024';

FileList = dir(fullfile(inputdir, '*.mat'));  % List of all MAT files
allData  = struct();
for iFile = 1:numel(FileList)               % Loop over found files
  Data   = load(fullfile(inputdir, FileList(iFile).name));
  Fields = fieldnames(Data);
  for iField = 1:numel(Fields)              % Loop over fields of current file
    aField = Fields{iField};
    if isfield(allData, aField)             % Attach new data:
       %allData.(aField) = [allData.(aField), Data.(aField)];
       
       % [EDITED]
       % The orientation depends on the sizes of the fields. There is no
       % general method here, so maybe it is needed to concatenate 
       % vertically:
       allData.(aField) = [allData.(aField); Data.(aField)];
       % Or in general with suiting value for [dim]:
       % allData.(aField) = cat(dim, allData.(aField), Data.(aField));
    else
       allData.(aField) = Data.(aField);
    end
  end
end
[path name ext] = fileparts(inputdir);
save(fullfile(inputdir, [name,'_events.mat']), '-struct', 'allData');