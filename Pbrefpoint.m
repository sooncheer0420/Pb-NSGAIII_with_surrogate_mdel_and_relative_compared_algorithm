function Znew=Pbrefpoint(PopObjraw,Zinit,Znow,i,PLM1,PLM2,PLM3)
%% usual method
checkif10=mod(i,7);
if checkif10==0
    Znew(:,1)=Zinit(:,1)*PLM1;
    Znew(:,2)=Zinit(:,2)*PLM2;
    Znew(:,3)=Zinit(:,3)*1;

else 
    Znew=Znow;
end
%% hyperplane
% checkif10=mod(i,7);
% if checkif10==0
%     Znew(:,1)=(Zinit(:,1))*(PLM1-PLMA1);
%     Znew(:,2)=(Zinit(:,2))*(PLM2-PLMA2);
%     Znew(:,3)=(Zinit(:,3))*(PLM3-PLMA3);
% else 
%     Znew=Znow;
% end
end