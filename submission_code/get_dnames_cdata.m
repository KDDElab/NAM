clearvars -except a b res_all data_num path res_acc res_gmean;

if data_num == 1
    dname = 'breastw';% 378*30
    dnames = [path dname];
end

if data_num == 2
    dname = 'Hepatitis';% 1456*12
    dnames = [path dname];
end

if data_num == 3
    dname = 'glass';% 1456*12
    dnames = [path dname];
end

if data_num == 4
    dname = 'vertebral';% 1456*12
    dnames = [path dname];
end

if data_num == 5
    dname = 'wine';% 1456*12
    dnames = [path dname];
end

if data_num == 6
    dname = 'WBC';% 1456*12
    dnames = [path dname];
end

if data_num == 7
    dname = 'Lymphography';% 1456*12
    dnames = [path dname];
end

if data_num == 8
    dname = 'Stamps';% 1456*12
    dnames = [path dname];
end

if data_num == 9
    dname = 'Pima';% 1456*12
    dnames = [path dname];
end

if data_num == 10
    dname = 'WPBC';% 1456*12
    dnames = [path dname];
end

if data_num == 11
    dname = 'letter';% 1456*12
    dnames = [path dname];
end

if data_num == 12
    dname = 'WDBC';% 1456*12
    dnames = [path dname];
end

if data_num == 13
    dname = 'Ionosphere';% 1456*12
    dnames = [path dname];
end

if data_num == 14
    dname = 'yeast';% 1456*12
    dnames = [path dname];
end

if data_num == 15
    dname = 'vowels';% 1456*12
    dnames = [path dname];
end

if data_num == 16
    dname = 'thyroid';% 1456*12
    dnames = [path dname];
end

if data_num == 17
    dname = 'Wilt';% 1456*12
    dnames = [path dname];
end

if data_num == 18
    dname = 'satellite';% 1456*12
    dnames = [path dname];
end

if data_num == 19
    dname = 'cardio';% 1456*12
    dnames = [path dname];
end

if data_num == 20
    dname = 'Cardiotocography';% 1456*12
    dnames = [path dname];
end

if data_num == 21
    dname = 'annthyroid';% 1456*12
    dnames = [path dname];
end

if data_num == 22
    dname = 'PageBlocks';% 1456*12
    dnames = [path dname];
end

if data_num == 23
    dname = 'Waveform';% 1456*12
    dnames = [path dname];
end

if data_num == 24
    dname = 'SpamBase';% 1456*12
    dnames = [path dname];
end

if data_num == 25
    dname = 'mammography';% 1456*12
    dnames = [path dname];
end

if data_num == 26
    dname = 'satimage-2';% 1456*12
    dnames = [path dname];
end

if data_num == 27
    dname = 'InternetAds';% 1456*12
    dnames = [path dname];
end

if data_num == 28
    dname = 'fault';% 1456*12
    dnames = [path dname];
end

if data_num == 29
    dname = 'optdigits';% 1456*12
    dnames = [path dname];
end

if data_num == 30
    dname = 'shuttle';% 1456*12
    dnames = [path dname];
end

if data_num == 31
    dname = 'landsat';% 1456*12
    dnames = [path dname];
end

if data_num == 32
    dname = 'pendigits';% 1456*12
    dnames = [path dname];
end

if data_num == 33
    dname = 'smtp';% 1456*12
    dnames = [path dname];
end

if data_num == 34
    dname = 'mnist';% 1456*12
    dnames = [path dname];
end

if data_num == 35
    dname = 'musk';% 1456*12
    dnames = [path dname];
end

if data_num == 36
    dname = 'skin';% 1456*12
    dnames = [path dname];
end

if data_num == 37
    dname = 'magic.gamma';% 1456*12
    dnames = [path dname];
end

if data_num == 38
    dname = 'magic.gamma';% 1456*12
    dnames = [path dname];
end