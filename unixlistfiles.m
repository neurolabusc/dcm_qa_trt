function listf = unixlistfiles(lsargs, varargin)
% function listf = unixlistfiles(lsargs, varargin)
%
% simply call unix ls (or find) to get a list of files
% the output is converted in matlab cells for simplicity
%
% the arg is a string that must exactly correspond a options of 'ls'
% type "man ls" in the shell.
%
% Warning : LINUX ONLY
%
% Exemples :
% listfiles('/some/path/', 1) => this will use find
% listfiles('/some/path/wa_*.img') 
% listfiles('/some/path/[0-9][0-9][0-9].img')   
% listfiles('-d /some/path/[0-9][0-9][0-9].img')  
% 
% Brice Fernandez - March 2011
% Update - Oct 2014
% Update - Sept 2015 - for linux only 



if( ischar(lsargs) < 1) 
    error('unixlistfiles:ArgCheck','arg 1 should be a string /path/to/file/i*');    
end

if( nargin == 2)
    usefind=1; 
else
    usefind=0; 
end

lsargs = fullfile(lsargs); 

if( isunix == 1 )
    
    if( usefind == 1) 
        idx=find(lsargs=='/');
        dir1=lsargs(1:idx(end)-1);
        files=lsargs(idx(end)+1: end);
        [status, list] = unix(['find ' dir1 ' -name ' '' files '' ]);
    else
        [status, list] = unix(['ls -1 ' lsargs]);
    end
    
    if(status == 0)
        idx_empty = find( isspace(list) == 1 );
        
        listf = cell(1,1);
        
        idx=1;
        listf{idx} = deblank(list(1:idx_empty(1)));
        
        idx=idx+1;
        
        for k = 1 : length(idx_empty)-1,
            if( isempty(deblank(list(idx_empty(k)+1:idx_empty(k+1)))) ~= 1 )
                
                listf{idx} = deblank(list(idx_empty(k)+1:idx_empty(k+1)));
                idx = idx +1;
            end
        end
    else
        % else error display output from the system        
        error(list);
    end
      
else
    error('unixlistfiles:OS', 'This function does not works on your OS')
end

