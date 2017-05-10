function tone=maketone(varargin)
%MAKETONE  Creates a simple pure tone or a complex tone.
%
%   TONE=MAKETONE returns a tone made with default parameters.
%
%   TONE=MAKETONE(FREQS) returns a tone made with the specified
%   frequencies.
%
%   TONE=MAKETONE(FREQS,'Parameter1',Value1,...) OR
%   TONE=MAKETONE('Parameter1',Value1,...) specifies any of the
%   following parameters:
%
%       'freqs'     =   Frequencies to include in tone. Default 440 Hz.
%                       If multiple frequencies are entered, pure tones are
%                       added together.
%
%       'vols'      =   Relative volume of each frequency as a proportion
%                       between 0 and 1. Must be a vector the same size as
%                       'freqs'. Default is a vector of 1's the same length
%                       as 'freqs'.
%
%       'Fs'        =   Sampling frequency. Default 20000 Hz.
%
%       'duration'  =   Length of the tone. Default 1 second.
%
%       'volume'    =   Total volume of the tone as a proportion between 0
%                       and 1. Default 0.9 (entering 1 may cause distortion
%                       products to appear.
%
%       'wintype'   =   Type of volume envelope to apply. Enter 'hanning'
%                       (default), 'linear', or 'none'.
%
%       'onramp'    =   Use in combination with 'linear' WINTYPE to specify
%                       the length of tone onset. Default 0.1 seconds.
%
%       'offramp'   =   Same as 'onramp' but for tone offset. Default is
%                       the value of 'onramp'.
%
%       'inverted'  =   Enter 1 to make an inverted version of the tone
%                       (i.e. multiply by -1). Default 0 (non-inverted).
%
%       'dualmono'  =   Enter 1 to create two channels of the same tone
%                       instead of one. Useful when creating stereo wav
%                       files. Default 0 (mono).
%
%       'wavfile'   =   Enter 1 to save tone as a .wav file. Default 0.
%
%       'filename'  =   Filename of the outputted .wav file. Default is
%                       of the form: tone-440Hz-1000ms-9vol-20000Fs-inv.wav
%                       
%       'bits'      =   Bit rate of .wav file. Default 16.
%
% Written by Gabe Nespoli 2012-12-14. Revised 2014-03-19.

if mod(nargin,2)==1, freqs=varargin{1}; 
    if nargin>2, varargin=varargin(2:end); end
else freqs=440; % default freq
end

% defaults
vols=[]; % volume of harmonics (between 0 and 1)
Fs=20000; % in Hz
duration=1; % in seconds
volume=0.9; % proportion between 0 and 1
wintype='hanning'; % 'hanning', 'linear', 'none'
onRamp=0.1; % in seconds
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
    
% user-defined
if nargin>1
    for i=1:2:length(varargin)
        switch varargin{i}
            case 'freqs',       f0=varargin{i+1};
            case 'vols',        vols=varargin{i+1};
            case 'Fs',          Fs=varargin{i+1};
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

if isempty(vols), vols=ones(size(freqs)); end

% make tone
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

if writeaudiofile
    if isempty(sFilename) % create filename
        sFilename='tone';
        if sFreq,       sFilename=[sFilename,'_',num2str(f0),'Hz']; end
        if sDuration,   sFilename=[sFilename,'_',num2str(duration*1000),'ms']; end
        if sVolume,     sFilename=[sFilename,'_',num2str(volume*10),'vol']; end
        if sFs,         sFilename=[sFilename,'_',num2str(Fs),'Fs']; end
        if inverted,    sFilename=[sFilename,'_','inv']; end
    end
    
    % write audio file
    if strcmp(sFilename(end-3:end),'.wav')==0,sFilename=[sFilename,'.wav'];end
    audiowrite(sFilename,tone,Fs,'BitsPerSample',nBits)
end