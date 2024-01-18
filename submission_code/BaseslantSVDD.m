classdef BasepinballSVDD < handle & matlab.mixin.Copyable
    properties
        data
        label
        nu = 0.1
        tao = 0.1
        svalue = 0.1
        theta
        newtheta
        kernelFunc = Kernel('type', 'gaussian', 'gamma', 0.5)
        supportVectors
        supportVectorIndices
        numSupportVectors
        numIterations
        alpha
        alphaTolerance = 1e-3
        supportVectorAlpha
        radius
        offset
        dis
        distance
        predictedLabel
        runningTime
        boundary
        boundaryHandle
        display = 'on'
        optimization
        dimReduction
        crossValidation
        dataWeight
        performance
        evaluationMode = 'test'
    end   
    
    properties (Dependent)
        dataType
        numSamples
        numFeatures
        numPositiveSamples
        numNegativeSamples
    end
    
    methods
        %% create ab object of pinballsvdd
        function obj = BasepinballSVDD(parameter)
            pinballsvddOption.setParameter(obj, parameter);
        end
        
        %% train pinballsvdd model
        function varargout = train(obj,varargin)
            tStart = tic;
            input_ = varargin;
            pinballsvddOption.checkInputForTrain(obj, input_);
            
            %% parameter optimization
            if strcmp(obj.optimization.switch, 'on')
                pinballsvddOptimization.getModel(obj);
            else
                getModel(obj);
            end
            
            %% model evaluation
            display_ = obj.display;
            evaluationMode_ = obj.evaluationMode;
            obj.display = 'off';
            obj.evaluationMode = 'train';
            results_ = test(obj, obj.data, obj.label);
            obj.display = display_;
            obj.evaluationMode = evaluationMode_;
            obj.performance = evaluateModel(obj, results_);
            obj.distance = results_.distance;
            obj.predictedLabel = results_.predictedLabel;
            
            %% cross validation
            if strcmp(obj.crossValidation.switch, 'on')
                svdd_ = copy(obj);
                obj.crossValidation.accuracy = SvddOptimization.crossvalFunc(svdd_);
            end
            obj.runningTime = toc(tStart); 
            %% display
            if strcmp(obj.display, 'on')
                pinballsvddOption.displayTrain(obj);
            end
            %% output
            if nargout == 1
                varargout{1} = obj;
            end
        end
        
        function getModel(obj)
            K = obj.kernelFunc.computeMatrix(obj.data, obj.data);
            k = 1;
            while k<50
                solveModel(obj, K);
                new_theta = zeros(obj.numSamples,1);
                theta_index = find(obj.dis>obj.svalue+obj.radius^2);
                if isempty(theta_index)
                    obj.newtheta = new_theta;
                else
                    new_theta(theta_index) = -1/(obj.nu*obj.numSamples);
                    obj.newtheta = new_theta;
                end
                if obj.newtheta==obj.theta
                    break
                else
                    obj.theta = new_theta;
                    solveModel(obj, K);
                end
                k = k+1;
            end
        end
        
        function results = test(obj, varargin)
            tStart = tic; 
            input_ = varargin;
            results = pinballsvddOption.checkInputForTest(input_);
            if strcmp(obj.dimReduction.switch, 'on') && strcmp(obj.evaluationMode, 'test')
                results.data = (results.data-obj.dimReduction.pcaMu)*obj.dimReduction.pcaCoeff;
            end
            results.radius = obj.radius;
            [results.numSamples, results.numFeatures] = size(results.data);
            K = obj.kernelFunc.computeMatrix(results.data, obj.data);
            K_ = obj.kernelFunc.computeMatrix(results.data, results.data);
            tmp_ = -2*sum((ones(results.numSamples, 1)*((obj.nu*obj.tao).*(obj.alpha-obj.theta))').*K, 2);
            results.distance = sqrt(diag(K_)+tmp_+obj.offset);
            results.predictedLabel = ones(results.numSamples, 1);
            results.predictedLabel(results.distance > obj.radius, 1) = -1;
            results.numAlarm = sum(results.predictedLabel == -1, 1);
            if strcmp(results.labelType, 'true')
                results.numPositiveSamples = sum(results.label == 1, 1);
                results.numNegativeSamples = sum(results.label == -1, 1);
                results.performance = evaluateModel(obj, results);
            end
            results.runningTime = toc(tStart); 
            % display
            if strcmp(obj.display, 'on')
                pinballsvddOption.displayTest(results);
            end
        end
        
        function solveModel(obj, K)
            % Coefficient of Quadratic optimization
            % H: Symmetric Hessian matrix
            numSamples_ = size(K, 1);
            H = obj.label*obj.label'.*K;
            H = H+H';
            f = -obj.label.*diag(K);
            % Lower and upper bounds
            lb = zeros(numSamples_, 1);
            ub = ones(numSamples_, 1);
            switch obj.dataType
                case 'single'
                    if strcmp(obj.dataWeight.switch, 'on')
                        lb(obj.label==1, 1) = obj.theta + obj.tao/(obj.nu*numSamples_)*obj.dataWeight.param(obj.label==1, 1);
                        ub(obj.label==1, 1) = obj.theta + 1/(obj.nu*numSamples_)*obj.dataWeight.param(obj.label==1, 1);
%                         lb(obj.label==1, 1) = -obj.tao/(obj.nu*numSamples_)*obj.dataWeight.param(obj.label==1, 1);
%                         ub(obj.label==1, 1) = 1/(obj.nu*numSamples_)*obj.dataWeight.param(obj.label==1, 1);
                    else
                        lb(obj.label==1, 1) = obj.theta + obj.tao/(obj.nu*numSamples_);
                        ub(obj.label==1, 1) = obj.theta + 1/(obj.nu*numSamples_);
%                         lb(obj.label==1, 1) = -obj.tao/(obj.nu*numSamples_);
%                         ub(obj.label==1, 1) = 1/(obj.nu*numSamples_);

                    end
                    %% 
%                 case 'hybrid'
%                     if strcmp(obj.dataWeight.switch, 'on')
%                         ub(obj.label==1, 1) = obj.cost(1, 1)*obj.dataWeight.param(obj.label==1, 1);
%                         ub(obj.label==2, 1) = obj.cost(1, 2)*obj.dataWeight.param(obj.label==2, 1);
%                     else
%                         ub(obj.label==1, 1) = obj.cost(1, 1);
%                         ub(obj.label==2, 1) = obj.cost(1, 2);
%                     end
            end
            % Linear Equality Constraint
            Aeq = obj.label';
            beq = 1 + obj.tao/obj.nu;
            % Quadratic optimize
            opt = optimset('quadprog');
            opt.Algorithm = 'interior-point-convex';
%             opt.Algorithm = 'active-set';
            opt.Display = 'off';
            [obj.alpha, ~, ~, output, ~] = quadprog(H, f, [], [], Aeq, beq, lb, ub, [], opt);
            if (isempty(obj.alpha))
                warning('No solution for the SVDD model could be found.');
                obj.alpha = zeros(obj.numSamples, 1);
                obj.alpha(1, 1) = obj.nu/obj.tao;
            end
            %obj.alpha = (obj.nu/obj.tao).*obj.label.*(obj.alpha-ones(numSamples_,1).*obj.tao/(obj.nu*numSamples_));
            obj.alpha = obj.label.*obj.alpha;
            obj.numIterations = output.iterations;
            %obj.supportVectorIndices = find(abs(obj.alpha) > obj.alphaTolerance);
            obj.supportVectorIndices = find(abs(obj.alpha-lb)>obj.alphaTolerance);
            obj.boundary = obj.supportVectorIndices(find((obj.alpha(obj.supportVectorIndices) < ...
                ub(obj.supportVectorIndices))&(obj.alpha(obj.supportVectorIndices) > obj.alphaTolerance)));
            if (size(obj.boundary, 1) < 1)
                obj.boundary = obj.supportVectorIndices;
            end
            %obj.alpha(find(abs(obj.alpha) < obj.alphaTolerance)) = 0;
            obj.alpha(find(abs(obj.alpha-lb)<obj.alphaTolerance)) = obj.theta(find(abs(obj.alpha-lb)<obj.alphaTolerance)) + obj.tao/(obj.nu*numSamples_);
            obj.supportVectors = obj.data(obj.supportVectorIndices, :);
            obj.supportVectorAlpha = obj.alpha(obj.supportVectorIndices);
            obj.numSupportVectors = size(obj.supportVectorIndices, 1);
            tmp_ = -2*sum((ones(numSamples_, 1)*((obj.nu*obj.tao).*(obj.alpha-obj.theta))').*K, 2);
            obj.offset = sum(sum(((obj.nu*obj.tao).*(obj.alpha-obj.theta)*((obj.nu*obj.tao).*(obj.alpha-obj.theta))').*K));
            obj.radius = sqrt(mean(diag(K))+obj.offset+mean(tmp_(obj.boundary, :)));
            obj.dis = sqrt(diag(K)+tmp_+obj.offset);
        end
        
        function performance = evaluateModel(~, results)
            performance.accuracy = sum(results.predictedLabel == results.label)/results.numSamples;
            [~, dis_index] = sort(results.distance, 'ascend');
            label_ = results.label(dis_index);
            %scores = mapminmax(results.distance);
            P=[1:length(label_)]';
            if strcmp(results.dataType, 'hybrid')
                order_ = [1, -1];
                M = confusionmat(results.label',results.predictedLabel', 'order', order_);
                TP = M(1, 1);
                FP = M(2, 1);
                FN = M(1, 2);
                TN = M(2, 2);
                performance.FPR = cumsum(label_ == -1, 1)/results.numNegativeSamples;
                performance.TPR = cumsum(label_ == 1, 1)/results.numPositiveSamples;
                performance.A = cumsum(label_ == 1,1)./P;
                performance.AUC = trapz(performance.FPR, performance.TPR);
                performance.aupr = sum((performance.TPR(2:length(label_))-performance.TPR(1:length(label_)-1)).*performance.A(2:length(label_)));
                %performance.aupr = trapz(performance.A, performance.TPR);
                %performance.aupr = pr_curve(scores, label_);
                performance.errorRate = (FP+FN)/(results.numSamples);
                performance.sensitive = TP/results.numPositiveSamples;
                performance.specificity = TN/results.numNegativeSamples;
                performance.precision = TP/(TP+FP);
                performance.recall = TP/results.numPositiveSamples;
                performance.F1score = 2*performance.precision*performance.recall/(performance.precision+performance.recall);
                performance.gmean = sqrt(performance.sensitive*performance.specificity);               
            end
        end
         function numSamples = get.numSamples(obj)
            numSamples= size(obj.data, 1);
        end
        
        function numFeatures = get.numFeatures(obj)
            numFeatures= size(obj.data, 2);
        end
        
        function numPositiveSamples = get.numPositiveSamples(obj)
            numPositiveSamples = sum(obj.label == 1, 1);
        end
        
        function numNegativeSamples = get.numNegativeSamples(obj)
            numNegativeSamples = sum(obj.label == -1, 1);
        end
        
        function dataType = get.dataType(obj)
            tmp_ = unique(obj.label);
            switch length(tmp_)
                case 1
                    dataType = 'single';
                    if ~isequal(unique(obj.label), 1) && ~isequal(unique(obj.label), -1)
                        error('The label must be 1 (positive sample) or 2 (negative sample)')
                    end
                case 2
                    dataType = 'hybrid';
                    if ~isequal(unique(obj.label), [1; -1]) && ~isequal(unique(obj.label), [-1; 1])
                        error('The label must be 1 (positive sample) or 2 (negative sample)')
                    end
                otherwise
                    dataType = 'others';
            end
        end
    end     
end