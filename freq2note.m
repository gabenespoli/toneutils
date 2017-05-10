function [notes,varargout]=freq2note(varargin)
%FREQ2NOTE  Convert frequency to note name.
%   NOTES = FREQ2NOTE(FREQS) converts a cell array of frequencies into
%   a cell array of note names notes. Notes are the closest equal-
%   tempered frequency.
%
%   [NOTES,CENTS] = FREQ2NOTE(FREQS) also returns the number of cents
%   different each note is compared to the closest equal-tempered
%   frequency.
%
%   NOTES = FREQ2NOTE(FREQS,VERBOSE) toggles note names that include the
%   cents value. e.g. for 60 Hz, 'B1' vs 'B1-49'. Enter 0 or 1. Default 1.
%
%   NOTES = FREQ2NOTE(FREQS,[],REFFREQ) uses REFFREQ as the frequency of
%   the reference pitch for calculation. Default 440 Hz.
%
%   NOTES = FREQ2NOTE(FREQS,[],REFFREQ,REFNOTE) uses REFFREQ as the
%   frequency of the reference pitch, REFNOTE, for calculation. Default A4.
%
%   Examples: notes=freq2note([32.6654 370.0026 833.0118]);
%             notes={'C1-2' 'Gb4+0' 'Ab5+5'}
%
%             [notes,cents]=freq2note([32.6654 370.0026 833.0118],0);
%             notes={'C1' 'Gb4' 'Ab5'}
%             cents=[-2.0020  0.0383  5.0001]
%
%   See also NOTE2FREQ.

% Written by Gabe Nespoli 2014-01-23.

% default parameters
verbose=1;
refFreq=440;
refNote='A4';

% get input parameters
freqs=varargin{1};
if nargin>1, verbose=varargin{2}; end
if nargin>2, refFreq=varargin{3}; end
if nargin>3, refNote=varargin{4}; end

refNumber=NameNumberNoteConvert({refNote},'name2number');

% convert freqs to note numbers & cents
notenumbers=zeros(1,length(freqs));
cents=zeros(1,length(freqs));
for i=1:length(freqs)
    notenumbers(i)=round(log2(((freqs(i)/refFreq)^12)*(2^(refNumber))));
    tunedFreq=refFreq*((2^(1/12))^(notenumbers(i)-refNumber));
    cents(i)=log2((freqs(i)/tunedFreq)^1200);
end

% convert note numbers to note names
notes=NameNumberNoteConvert(notenumbers,'number2name');

if verbose
    for i=1:length(notes)
        if round(cents(i))<0, notes{i}=[notes{i},num2str(round(cents(i)))];
        else notes{i}=[notes{i},'+',num2str(round(cents(i)))];
        end
    end
end

if length(notes)==1 % if only one note, convert to string
    notes=notes{1};
end
varargout={cents};
end

function out=NameNumberNoteConvert(in,type)

% define sharp-to-flat note conversion
sf={'A#0','Bb0',...
    'C#1','Db1',...
    'D#1','Eb1',...
    'F#1','Gb1',...
    'G#1','Ab1',...
    'A#1','Bb1',...
    'C#2','Db2',...
    'D#2','Eb2',...
    'F#2','Gb2',...
    'G#2','Ab2',...
    'A#2','Bb2',...
    'C#3','Db3',...
    'D#3','Eb3',...
    'F#3','Gb3',...
    'G#3','Ab3',...
    'A#3','Bb3',...
    'C#4','Db4',...
    'D#4','Eb4',...
    'F#4','Gb4',...
    'G#4','Ab4',...
    'A#4','Bb4',...
    'C#5','Db5',...
    'D#5','Eb5',...
    'F#5','Gb5',...
    'G#5','Ab5',...
    'A#5','Bb5',...
    'C#6','Db6',...
    'D#6','Eb6',...
    'F#6','Gb6',...
    'G#6','Ab6',...
    'A#6','Bb6',...
    'C#7','Db7',...
    'D#7','Eb7',...
    'F#7','Gb7',...
    'G#7','Ab7',...
    'A#7','Bb7',...
};

% define piano key numbers (array index is number)
nn={'A0'...     %1
    'Bb0'...    %2
    'B0'...     %3
    'C1'...     %4
    'Db1'...    %5
    'D1'...     %6
    'Eb1'...    %7
    'E1'...     %8
    'F1'...     %9
    'Gb1'...    %10
    'G1'...     %11
    'Ab1'...    %12
    'A1'...     %13
    'Bb1'...    %14
    'B1'...     %15
    'C2'...     %16
    'Db2'...    %17
    'D2'...     %18
    'Eb2'...    %19
    'E2'...     %20
    'F2'...     %21
    'Gb2'...    %22
    'G2'...     %23
    'Ab2'...    %24
    'A2'...     %25
    'Bb2'...    %26
    'B2'...     %27
    'C3'...     %28
    'Db3'...    %29
    'D3'...     %30
    'Eb3'...    %31
    'E3'...     %32
    'F3'...     %33
    'Gb3'...    %34
    'G3'...     %35
    'Ab3'...    %36
    'A3'...     %37
    'Bb3'...    %38
    'B3'...     %39
    'C4'...     %40
    'Db4'...    %41
    'D4'...     %42
    'Eb4'...    %43
    'E4'...     %44
    'F4'...     %45
    'Gb4'...    %46
    'G4'...     %47
    'Ab4'...    %48
    'A4'...     %49
    'Bb4'...    %50
    'B4'...     %51
    'C5'...     %52
    'Db5'...    %53
    'D5'...     %54
    'Eb5'...    %55
    'E5'...     %56
    'F5'...     %57
    'Gb5'...    %58
    'G5'...     %59
    'Ab5'...    %60
    'A5'...     %61
    'Bb5'...    %62
    'B5'...     %63
    'C6'...     %64
    'Db6'...    %65
    'D6'...     %66
    'Eb6'...    %67
    'E6'...     %68
    'F6'...     %69
    'Gb6'...    %70
    'G6'...     %71
    'Ab6'...    %72
    'A6'...     %73
    'Bb6'...    %74
    'B6'...     %75
    'C7'...     %76
    'Db7'...    %77
    'D7'...     %78
    'Eb7'...    %79
    'E7'...     %80
    'F7'...     %81
    'Gb7'...    %82
    'G7'...     %83
    'Ab7'...    %84
    'A7'...     %85
    'Bb7'...    %86
    'B7'...     %87
    'C8'...     %88
    };

switch lower(type)
    case 'name2number'
        % convert sharps to flats (facilitates using array index as key number)
        flats=cell(1,length(in));
        for i=1:length(flats) % loop through notes
            j=find(strcmpi(sf,in{i})); % find note in sf   
            if mod(j,2)==1 % if j is odd, note is sharp
                flats(i)=sf(j+1); % convert from sharp to flat
            else flats(i)=in(i); % natural & already-flat notes
            end
        end

        % convert notes (all flats, no sharps) to piano key numbers
        out=zeros(1,length(flats));
        for i=1:length(flats) % loop through notes
            try j=find(strcmpi(nn,flats(i))); % find note in nn
                out(i)=j; % get piano key number (array index)
            catch, disp(['**ERROR: Note ''',flats(i),''' not found.'])
            end    
        end
        
    case 'number2name'
        % convert notes (all flats, no sharps) to piano key numbers
        out=cell(1,length(in));
        for i=1:length(in) % loop through notes
            ind=in(i);
            try out{i}=nn{ind}; % get note name
            catch, disp(['**ERROR: Note ''',num2str(notenumbers(i)),''' not found.'])
            end    
        end
end
end