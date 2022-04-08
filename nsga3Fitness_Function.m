function [PopObj]=nsga3Fitness_Function(PopDec)
%%
global PopCon

%%
[net1,ps1,ts1,angledesign,radiusdesign,thicknessdesign,diameterdesign,curnet,curps,curts]=getpopinfo;
newpopulation=PopDec;
popnum=size(PopDec,1);
yy(:,1)=diameterdesign*ones(popnum,1);%diameter
yy(:,2)=thicknessdesign*ones(popnum,1);%thickness
yy(:,3)=newpopulation(:,1);%bending radius
yy(:,4)=newpopulation(:,2);%fbending
yy(:,5)=newpopulation(:,3);%fpressure
yy(:,6)=newpopulation(:,4);%fwiper
yy(:,7)=newpopulation(:,5);%gbending
yy(:,8)=newpopulation(:,6);%gpressure
yy(:,9)=newpopulation(:,7);%gwiper
yy(:,10)=newpopulation(:,8);%pressure velocity diff
yy(:,11)=newpopulation(:,9);%pressure location
yy(:,12)=newpopulation(:,10);%arc velocity
yy(:,13)=newpopulation(:,11); %bending arc
yyy=yy';
[inputn1,~]=mapminmax('apply',yyy,ps1);




%% the fitness of springback angle

an=sim(net1,inputn1); %pretrained network for prediction

springback=mapminmax('reverse',an,ts1);
angleofbending=newpopulation(:,11);
anglenew=angleofbending-springback';
error=anglenew-angledesign*ones(popnum,1);


fitval1=abs(error);

Fitness(:,1)=fitval1;%%%%%no need for normalization cause it will be carried after NDsort

%% 曲率网络
%as paper said, the process parameter have be partly replaced by SA
xx(:,1)=diameterdesign*ones(popnum,1);
xx(:,2)=thicknessdesign*ones(popnum,1);
xx(:,3)=newpopulation(:,1);
xx(:,4)=springback;
xx(:,5)=newpopulation(:,8);
xx(:,6)=newpopulation(:,9);
xx(:,7)=newpopulation(:,10);
xx(:,8)=newpopulation(:,11);

xxx=xx';
[inputn2,~]=mapminmax('apply',xxx,curps);
predictors = cell(1,popnum);
for i = 1:popnum
    predictors{1,i}=inputn2(:,i);
    
end
YPred = predict(curnet,predictors,'MiniBatchSize',1);
for iii=1:popnum
    YPred1(:,iii) =YPred{iii,1};
end
curchange=mapminmax('reverse',YPred1,curts); 
radiusofbending=newpopulation(:,1);
curchange1=curchange';
A=curchange1;



%% third objs

Ave=mean(A,2);
radiusnew=radiusofbending+Ave;
error2=radiusnew-radiusdesign*ones(popnum,1);
fitval2=abs(error2);

S = std(A,0,2);
Fitness(:,2)=fitval2;
Fitness(:,3)=S;

%%
FunctionValue=Fitness;
PopObj = FunctionValue;

%%
cons=CalculConsValue(PopDec,PopObj);
PopCon=cons;

end
