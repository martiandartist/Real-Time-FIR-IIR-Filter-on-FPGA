%% FIR Low-Pass Filter Specs
Fs = 16000;          % Sampling Frequency (Hz)
Fc = 4000;           % Cutoff Frequency (Hz)
N = 7;              % Filter order (results in N+1 taps)

% Normalize cutoff (0 to 1 scale, relative to Nyquist)
Wn = Fc / (Fs/2);

% Design FIR using Hamming window
h = fir1(N, Wn, 'low', hamming(N+1));

% Plot filter response
fvtool(h, 1);
title('Low-Pass FIR Filter Response');

%% Create Filter Object for HDL Coder
firFilt = dsp.FIRFilter('Numerator', h);

%% Generate HDL Code (Verilog or VHDL)
generatehdl(firFilt, ...
    'Name', 'LowPassFIR', ...
    'TargetLanguage', 'Verilog', ...        % Change to 'VHDL' if needed
    'GenerateHDLTestbench', true, ...
    'OptimizeForHDL', true);

