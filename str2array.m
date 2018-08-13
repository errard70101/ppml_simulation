function array = str2array(string)
string = cell2mat(string);
array = [];

loc = 1;
num = '';
for i = 1:length(string)
    if string(i) == ',' || string(i) == ']'
        array(loc) = str2double(num);
        loc = loc + 1;
        num = '';
    elseif string(i) ~= '['
        num = strcat(num, string(i));
    end
end