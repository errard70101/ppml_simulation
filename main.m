% Load setup file

% Please modify the line below to set the correct path
path = "C:/ppml_simulation/";
setup_file_name = "setup.csv";
disp('Loading setup files...')
tic
setup = readtable(strcat(path, setup_file_name));
disp('Finish loading.')
toc

n_setup = zeros(height(setup), 1);
mean_error = cell(height(setup), 1);
RMSE = cell(height(setup), 1);
elapsed_time = zeros(height(setup), 1);
n_simulation = zeros(height(setup), 1);
n_countries = zeros(height(setup), 1);
n_year = zeros(height(setup), 1);
true_params = cell(height(setup), 1);
drop_importer_each_year = zeros(height(setup), 1);
t = table(n_setup, mean_error, RMSE, elapsed_time, n_simulation, ...
    n_countries, n_year, true_params, drop_importer_each_year);

clear n_setup mean_error RMSE elapsed_time n_simulation n_countries n_year true_params drop_importer_each_year

stop_time = zeros(size(setup, 1), 1);
for s = 1:size(setup, 1)
disp(['Running the ', num2str(s), ' set of simulation...'])
tic
    
n_simulation = setup.n_simulation(s);
n_countries = setup.n_countries(s);
n_year = setup.n_year(s);
b = str2array(setup.b(s))';
drop_importer_each_year = setup.drop_importer_each_year(s);
n_obs = (n_countries^2)*n_year;


% Generate simuation data according to setup file
disp('Generating the MR terms...')
mr_term = create_bilateral_year_mr_term(n_countries, n_year);
disp('The MR terms are generated.')

if drop_importer_each_year == 1
    % Drop importer fixed effects for every year
    mr_term(:, n_countries*n_year + 1: n_countries*n_year + n_year) = [];
else
    % Drop one importer fixed effect
    mr_term(:, n_countries*n_year + 1) = [];
end

b1 = zeros(length(b) + size(mr_term, 2), n_simulation);

progressbar(['Running simulation, setup ', num2str(s), '.'])
for n_sim = 1:n_simulation
    
    mr_term_coeff = randn(size(mr_term, 2), 1);
    e = randn(n_obs, 1);
    x = (rand(n_obs, length(b)) - 0.5) * 2;
    X = [x, mr_term];
    B = [b; mr_term_coeff];
    y = exp(X*B + e);

% Run simulation
    b1(:, n_sim) = glmfit(X, y,'poisson', 'constant', 'off');
    progressbar(n_sim/n_simulation)
end
stop_time(s) = toc;

% Producing Simulation Result
disp('Mean error')
errors = b1(1:length(b), :) - B(1:length(b));
disp(mean(errors, 2))
disp('RMSE')
disp(sqrt(mean(errors.^2, 2)))



% Saving Simulation Result
csvwrite(strcat(path, 'simulation-result-setup-', num2str(s), '.csv'), b1)

t.n_setup(s) = s;
t.mean_error(s) = {mean(errors, 2)};
t.RMSE(s) = {sqrt(mean(errors.^2, 2))};
t.elapsed_time(s) = stop_time(s);
t.n_simulation(s) = n_simulation;
t.n_countries(s) = n_countries;
t.n_year(s) = n_year;
t.true_params(s) = {b};
t.drop_importer_each_year(s) = drop_importer_each_year;

end
writetable(t, strcat(path, 'simulation-results.csv'))