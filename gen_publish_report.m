% Hugo Esquivel, 2025.
% -

clearvars; close all; clc;

fileList=split(ls('main_*'));
fileList(end)=[];
fileList=sort(fileList);

filename=sscanf(mfilename,'gen_%s');

fid=fopen(sprintf('%s.m',filename),'w');

fprintf(fid,'%% This file was generated using %s.m...\n',mfilename);
fprintf(fid,'\n');

fprintf(fid,'clearvars; close all; clc;\n');
fprintf(fid,'\n');

for i=1:length(fileList)
    fprintf(fid,'publish(''%s'',''format'',''html'')\n',fileList{i});
end

fclose(fid);

run(sprintf('%s.m',filename))
