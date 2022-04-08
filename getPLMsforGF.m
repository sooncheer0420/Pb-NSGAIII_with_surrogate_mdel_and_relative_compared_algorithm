function [PLM1,PLM2,PLM3]=getPLMsforGF(PopObjraw)
%% 首先提取PLM1
L1=PopObjraw(:,1);
L2=PopObjraw(:,2);
L3=PopObjraw(:,3);
% a=[12 45 67 78 32 8 19];[Y,I]=sort(a)
[L1sorted,L1inline]=sort(L1);
PLM1size=round(size(L1sorted,1)/2);
PLM1take=L1sorted(1:PLM1size);
PLM1=mean(PLM1take);
PLMA1=L1sorted(1);%%%%%%

% L2=PopObjraw(:,2);
% [L2sorted,L2inline]=sort(L2);
% PLM2size=round(size(L2sorted,1)/15);
% PLM2take=L2sorted(1:PLM2size);
% PLM2=mean(PLM2take);
% PLMA2=L2sorted(1);%%%%%%
L2element=L2(L1inline(1:2*PLM1size));%%%%%参与PLM2的初始元素
[L2sorted,L2inline]=sort(L2element);
PLM2size=round(size(L2sorted,1)/2);
PLM2take=L2sorted(1:PLM2size,:);
PLM2=mean(PLM2take);
PLMA2=L2sorted(1);%%%%%%


L3element=L3(L2inline(1:PLM2size));%%%%%参与PLM3的初始元素
[L3sorted,~]=sort(L3element);
PLM3size=round(size(L3sorted,1)/2);
PLM3take=L3sorted(1:PLM3size);
PLM3=mean(PLM3take);
PLMA3=L3sorted(1);%%%%%%
end