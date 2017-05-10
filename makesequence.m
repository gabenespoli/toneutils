

% notation = [cell] number of elements in the cell is the number of "beats".
%   These beats will go by according to the tempo and tempoUnit.
%   If an item in the cell is a number, it will play a tone of that frequency in Hz.
%   If an item is a string, it can be a few things:
%       - '%' will continue the previous tone (not start a new tone onset)
%       - 'a4', 'bb3', 'c#5' will play that note


tempo = 500;
tempoUnit = 'ms';
beatLevel = 2; % number of cell array positions contained in one beat

notation = {220 '%' 0 220 '%' 0 220 0};
volume =   {1   '%' 0 0.7 '%' 0 0.7 0};
reps = 4;



