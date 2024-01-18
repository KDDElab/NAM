ocdata = BinaryDataset( 'shape', 'banana',... %	'banana' 或 'circle'
                        'dimensionality', 2,... % 2/3
                        'number', [30,500],... % 每一类得样本数
                        'display', 'on', ... % 数据可视化
                        'noise', 0.1,... % 噪声水平[0,1]
                        'ratio', 0.1); % 测试集比例
ocdata.generate;
%[trainData, trainLabel, testData, testLabel] = ocdata.partition;
data1  = ocdata.data;
y = ocdata.label;

% ocdata = BinaryDataset( 'shape', 'circle',...
%                         'dimensionality', 2,...
%                         'number', [100, 300],...
%                         'display', 'on', ...
%                         'noise', 0.2,...
%                         'ratio', 0.5);
% ocdata.generate;
% [trainData, trainLabel, testData, testLabel] = ocdata.partition;