function compile_extract()

% Clear workspace
clear all
close all

% Get STOPGAPHOME
[~,stopgaphome] = system('echo $STOPGAPHOME');

% Compile
mcc('-mv', '-R', 'nojvm', '-R', '-nodisplay', '-R' ,'-singleCompThread', '-R', '-nosplash', 'stopgap_extract.m', '-d', [stopgaphome(1:end-1),'/lib/'])
