clc,clear
global N M D  PopCon name gen

N = 200;                        % ��Ⱥ����
M =3;                          % Ŀ�����%%%%%%%%%%%%%%%%%%%%%%%%%��Ϊ7�Ҽ���deviation����bug
name = 'tube';                 % ���Ժ���ѡ��Ŀǰֻ�У�DTLZ1��DTLZ2��DTLZ3
gen =50;                      %��������
%% Generate the reference points and random population
[Zinit,N] = UniformPoint(N,M);        % ����һ���Բο���

%%
[res,Population,PF] = funfun(); % ���ɳ�ʼ��Ⱥ��Ŀ��ֵ%%%%%%%%Ϊ�βο�����Ҫ����2��
Pop_objs = CalObj(Population); % ������Ӧ�Ⱥ���ֵ
Zmin  = min(Pop_objs(all(PopCon<=0,2),:),[],1); %������㣬��ʵPopCon�Ǵ�����Լ������ģ����ﲢû���õ�
Z=Zinit;
% t1=clock;



%% Optimization
% figure()
for i = 1:gen
    MatingPool = TournamentSelection(2,N,sum(max(0,PopCon),2));%%%%%%%%�ȶԸ����е�popcon����һ��ɸѡ��
    popconsum(i)=sum(sum(PopCon));
    Offspring  = GA(Population(MatingPool,:));
    FunctionValue = CalObj(Offspring);
    Offspring_objs=FunctionValue;


%%%�������ж��Ŀ�ֻ꣬Ҫ���ȼ���������󣬾�����Ϊ������GF��GFֻ��Իص��Ǻ���������ʰ뾶

    Zmin       = min([Zmin;Offspring_objs],[],1);
    Population = EnvironmentalSelection([Population;Offspring],N,Z,Zmin);

    Popobj = CalObj(Population);
    
%     cons=CalculConsValue(Population);
%     PopCon=cons;
%     [FrontNo,MaxFNo] = NDSort(Popobj,PopCon,2);
%     bestsolve=find(FrontNo==1);
%     popobjbest=Popobj(bestsolve,:);



[GF1,GF2,PLM1,PLM2,PLM3]=TubePenalty5(FunctionValue);
% PopCon(:,6)=GF1;
% PopCon(:,7)=GF2;
  %%%%%%%%%%%%%%% PFchange
 
    Znow=Z;
    Znew=Pbrefpoint(Popobj,Zinit,Znow,i,PLM1,PLM2,PLM3); 
    Z=Znew;
    PF=Pbrefpoint(Popobj,Zinit,Znow,i,PLM1,PLM2,PLM3); 
    %%%%%%%%%%%%%
%     plot3(Popobj(:,1),Popobj(:,2),Popobj(:,3),'ro')
%     
%     
% % %     axis([0 1 0 5])
% % %     plot3(Z(:,1),Z(:,2),Z(:,3),'g*')
%     title(num2str(i));
%     drawnow
    
%     scoreIGD(i)= IGD(Popobj,PF);
% scoreHV(i)= HV(Popobj,Z);
% scoreSpacing(i) = Spacing(Popobj);
%  scoreGD(i) = GD(Popobj,Z);
%  scoreDM(i) = DM(Popobj,Z);
    
Popobjrecord(:,:,i)=Popobj;
Zrecord(:,:,i)=Z;
i
end

% t2=clock;

% etime(t2,t1)

%       hold on
%      plot3(PF(:,1),PF(:,2),PF(:,3),'g*')
% %     plot(PF(:,1),PF(:,2),'g*')

%%IGD

% [anglenew,radiusnew,S]=finalresult(Population)
% addpath 'E:\pipe_work_file\20210929_platEMO\PlatEMO-master\PlatEMO'
% figure
% Draw(Popobj)
% Popobj(19,:)=[]
figure
    for i=1:size(Popobj,1)
        plot(Popobj(i,:))
        hold on
    end
    
   figure
    for i=1:size(Popobj,1)
        plot(Z(i,:))
        hold on
    end
    
   
    for ii=1:49
   scoreIGD(ii)= IGD(Popobjrecord(:,:,ii),Zrecord(:,:,ii));
scoreHV(ii)= HV(Popobjrecord(:,:,ii),Zrecord(:,:,ii));
scoreSpacing(ii) = Spacing(Popobjrecord(:,:,ii));
 scoreGD(ii) = GD(Popobjrecord(:,:,ii),Zrecord(:,:,ii));
 scoreDM(ii) = DM(Popobjrecord(:,:,ii),Zrecord(:,:,ii));
 ii
    end
    
    
    
    
    
    figure
plot(scoreIGD)
hold on
plot(scoreHV)
hold on
plot(scoreSpacing)
hold on
plot(scoreGD)
hold on
plot(scoreDM)
hold on
legend('scoreIGD','scoreHV','scoreSpacing','scoreGD','scoreDM')
xlabel('generate'),ylabel('value'),title('score')
% set(0,'defaultfigurecolor','w')
set(gca,'fontsize',12)

 
%      filename = 'PbNSGAIII0111001.mat';
%  save(filename)
scoreIGD(ii)
scoreHV(ii)
scoreSpacing(ii)
scoreGD(ii)
scoreDM(ii)

 save('E:\pipe_work_file\20220110_Unpacking\contrast\data\PbNSGAIIIL1L20114002.mat')
%  time=etime(t2,t1)