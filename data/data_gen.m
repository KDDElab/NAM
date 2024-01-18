% data=cell(1,3);
% data{1,1} = X(:,1:10);
% data{1,2} = X(:,11:20);
% data{1,3} = X(:,21:30);

a1 = find(Y==3); % normal
a2 = find(Y==1); % abnormal
a = [a1;a2];

data=cell(1,3);
for i =1:3
    data{1,i} = X{1,i}(a,:);
end
y = ones(length(a),1);
y(a2,1)=-1;