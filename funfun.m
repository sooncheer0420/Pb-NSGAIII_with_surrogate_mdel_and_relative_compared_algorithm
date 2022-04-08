function [PopObj,PopDec,P] =  funfun()

global M D lower upper encoding N PopCon cons cons_flag name N1

%% Initialization
switch name
    case {'DTLZ1','DTLZ2','DTLZ3'}
        D = M + 4;
        lower    = zeros(1,D);
        upper    = ones(1,D);
        encoding = 'real';
        switch encoding
            case 'binary'
                PopDec = randi([0,1],N,D);
            case 'permutation'
                [~,PopDec] = sort(rand(N,D),2);
            otherwise
                PopDec = unifrnd(repmat(lower,N,1),repmat(upper,N,1));
        end
        cons = zeros(size(PopDec,1),1);
        cons_flag = 1;
        PopCon = cons;
        
    case 'tube'
        D=11;
        poplength=D;
        popnum=N;
        minvalue=repmat(zeros(1,poplength),popnum,1);   %个体最小值---B = repmat(A, m, n) %将矩阵A复制m*n块，即B由m*n块A平铺而成
        maxvalue=repmat(ones(1,poplength),popnum,1);    %个体最大值%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%是否与最大值最小值有关？？？
        %%%%此时种群为30，且每一行为一个样本。在求取适应度的时候则将会对其进行转置处理以进行归一化
        %%%%最小值均做加法运算，最大值做乘法运算，使其最值限定在取值范围内且向两侧拓展一定数值的区域内（后期试验一下如果不拓展效果如何）
        %%%%取值范围不宜外推太多，否则容易使得适应度的代理模型在高精确度范围外失真。
        %%%%当然后期可以实验以下，如果外推精度依旧能够保证，那么是否验证了代理模型的精度以及非过拟合以及反应的趋势比较棒
        
        minvalue(:,1)=minvalue(:,1)+20;
        minvalue(:,2)=minvalue(:,2)+0.05;
        minvalue(:,3)=minvalue(:,3)+0.05;
        minvalue(:,4)=minvalue(:,4)+0.05;%fwiper
        minvalue(:,5)=minvalue(:,5);
        minvalue(:,6)=minvalue(:,6);
        minvalue(:,7)=minvalue(:,7);%gwiper
        minvalue(:,8)=minvalue(:,8)-0.25;%助推速度差
        minvalue(:,9)=minvalue(:,9);%初始位置
        minvalue(:,10)=minvalue(:,10)+0.3419;%角速度
        minvalue(:,11)=minvalue(:,11)+30;%弯曲角度

        
        maxvalue(:,1)=maxvalue(:,1).*250;
        maxvalue(:,2)=maxvalue(:,2).*0.3;
        maxvalue(:,3)=maxvalue(:,3).*0.3;
        maxvalue(:,4)=maxvalue(:,4).*0.3;%fwiper
        maxvalue(:,5)=maxvalue(:,5).*0.25;
        maxvalue(:,6)=maxvalue(:,6).*0.25;
        maxvalue(:,7)=maxvalue(:,7).*0.25;%gwiper
        maxvalue(:,8)=maxvalue(:,8).*0.25;%助推速度差
        maxvalue(:,9)=maxvalue(:,9).*75;%初始位置
        maxvalue(:,10)=maxvalue(:,10).*1.0472;%角速度
        maxvalue(:,11)=maxvalue(:,11).*120;%弯曲角度
        
        MaxValue=maxvalue;
        MinValue=minvalue;
        Boundary = [maxvalue;minvalue];
        Coding   = 'Real';
        %         Population = rand(Input,D);%%%%%%%%%%%%%%input应该是种群大小
        %         Population = Population.*repmat(MaxValue,Input,1)+(1-Population).*repmat(MinValue,Input,1);
        Population=rand(popnum,poplength).*(maxvalue-minvalue)+minvalue;    %产生新的初始种群
        Output   = Population;
        
        PopDec=Population;
        P = UniformPoint(N,M);
        
        %% refpoints
%         P = UniformPoint(N,M)/0.5;
% % P = P./repmat(sqrt(sum(P.^2,2)),1,M);
%         P(:,1)=0;
        
        %%
%         
%         cons=CalculConsValue(PopDec);
% %         cons = zeros(size(PopDec,1),1);%%%%%%%%%%%%%约束？
% %         cons_flag = 1;
%         PopCon = cons;
        encoding = 'real';
        lower    = minvalue(1,:);
        upper    = maxvalue(1,:);
end
%% Calculate objective values
switch name
    case 'DTLZ1'
        g      = 100*(D-M+1+sum((PopDec(:,M:end)-0.5).^2-cos(20.*pi.*(PopDec(:,M:end)-0.5)),2));
        PopObj = 0.5*repmat(1+g,1,M).*fliplr(cumprod([ones(N,1),PopDec(:,1:M-1)],2)).*[ones(N,1),1-PopDec(:,M-1:-1:1)];
        P = UniformPoint(N,M)/2;
    case 'DTLZ2'
        g      = sum((PopDec(:,M:end)-0.5).^2,2);
        PopObj = repmat(1+g,1,M).*fliplr(cumprod([ones(size(g,1),1),cos(PopDec(:,1:M-1)*pi/2)],2)).*[ones(size(g,1),1),sin(PopDec(:,M-1:-1:1)*pi/2)];
        P = UniformPoint(N,M);
        P = P./repmat(sqrt(sum(P.^2,2)),1,M);
    case 'DTLZ3'
        g      = 100*(D-M+1+sum((PopDec(:,M:end)-0.5).^2-cos(20.*pi.*(PopDec(:,M:end)-0.5)),2));
        PopObj = repmat(1+g,1,M).*fliplr(cumprod([ones(N,1),cos(PopDec(:,1:M-1)*pi/2)],2)).*[ones(N,1),sin(PopDec(:,M-1:-1:1)*pi/2)];
        P = UniformPoint(N,M);
        P = P./repmat(sqrt(sum(P.^2,2)),1,M);
        
        
        cons=CalculConsValuefortest(PopObj);
        PopCon = cons;
        
        
        
        
    case 'tube'
        %%
        [PopObj]=nsga3Fitness_Function(PopDec);  
                cons=CalculConsValue(PopDec,PopObj);
%         cons = zeros(size(PopDec,1),1);%%%%%%%%%%%%%约束？
%         cons_flag = 1;
        PopCon = cons;
end
%% Sample reference points on Pareto front
%P = UniformPoint(N,obj.Global.M)/2;
end