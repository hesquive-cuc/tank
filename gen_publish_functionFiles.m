% Hugo Esquivel, 2025.
% -

clearvars; close all; clc;

fileList=split(ls('get*'));
fileList(end)=[];
fileList=sort(fileList);

filename=sscanf(mfilename,'gen_%s');

fid=fopen(sprintf('%s.m',filename),'w');

fprintf(fid,'%%%% File containing all function files used... generated using %s.m\n',mfilename);
fprintf(fid,'\n');

for i=1:length(fileList)
    fprintf(fid,'%%%% %s\n',fileList{i});
    fprintf(fid,'%% <include>%s</include>\n',fileList{i});
    fprintf(fid,'\n');
end

fclose(fid);

publish(sprintf('%s.m',filename),'format','html')
