function [mr_term, ex_y, im_y] = create_bilateral_year_mr_term(n_countries, n_year)


n_obs = (n_countries^2)*n_year;

ind = 1;
ex_y = zeros(n_obs, 1);
im_y = zeros(n_obs, 1);
for ex = 1:n_countries
    for im = 1:n_countries
        for y = 1:n_year
            ex_y(ind, 1) = ex*10^2 + y;
            im_y(ind, 1) = im*10^2 + y;
            ind = ind + 1;
        end
    end
end

mr_term = [dummyvar(ex_y), dummyvar(im_y)];

keep = sum(mr_term) > 0;
mr_term = mr_term(:, keep);

end