%MAKESEQUENCE  Make a tone sequence.
% 
% usage:
%   sequence = makesequence('key1',val1,etc.)
%
% input:
%   'rhythm' = [string] A rhythm string. 'x' indicates a note onset,
%       '.' indicates a rest, and '-' indicates a note held from the
%       previous note.
%
%   'notation' = [cell] number of elements in the cell is the number of 
%       "beats". These beats will go by according to the tempo, tempoUnit,
%       and beatLevel. If an item in the cell is a number it will play a tone 
%       of that frequency in Hz, if it is the string '%' it will continue 
%       the previous tone (not start a new tone onset), if it is a note 
%       string (e.g., 'a4', 'bb3', 'c#5') it will use note2freq to convert
%       the note name into the corresponding frequency.
%       Default {220 '%' 0 220 '%' 0 220 0}.
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
%   'reps' = [numeric] Number of repetitions of the rhythm to include in
%       the output. This basically uses repmat() on the finished sequence.
%       Default 4.
%
%   'save' = [string] File path and name to save as a wav file.
%       Default '' (empty, don't save).
%
%   'tones' = [cell|cell of cells] A cell array of key/value pairs that
%       will be used when calling maketone.m. Available parameters are 
%       '
%
% output:
%   sequence = [numeric] A 1-by-n or 2-by-n matrix.
%
%   Fs = [numeric] The sampling frequency of the sequence in Hz.
%
%   <filename> = A .wav file with the tone sequence.
%
% Written by Gabriel A. Nespoli (gabenespoli@gmail.com) and Sean Gilmore.

function [sequence,Fs] = makesequence(varargin)

%% defaults
rhythm = 'x-x.x.x.';
volume = 0.9; 
beatLevel = 2;
tempo = 500;
tempoUnit = 'ms';
reps = 4;
savefile = '';
tone = {'freq',[220 440]};

%% user-defined

% loop through every second element of varargin
if nargin > 1 
    for i = 1:2:length(varargin)
        switch varargin
            case 'rhythm'
                rhythm = {i+1};
            case 'beatLevel'
                beatLevel = {i+1};
            case 'tempo'
                tempo = {i+1};
            case 'tempUnit'
                tempoUnit = {i+1};
            case 'reps'
                rep = {i+1};
            case 'savefile'
                savefile = {i+1};
        end
    end
end

%% check and adjust variables
if length(notation) ~= length(volume)
    error('notation and volume must be the same length')
end

if ~strcmpi(tempoUnit,'ms')
    tempo = rate(tempo,tempoUnit,'ms');
    tempoUnit = 'ms';
end

tempo = tempo / beatLevel; % adjust tempo for beat level



%% make sequence

% freq          =   frequency of each sine tone in Hz
% ioi           =   inter-onset-interval of beeps in seconds
% numBeats      =   number of beeps in the file
% toneDuration  =   length of each sine tone beep in seconds
% Fs            =   sampling rate

ioi=ioi*Fs; % convert ioi to samples
toneVolume=0.9; % set volume
t=0:1/Fs:(toneDuration-1/Fs); % create time vector for tone
tone=toneVolume*sin(2*pi*freq*t); % create tone
metronome=zeros(numBeats*ioi,1); % create container for metronome

% loop through beats and put them in the metronome container
for i=1:numBeats
    beatLoc=i+(ioi*(i-1));
    metronome(beatLoc:beatLoc+length(tone)-1)=tone;
end

% write audio file to disk
if ~isempty(filename)
    audiowrite(filename,sequence,Fs)
end
