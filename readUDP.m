function D = readUDP(filename)
%function D = readUDP(filename)

fid = fopen(filename);

% Initialize
cnt=1;  % Stanza count, this indexs the output vectors
Dvec=struct();
line=fgetl(fid);

% Parse file
while (line~=-1)
    % pull out varable and value from line
    [varval]=strsplit(line,'=');
    var = varval{1};
    val = str2num(varval{2});
    % Assign to output 
    Dvec(cnt).(var) = val;
    % Read next line
    line=fgetl(fid);
    % Check for empty line, increment index
    if isempty(line)
        cnt=cnt+1;
        line=fgetl(fid);
    end
end

% Convert from vector of structures to struture of vectors
D=struct();
fn=fieldnames(Dvec);
for i=1:length(fn);
    D.(fn{i}) = [Dvec(:).(fn{i})]';
end


    
  
          





