clear all
clc
res_all = [];
addpath('H:\5. pinball svdd\Synthetic data')
for data_num = 10
    
    get_dnames_sdata;
    dnames = [dname];
    disp('********* load data **********')
    tot_data = load([dnames '.mat']);
    
    data_only = tot_data.data;
    data_labels = tot_data.y;
    data_label = data_labels;
    
    %% cross fold 5
    count = 0;
    res.dname = [dname];
    normal_data = data_only(data_label==1,:);
    normal_data = cat(2, normal_data, ones(size(normal_data,1),1));
    outlier_data = data_only(data_label==0,:);
    outlier_data = cat(2, outlier_data, ones(size(outlier_data,1),1).*-1);
    
    [normal_num,normal_dim] = size(normal_data);
    normal_indices=crossvalind('Kfold',normal_data(1:normal_num,normal_dim),5);
    [outlier_num,outlier_dim] = size(outlier_data);
    outlier_indices=crossvalind('Kfold',outlier_data(1:outlier_num,outlier_dim),5);
    kk = 1;
    for f = 1
        test_normalind = (normal_indices==f);
        train_normalind =~ test_normalind;
        train_outlierind = (outlier_indices==f);
        test_outlierind =~ train_outlierind;
        
        test_normal = normal_data(test_normalind,:);
        train_normal = normal_data(train_normalind,:);
        test_outlier = outlier_data(test_outlierind,:);
        train_outlier = outlier_data(train_outlierind,:);
        
        disp('********* train test val **********')
        train_data = train_normal(:,1:end-1);
        train_lbls = train_normal(:,end);
        test_data = cat(1,test_normal(:,1:end-1),test_outlier(:,1:end-1));
        test_lbls = cat(1,test_normal(:,end),test_outlier(:,end));
        val_data = train_outlier(:,1:end-1);
        val_lbls = train_outlier(:,end);
        
        disp('********* begin **********')
        
        temp_ind = 0;
        t_array = 0.1;
        s_array = 0.1;
        v_array = 0.1;
        sigm_array = 0.05;
        
        tic
        count = count + 1;
        kernel = Kernel('type','gaussian','gamma',sigm_array);
        theta_value = double(rand(1,size(train_data,1)) > 0.5)';
        theta_value = theta_value.*(-1/(v_array*size(train_data,1)));
        pinballsvddParmeter = struct('nu',v_array,'tao',t_array,'svalue',s_array, 'theta', theta_value, 'kernelFunc',kernel);
        pinballsvdd = BasepinballSVDD(pinballsvddParmeter);
        pinballsvdd.train(train_data, train_lbls);
        traval_data = [train_data;val_data];
        traval_lbls = [train_lbls;val_lbls];
        val_results = pinballsvdd.test(traval_data, traval_lbls);
        test_results = pinballsvdd.test(test_data, test_lbls);
        toc
    end
    %% visualization
    svplot = SvddVisualization();
    svplot.boundary(pinballsvdd);
    svplot.distance(pinballsvdd,test_results);
    svplot.testDataWithBoundary(pinballsvdd,test_results);
end
