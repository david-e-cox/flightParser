function [lat,lon,altPres,altGPS, hour,min,sec, fix3D,latD,lonD, extData] = readIGC(filename)
%function [lat,lon,altPres,altGPS, hour,min,sec, fix3D,latD,lonD, extData] = readIGC(filename)
%
% Parses the B-records of an IGC file and returns available data
%   lon/lat are converted to decimal degrees (no minutes component)
%   altPres and altGPS  are converted from meters to ft
%   extData has B-record extensions, identified by 3-char codes
%
% IGC Specification: 
%     https://www.fai.org/sites/default/files/igc_fr_specification_2020-11-25_with_al6.pdf
%
    
fid = fopen(filename);
if (fid==-1)
    error('Unable to open file: %s\n',filename)
end

%Initialize
cnt     = 0;
Bext    = struct();
extData = struct();
extVS   = struct();

% Parse file, line-by-line
line = fgetl(fid);
while (line ~= -1)
    % First character defines the record-type
    switch(line(1))
      
      case 'I'
        % Defines the extensions appended to each B-line's manditory data
        % See Appendix A.7 of IGC spec for an extensions 3-digit code definition
        numExt = str2num(line(2:3));
        for i=0:numExt-1
            Bext.(line([8:10]+i*7)) = [str2num(line([4,5]+i*7)):str2num(line([6,7]+i*7))];
        end
        line=fgetl(fid);

      case 'B'
        % Fix Record: time and lon/lon/alt
        % Increment index counter
        cnt=cnt+1;
        % Parse and assign
        hour(cnt)    = str2num(line(2:3));
        min (cnt)    = str2num(line(4:5));
        sec (cnt)    = str2num(line(6:7));
        lat (cnt)    = dm2dd(line(8:9),line(10:14));
        latD{cnt}    = line(15);  % Note: using cell array for strings
        lon (cnt)    = dm2dd(line(16:18),line(19:23));
        lonD{cnt}    = line(24);  % Note: using cell array for strings
        fix3D(cnt)   = strcmp(line(25),'A'); % Convert from A/V to true/false
        altPres(cnt) = str2num(line(26:30))*3.28084; %Convert to ft
        altGPS(cnt)  = str2num(line(31:35))*3.28084; %Convert to ft

        % Handle extensions
        fn = fieldnames(Bext);
        for i=1:length(fn)
            try
                extDataVS(cnt).(fn{i}) = str2num(line(Bext.(fn{i})));
            catch  
                warning('non-numeric entry in B-record extension, skipping');
            end
        end
        line=fgets(fid);
      
      otherwise
        % Skip line, unprocessed records from IGC file
        line=fgetl(fid);
    end
end
fclose(fid);


% Convert extDataVS to structures of vectors
fn = fieldnames(extDataVS);
for i=1:length(fn)
    extData.(fn{i}) = [extDataVS(:).(fn{i})];
end

end

function angle = dm2dd(angleDegStr, angleMinStr);
% Convert from IGC's "degs,decimalMinutes" strings to degrees decimal
    angle  = str2num(angleDegStr) + str2num(angleMinStr)/1000/60;
end




