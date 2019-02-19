function X_macrof1v2 = macrof1v2(cm)
%Inputs:
%   CM: a four by four confusion matrix
% 
%   Outputs:
%   X_macrof1: macro f1 score (the average f1 score across all four
%   categories)


% Calculate F1 for class 1
TP_1 = cm(1,1);
FN_1 = sum(cm(1,2:4));
R_1 = TP_1/(TP_1+ FN_1);
P_1 = TP_1/(TP_1);
F1_1 = 2*((R_1*P_1)/(R_1+P_1));

% Calculate F1 for classs 2
TP_2 = cm(2,2);
FP_2 = cm(2,1);
FN_2 = sum(cm(2,3:4));
R_2 = TP_2/(TP_2+ FN_2);
P_2 = TP_2/(TP_2 + FP_2);
F1_2 = 2*((R_2*P_2)/(R_2+P_2));

% Calculate F1 for classs 3
TP_3 = cm(3,3);
FP_3 = sum(cm(3,1:2));
FN_3 = sum(cm(3,4));
R_3 = TP_3/(TP_3+ FN_3);
P_3 = TP_3/(TP_3 + FP_3);
F1_3 = 2*((R_3*P_3)/(R_3+P_3));

% Calculate F1 for classs 4
TP_4 = cm(4,4);
FP_4 = sum(cm(4,1:3));
FN_4 = 0;
R_4 = TP_4/(TP_4+ FN_4);
P_4 = TP_4/(TP_4 + FP_4);
F1_4 = 2*((R_4*P_4)/(R_4+P_4));

X_macrof1v2 = mean([F1_1, F1_2, F1_3, F1_4]);
