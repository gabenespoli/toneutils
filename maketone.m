%MAKETONE  Creates a simple pure tone or a complex tone.
%
% usage:
%   tone = maketone
%   tone = maketone(freqs)
%   tone = maketone(freqs,'key1',val1,...)
%   tone = maketone('key1',val1,...)
%
% input:
%   'freqs' = [numeric] Frequencies to include in tone. Default 440 Hz.
%       If multiple frequencies are entered, pure tones are added together.
%
%   'vols' = [numeric] Relative volume of each frequency as a proportion
%       between 0 and 1. Must be a vector the same size as 'freqs'. Default
%       is a vector of 1's the same length as 'freqs'.
%
%   'Fs' = [numeric in Hz] Sampling frequency. Default 20000 Hz.
%
%   'duration' = [numeric in seconds] Length of the tone. Default 1 second.
%
%   'volume' = [numeric between 0 and 1] Total volume of the tone as a 
%       proportion between 0 and 1. Default 0.9 (entering 1 may cause 
%       distortion. Can also be a vector the same length as 'freqs'.
%
%   'wintype' = [string] Type of volume envelope to apply. Enter 'hanning'
%       (default), 'linear', or 'none'.
%
%   'onramp' = [numeric] Use in combination with 'linear' WINTYPE to specify
%       the length of tone onset. In seconds. Default 0.
%
%   'offramp' = [numeric] Same as 'onramp' but for tone offset. Default is
%       the value of 'onramp'.
%
%   'inverted' = [boolean] Enter 1 to make an inverted version of the tone
%       (i.e. multiply by -1). Default 0 (non-inverted).
%
%   'dualmono' = [boolean] Enter 1 to create two channels of the same tone
%       instead of one. Useful when creating stereo wav files. 
%       Default 0 (mono).
%
%   'wavfile' = [boolean] Enter 1 to save tone as a .wav file. Default 0.
%
%   'filename' = [string] Filename of the outputted .wav file. Default is
%       of the form: tone-440Hz-1000ms-9vol-20000Fs-inv.wav
%                       
%   'bits' = [numeric] Bit rate of .wav file. Default 16.
%
% output:
%   tone = [numeric] A 1-by-n or 2-by-n vector of the tone.
%
%   <filename> = [.wav file] An audio file of the tone.
%
% Written by Gabriel A. Nespoli (gabenespoli@gmail.com).

function tone = maketone(varargin)

if mod(nargin,2)==1, freqs=varargin{1}; 
    if nargin>2, varargin=varargin(2:end); end
else freqs=440; % default freq
end

%% defaults
vols=[]; % volume of harmonics (between 0 and 1)
Fs=20000; % in Hz
duration=1; % in seconds
volume=0.9; % proportion between 0 and 1
wintype='hanning'; % 'hanning', 'linear', 'none'
onRamp=0; % in seconds
offRamp=onRamp;

inverted=0;
dualmono=0;

writeaudiofile=0;
    sFilename=[];
    nBits=16; % bits per sample for output wav file
    sFreq=1; % parameters to include in filename (1 or [])
    sDuration=1;
    sVolume=1;
    sFs=1;
    
%% user-defined
if nargin>1
    for i=1:2:length(varargin)
        if ~isempty(varargin{i+1});
            switch lower(varargin{i})
                case 'freqs',       freqs=varargin{i+1};
                case 'vols',        vols=varargin{i+1};
                case 'fs',          Fs=varargin{i+1};
                case 'duration',    duration=varargin{i+1};
                case 'volume',      volume=varargin{i+1};
                case 'wintype',     wintype=varargin{i+1};
                case 'onramp',      onRamp=varargin{i+1};
                case 'offramp',     offRamp=varargin{i+1};
                case 'inverted',    inverted=varargin{i+1};
                case 'dualmono',    dualmono=varargin{i+1};
                case {'wavfile','wavefile'},    writeaudiofile=varargin{i+1};
                case 'bits',        nBits=varargin{i+1};
                case 'filename',    sFilename=varargin{i+1};
            end
        end
    end
end

%% check args
if isempty(vols), vols=ones(size(freqs)); end

%% make tone
t=0:1/Fs:(duration-1/Fs);
tone=0;
for i=1:length(freqs)
    tone=tone+vols(i)*sin(2*pi*freqs(i)*t);
end

% normalize to between 0 and 1, and adjust volume
if abs(max(tone))>=abs(min(tone))
    tone=tone/abs(max(tone));
else tone=tone/abs(min(tone));
end
tone=tone*volume;

% make first dimension time
tone=shiftdim(tone);

% Apply onset/offset volume ramps
switch lower(wintype)
    case 'none'
    case 'linear'
        for i=1:onRamp*Fs
            tone(i)=tone(i)*((i-1)/(onRamp*Fs));
        end
        for i=1:offRamp*Fs
            tone(end-i+1)=tone(end-i+1)*((i-1)/(offRamp*Fs));
        end
        
    case 'hanning'
        window=hann(length(tone));
        tone=tone.*window;
end

if inverted, tone=-tone; end
if dualmono, tone=[tone'; tone']; end

%% save audio file to disk
if writeaudiofile
    if isempty(sFilename) % create filename
        sFilename='tone';
        if sFreq,       sFilename=[sFilename,'_',num2str(freqs(1)),'Hz']; end
        if sDuration,   sFilename=[sFilename,'_',num2str(duration*1000),'ms']; end
        if sVolume,     sFilename=[sFilename,'_',num2str(volume*10),'vol']; end
        if sFs,         sFilename=[sFilename,'_',num2str(Fs),'Fs']; end
        if inverted,    sFilename=[sFilename,'_','inv']; end
    end
    
    % write audio file
    if strcmp(sFilename(end-3:end),'.wav')==0,sFilename=[sFilename,'.wav'];end
    audiowrite(sFilename,tone,Fs,'BitsPerSample',nBits)
end
