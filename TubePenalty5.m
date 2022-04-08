function [GF1,GF2,PLM1,PLM2,PLM3]=TubePenalty5(PopObjraw)
%% 与2不同，3算法结构按照论文中展开
%% 与1不同的是，2作为外接函数，且做了一点更改
%% 首先保证回弹角度
%% 为GF新用法做的改进
%% 在4的基础上，将PLM相关内容进行了简化

%% PLM
FunctionValue=PopObjraw;
[PLM1,PLM2,PLM3]=getPLMsforGF(FunctionValue);

%%
% refvalue=min(min(PopObjraw(:,1)));%%%%所有值向第一维靠近
refvalue=PLM1;
poprow1=PopObjraw(:,1);

disrow1=(poprow1-refvalue);%%%%与第一维最小值间距
disrow1(disrow1<0)=0;
disrow1enlarge=disrow1;%%%取间距大于参考值的
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
maxrow2=max(max(PopObjraw(:,2)));
% minrow2=min(min(PopObjraw(:,2)));
minrow2=PLM2;

maxrow3=max(max(PopObjraw(:,3)));
% minrow3=min(min(PopObjraw(:,3)));
minrow3=PLM3;

minrow1=PLM1;
maxrow1=max(max(PopObjraw(:,1)));
% PopObjnew(:,3)=PopObjraw(:,3)+disrown3';

%% 在此基础上保证弯曲平均半径
% refvalue2=min(min(PopObjraw(:,2)));%%%%所有值向第二维靠近
refvalue2=PLM2;
poprow2=PopObjraw(:,2);
disrow2=(poprow2-refvalue2);%%%%与第一维最小值间距
disrow2(disrow2<0)=0;
disrow1enlarge2=disrow2;%%%取间距大于参考值的

%% 两种归一化方式
%第一种，针对作用目标
[disrown2,~]=mapminmax(disrow1enlarge',minrow2,maxrow2);%对数据进行归一化
[disrown3,~]=mapminmax(disrow1enlarge',minrow3,maxrow3);%对数据进行归一化
[disrown3_2,~]=mapminmax(disrow1enlarge2',minrow3,maxrow3);%对数据进行归一化
%第二种，针对被对比的目标进行归一化
[disrownL1,~]=mapminmax(disrow1enlarge',minrow1,maxrow1);%对数据进行归一化
[disrownL2,~]=mapminmax(disrow1enlarge',minrow2,maxrow2);%对数据进行归一化
%% 两种GF
% GF1=disrow1enlarge;
% GF2=disrow1enlarge2;

% GF1=disrown2';
% GF2=disrown3'+disrown3_2';

GF1=disrownL1';
GF2=disrownL2';
%%%%%%是否进行归一化映射有无影响捏？

%%
% %第一维修正系数
%
% %为了加快迭代，将各个值与PLM1进行做差，小于零的不进行修正，factor取0，记录坐标
% %对于factor中的记录了坐标的位置的数置零即可
% factorL1=(poprow1./PLM1I);
% factorL2=(poprow2./PLM2I);
%% 结果
% PopObjnew(:,1)=PopObjraw(:,1);
% PopObjnew(:,2)=PopObjraw(:,2)+factorL1.*disrown2';
% PopObjnew(:,3)=PopObjraw(:,3)+factorL1.*disrown3'+factorL2.*disrown3_2';
end