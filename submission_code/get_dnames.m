clearvars -except a b res_all data_num path res_acc res_gmean;

if data_num == 1
    dname = 'wbc';% 378*30
    dnames = [path dname];
end

if data_num == 2
    dname = 'vowels';% 1456*12
    dnames = [path dname];
end

if data_num == 3
    dname = 'lympho';%148*18
    dnames = [path dname];
end

if data_num == 4
    dname = 'breastw';% 683*9
    dnames = [path dname];
end

if data_num == 5
    dname = 'optdigits';% 5216*64
    dnames = [path dname];
end

if data_num == 6
    dname = 'heart';% 297*13
    dnames = [path dname];
end

if data_num == 7
    dname = 'wine';% 129*13
    dnames = [path dname];
end

if data_num == 8
    dname = 'vertebral';% 240*6
    dnames = [path dname];
end

if data_num == 9
    dname = 'glass';% 214*9
    dnames = [path dname];
end

if data_num == 10
    dname = 'pendigits';% 6870*16
    dnames = [path dname];
end

if data_num == 11
    dname = 'musk';%3062*166
    dnames = [path dname];
end

if data_num == 12
    dname = 'mnist';%7603*100
    dnames = [path dname];
end

if data_num == 13
    dname = 'pima';% 768*8
    dnames = [path dname];
end

if data_num == 13
    dname = 'letter';%1600*32
    dnames = [path dname];
end

if data_num == 14
    dname = 'thyroid';% 3772*6
    dnames = [path dname];
end

if data_num == 15
    dname = 'ionosphere';%351*33
    dnames = [path dname];
end

if data_num == 16
    dname = 'cardio';% 1831*21
    dnames = [path dname];
end

if data_num == 17
    dname = 'arrhythmia';% 452*274
    dnames = [path dname];
end

if data_num == 22
    dname = 'satimage-2'; % 5803*36
    dnames = [path dname];
end

if data_num == 21
    dname = 'satellite'; % 6435*36
    dnames = [path dname];
end

if data_num == 19
    dname = 'annthyroid'; % 7200*6
    dnames = [path dname];
end

if data_num == 20
    dname = 'mammography'; % 11183*6
    dnames = [path dname];
end

if data_num == 18
    dname = 'speech'; % 3686*400
    dnames = [path dname];
end