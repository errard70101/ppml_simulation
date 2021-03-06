% Please modify the line below to set the correct path

path = "/Users/errard/Dropbox/GitHub/ppml_simulation/results/";
result_file_name = "sim-result-100-countries-10-years-drop-10-importer-";
disp('Loading result files...')

tic
result = csvread(strcat(path, result_file_name, num2str(1), '.csv'));
for i = 2:5
    result = [result, csvread(strcat(path, result_file_name, num2str(i), '.csv'))];
end
disp('Finish loading.')
toc

b = [1; -1];
% Producing Simulation Result
disp('Mean error')
errors = result(1:length(b), :) - b;
disp(mean(errors, 2))
disp('RMSE')
disp(sqrt(mean(errors.^2, 2)))