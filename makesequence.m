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
%   'toneconfig' = [cell|cell of cells] A cell array of key/value pairs
%       that will be used when calling maketone.m.
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
%   'filename' = [string] File path and name to save as a wav file.
%       Default '' (empty, don't save).
%
%   'Fs' = [numeric] Sampling frequency in Hz. Default 20000.
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
rhythm = 'x.x.x.x.';
tempo = 250;
tempoUnit = 'ms';
reps = 4;
filename = '';
toneconfig = {...
    'freqs',440,...
    };
Fs = 20000; % sampling freq in Hz

%% user-defined
if nargin > 0
    for i = 1:2:length(varargin)
        switch lower(varargin{i})
            case 'rhythm',      rhythm = varargin{i+1};
            case 'tempo',       tempo = varargin{i+1};
            case 'tempounit',   tempoUnit = varargin{i+1};
            case 'reps',        reps = varargin{i+1};
            case 'filename',    filename = varargin{i+1};
            case 'toneconfig',  toneconfig = varargin{i+1};
            case 'fs',          Fs = varargin{i+1};
        end
    end
end

%% make sequence

ioi = round(rate(tempo, tempoUnit, 's') * Fs); % convert tempo to ioi in samples

sequence = zeros(1, length(rhythm) * ioi); % create container for sequence

% loop through beats and put them in the metronome container
for i = 1:length(rhythm)
    switch(rhythm(i))
        case 'x'
            tone = maketone(toneconfig{:},'Fs',Fs,'duration',ioi / Fs)';
            ind = i + (ioi * (i - 1));
            sequence(ind:ind + length(tone) - 1) = tone;

        case '.'

        case '-'
            error('This functionality doesn''t work yet.')

        otherwise
            error('Unknown character in rhythm string.')

    end
end

sequence = repmat(sequence,1,reps);

% write audio file to disk
if ~isempty(filename)
    audiowrite(filename,sequence,Fs)
end
