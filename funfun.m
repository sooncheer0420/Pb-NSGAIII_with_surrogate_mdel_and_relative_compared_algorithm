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
        minvalue=repmat(zeros(1,poplength),popnum,1);   %������Сֵ---B = repmat(A, m, n) %������A����m*n�飬��B��m*n��Aƽ�̶���
        maxvalue=repmat(ones(1,poplength),popnum,1);    %�������ֵ%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�Ƿ������ֵ��Сֵ�йأ�����
        %%%%��ʱ��ȺΪ30����ÿһ��Ϊһ������������ȡ��Ӧ�ȵ�ʱ���򽫻�������ת�ô����Խ��й�һ��
        %%%%��Сֵ�����ӷ����㣬���ֵ���˷����㣬ʹ����ֵ�޶���ȡֵ��Χ������������չһ����ֵ�������ڣ���������һ���������չЧ����Σ�
        %%%%ȡֵ��Χ��������̫�࣬��������ʹ����Ӧ�ȵĴ���ģ���ڸ߾�ȷ�ȷ�Χ��ʧ�档
        %%%%��Ȼ���ڿ���ʵ�����£�������ƾ��������ܹ���֤����ô�Ƿ���֤�˴���ģ�͵ľ����Լ��ǹ�����Լ���Ӧ�����ƱȽϰ�
        
        minvalue(:,1)=minvalue(:,1)+20;
        minvalue(:,2)=minvalue(:,2)+0.05;
        minvalue(:,3)=minvalue(:,3)+0.05;
        minvalue(:,4)=minvalue(:,4)+0.05;%fwiper
        minvalue(:,5)=minvalue(:,5);
        minvalue(:,6)=minvalue(:,6);
        minvalue(:,7)=minvalue(:,7);%gwiper
        minvalue(:,8)=minvalue(:,8)-0.25;%�����ٶȲ�
        minvalue(:,9)=minvalue(:,9);%��ʼλ��
        minvalue(:,10)=minvalue(:,10)+0.3419;%���ٶ�
        minvalue(:,11)=minvalue(:,11)+30;%�����Ƕ�

        
        maxvalue(:,1)=maxvalue(:,1).*250;
        maxvalue(:,2)=maxvalue(:,2).*0.3;
        maxvalue(:,3)=maxvalue(:,3).*0.3;
        maxvalue(:,4)=maxvalue(:,4).*0.3;%fwiper
        maxvalue(:,5)=maxvalue(:,5).*0.25;
        maxvalue(:,6)=maxvalue(:,6).*0.25;
        maxvalue(:,7)=maxvalue(:,7).*0.25;%gwiper
        maxvalue(:,8)=maxvalue(:,8).*0.25;%�����ٶȲ�
        maxvalue(:,9)=maxvalue(:,9).*75;%��ʼλ��
        maxvalue(:,10)=maxvalue(:,10).*1.0472;%���ٶ�
        maxvalue(:,11)=maxvalue(:,11).*120;%�����Ƕ�
        
        MaxValue=maxvalue;
        MinValue=minvalue;
        Boundary = [maxvalue;minvalue];
        Coding   = 'Real';
        %         Population = rand(Input,D);%%%%%%%%%%%%%%inputӦ������Ⱥ��С
        %         Population = Population.*repmat(MaxValue,Input,1)+(1-Population).*repmat(MinValue,Input,1);
        Population=rand(popnum,poplength).*(maxvalue-minvalue)+minvalue;    %�����µĳ�ʼ��Ⱥ
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
% %         cons = zeros(size(PopDec,1),1);%%%%%%%%%%%%%Լ����
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
%         cons = zeros(size(PopDec,1),1);%%%%%%%%%%%%%Լ����
%         cons_flag = 1;
        PopCon = cons;
end
%% Sample reference points on Pareto front
%P = UniformPoint(N,obj.Global.M)/2;
end