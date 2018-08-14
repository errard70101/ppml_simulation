% Load setup file

path = "C:/ppml_simulation/";
setup_file_name = "setup.csv";
disp('Loading setup files...')
tic
setup = readtable(strcat(path, setup_file_name));
disp('Finish loading.')
toc

n_setup = zeros(2, 1);
mean_error = cell(2, 1);
RMSE = cell(2, 1);
t = table(n_setup, mean_error, RMSE);

stop_time = zeros(size(setup, 1), 1);
for s = 1:size(setup, 1)
disp(['Running the ', num2str(s), ' set of simulation...'])
tic
    
n_simulation = setup.n_simulation(s);
n_countries = setup.n_countries(s);
n_year = setup.n_year(s);
b = str2array(setup.b(s))';
n_obs = (n_countries^2)*n_year;


% Generate simuation data according to setup file
mr_term = create_bilateral_year_mr_term(n_countries, n_year);

% Drop one importer fixed effect for every year
mr_term = mr_term(:, n_countries*n_year + 1: n_countries*n_year + n_countries);

b1 = zeros(length(b) + size(mr_term, 2), n_simulation);
for n_sim = 1:n_simulation
    
    mr_term_coeff = randn(size(mr_term, 2), 1);
    e = randn(n_obs, 1);
    x = (rand(n_obs, length(b)) - 0.5) * 2;
    X = [x, mr_term];
    B = [b; mr_term_coeff];
    y = exp(X*B + e);

% Run simulation
    b1(:, n_sim) = glmfit(X, y,'poisson', 'constant', 'off');
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
t.true_parms(s) = b;

end
writetable(t, strcat(path, 'simulation-results.csv'))