function y=rate(x,from,to)
%RATE Convert rate units.
%   Y = RATE(X,FROM,TO) converts a number X in unit FROM into the unit TO.
%   Units are specified as strings: 'hz' 'bpm' 'ms' 's'
%
%   Examples: rate(120,'bpm','hz') = 2
%             rate(2,  'hz', 'ms') = 500
%             rate(500,'ms','bpm') = 120
% 
% Written by Gabe Nespoli 2014-01-30.

if ischar(x), x = str2num(x); end

% convert x to Hz
switch lower(from)
    case 'hz',  y=x;
    case 'bpm', y=x/60;        
    case 'ms',  y=1/(x/1000);
    case 's',   y=1/x;
    otherwise,  error(['Unrecognized input format ''',from,''''])
end

% convert x (in Hz) to desired output
switch lower(to)
    case 'hz'
    case 'bpm', y=y*60;        
    case 'ms',  y=(1/y)*1000;
    case 's',   y=1/y;
    otherwise,  error(['Unrecognized output format ''',to,''''])
end

end