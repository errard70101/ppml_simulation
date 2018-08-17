% Please modify the line below to set the correct path
path = "C:/ppml_simulation/";
result_file_name = "simulation-result-setup-1-2018-08-14-2.csv";
disp('Loading result files...')
tic
result = csvread(strcat(path, result_file_name));
disp('Finish loading.')
toc

b = [1; -1];
% Producing Simulation Result
disp('Mean error')
errors = result(1:length(b), :) - b;
disp(mean(errors, 2))
disp('RMSE')
disp(sqrt(mean(errors.^2, 2)))