function sequence = makesequence(varargin)
%MAKESEQUENCE  Make a tone sequence.
% 
% usage:
%   sequence = makesequence('key1',val1,etc.)
%
% input:
%   'notation' = [cell] number of elements in the cell is the number of 
%       "beats". These beats will go by according to the tempo, tempoUnit,
%       and beatLevel. If an item in the cell is a number it will play a tone 
%       of that frequency in Hz, if it is the string '%' it will continue 
%       the previous tone (not start a new tone onset), if it is a note 
%       string (e.g., 'a4', 'bb3', 'c#5') it will use note2freq to convert
%       the note name into the corresponding frequency.
%       Default {220 '%' 0 220 '%' 0 220 0}.
%
%   'volume' = [cell] Volume levels of each beat in 'notation'. Must be the 
%       same length as 'notation'. Beats which have a note "tied" over (i.e.,
%       they have a '%' in 'notation') will have their volume levels ignored
%       in favour of the volume of the note which has been tied over. 
%       Volume levels should be between 0 and 1. Note that volume levels
%       of 1 will probably cause distortions. Default 0.9 for all beats.
%
%   'beatLevel' = [numeric] The number of cell array positions in 'notation'
%       that are contained in one beat. Default 2 (each cell array position
%       is one eighth note).
%
%   'tempo' = [numeric] The rate of beats or the length of one beat,
%       depending on tempoUnit. Default 500 ms.
%
%   'tempoUnit' = ['hz'|'bpm'|'ms'|'s'] The units of tempo. Default 'ms'.
%
%   'reps' = [numeric] Number of repetitions of 'notation' to include in
%       the output. This basically uses repmat() on the finished sequence.
%       Default 4.
%
%   'save' = [string] File path and name to save as a wav file.
%       Default '' (empty, don't save).
%
% output:
%   sequence = [numeric|cell] A 1-by-n or 2-by-n matrix. If 
%
%   <filename> = A .wav file with the tone sequence.
%


%% defaults
notation = {220 '%' 0 220 '%' 0 220 0};
volume =   {0.9 '%' 0 0.7 '%' 0 0.7 0};
beatLevel = 2;
tempo = 500;
tempoUnit = 'ms';
reps = 4;
savefile = '';

%% user-defined

% loop through every second element of varargin

% switch/case on that element

% if there's a match to a variable name, overwrite that var with the value of the next element

%% check input and adjust variables
if length(notation) ~= length(volume)
    error('notation and volume must be the same length')
end

if ~strcmpi(tempoUnit,'ms')
    tempo = rate(tempo,tempoUnit,'ms');
    tempoUnit = 'ms';
end

tempo = tempo / beatLevel; % adjust tempo for beat level







function makeSineMetronome(filename,freq,ioi,numBeats,toneDuration,Fs)

% freq          =   frequency of each sine tone in Hz
% ioi           =   inter-onset-interval of beeps in seconds
% numBeats      =   number of beeps in the file
% toneDuration  =   length of each sine tone beep in seconds
% Fs            =   sampling rate

if toneDuration>=ioi,warning('tone duration is longer than ioi'),end

% convert ioi to samples
ioi=ioi*Fs;

% set volume
toneVolume=0.9;

% create time vector for tone
t=0:1/Fs:(toneDuration-1/Fs);

% create tone
tone=toneVolume*sin(2*pi*freq*t);

% create container for metronome
metronome=zeros(numBeats*ioi,1);

% loop through beats and put them in the metronome container
for i=1:numBeats
    beatLoc=i+(ioi*(i-1));
    metronome(beatLoc:beatLoc+length(tone)-1)=tone;
end

% write audio file to disk
audiowrite(filename,metronome,Fs)
