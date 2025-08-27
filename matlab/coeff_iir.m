% Parameters
Fs = 48000;             % Sampling frequency (Hz)
Fc = 5000;              % Cutoff frequency (Hz)
order = 2;              % Filter order

% Design a Butterworth low-pass filter
[b, a] = butter(order, Fc/(Fs/2));  % Normalized frequency

% Fixed-point scaling (Q1.15 format)
scalingFactor = 2^15;
b_fixed = round(b * scalingFactor);
a_fixed = round(a(2:end) * scalingFactor);  % Skip a0 (assumed to be 1)

% Create tables for export
coeffs_floating = table((0:length(b)-1)', b', [1; a(2:end)'], ...
    'VariableNames', {'Index', 'b_float', 'a_float'});
coeffs_fixed = table((0:length(b)-1)', b_fixed', [0; a_fixed'], ...
    'VariableNames', {'Index', 'b_fixed_Q15', 'a_fixed_Q15'});

% Save to Excel
filename = 'iir_coefficients.xlsx';
writetable(coeffs_floating, filename, 'Sheet', 1, 'Range', 'A1');
writetable(coeffs_fixed, filename, 'Sheet', 2, 'Range', 'A1');

disp(['Coefficients saved to ', filename]);
