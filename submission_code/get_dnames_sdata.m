clearvars -except a b res_all data_num path res_acc res_gmean;

if data_num == 1
    dname = 'banana0.1';% 378*30
    dnames = [path dname];
end

if data_num == 2
    dname = 'banana0.3';% 1456*12
    dnames = [path dname];
end

if data_num == 3
    dname = 'banana0.5';%148*18
    dnames = [path dname];
end

if data_num == 4
    dname = 'banana0.7';% 683*9
    dnames = [path dname];
end

if data_num == 5
    dname = 'banana0.9';% 5216*64
    dnames = [path dname];
end

if data_num == 6
    dname = 'circle0.1';% 297*13
    dnames = [path dname];
end

if data_num == 7
    dname = 'circle0.3';% 129*13
    dnames = [path dname];
end

if data_num == 8
    dname = 'circle0.5';% 240*6
    dnames = [path dname];
end

if data_num == 9
    dname = 'circle0.7';% 214*9
    dnames = [path dname];
end

if data_num == 10
    dname = 'circle0.9';% 6870*16
    dnames = [path dname];
end
