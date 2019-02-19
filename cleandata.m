function X_cleandata = cleandata(X)
%Inputs:
%   CM: a table of data from the Costa Rican Household Survey
% 
%   Outputs:
%   X_cleandata: a table of cleaned data

crdata = X;

% Data Cleaning
crdata = removevars(crdata, 'Id'); % this is the id of the row
crdata = removevars(crdata, 'idhogar'); %remove this column as its the id of the household - the target is based on this variable
crdata = removevars(crdata, 'elimbasu5'); % Remove this column as there is no variation in the values
crdata = removevars(crdata, 'SQBmeaned');
crdata = removevars(crdata, 'meaneduc');

% cleaning up columns with nan
crdata.v2a1(isnan(crdata.v2a1)) = 0; %variable refers to rent amount.  Kaggle discussion board confirmed that Nan rent = own home
crdata.v18q1(isnan(crdata.v18q1)) = 0;%variable refer to number of tablets each house owns
crdata.rez_esc(isnan(crdata.rez_esc)) = 0;

%cleaning up columns with strings
%Kaggle discussion board confirms 'yes' = 1, 'no' = 0
%REMOVE UNTIL I FIGURE OUT HOW TO CONVERT?
crdata = removevars(crdata, 'dependency');
crdata = removevars(crdata, 'edjefe');
crdata = removevars(crdata, 'edjefa');

%setting variables as categorical

crdata.hacdor = categorical(crdata.hacdor);% 1= overcrowding by bedrooms
crdata.hacapo = categorical(crdata.hacapo);%hacapo, =1 Overcrowding by rooms
crdata.v14a = categorical(crdata.v14a);% v14a, =1 has bathroom in the household
crdata.refrig = categorical(crdata.refrig); %refrig, =1 if the household has refrigerator
crdata.v18q = categorical(crdata.v18q);% v18q, owns a tablet
crdata.paredbload = categorical(crdata.paredblolad); %paredblolad, =1 if predominant material on the outside wall is block or brick
crdata.paredzocalo = categorical(crdata.paredzocalo); %paredzocalo, "=1 if predominant material on the outside wall is socket (wood,  zinc or absbesto"
crdata.paredpred = categorical(crdata.paredpreb);%paredpreb, =1 if predominant material on the outside wall is prefabricated or cement
crdata.pareddes = categorical(crdata.pareddes);%pareddes, =1 if predominant material on the outside wall is waste material
crdata.paredmad = categorical(crdata.paredmad);%paredmad, =1 if predominant material on the outside wall is wood
crdata.paredzinc = categorical(crdata.paredzinc);%paredzinc, =1 if predominant material on the outside wall is zink
crdata.paredfibras = categorical(crdata.paredfibras);%paredfibras, =1 if predominant material on the outside wall is natural fibers
crdata.paredother = categorical(crdata.paredother);%paredother, =1 if predominant material on the outside wall is other
crdata.pisomoscer = categorical(crdata.pisomoscer);%pisomoscer, "=1 if predominant material on the floor is mosaic,  ceramic,  terrazo"
crdata.pisocemento = categorical(crdata.pisocemento);%pisocemento, =1 if predominant material on the floor is cement
crdata.pisoother = categorical(crdata.pisoother); %pisoother, =1 if predominant material on the floor is other
crdata.pisonatur = categorical(crdata.pisonatur); %pisonatur, =1 if predominant material on the floor is  natural material
crdata.pisonotiene = categorical(crdata.pisonotiene);%pisonotiene, =1 if no floor at the household
crdata.pisomadera = categorical(crdata.pisomadera);%pisomadera, =1 if predominant material on the floor is wood
crdata.techozinc = categorical(crdata.techozinc);%techozinc, =1 if predominant material on the roof is metal foil or zink
crdata.techoentrepiso = categorical(crdata.techoentrepiso);%techoentrepiso, "=1 if predominant material on the roof is fiber cement,  mezzanine "
crdata.techocane = categorical(crdata.techocane);%techocane, =1 if predominant material on the roof is natural fibers
crdata.techootro = categorical(crdata.techootro);%techootro, =1 if predominant material on the roof is other
crdata.cielorazo = categorical(crdata.cielorazo);%cielorazo, =1 if the house has ceiling
crdata.abastaguadentro = categorical(crdata.abastaguadentro);%abastaguadentro, =1 if water provision inside the dwelling
crdata.abastaguafuera = categorical(crdata.abastaguafuera);%abastaguafuera, =1 if water provision outside the dwelling
crdata.abastaguano = categorical(crdata.abastaguano);%abastaguano, =1 if no water provision
crdata.public = categorical(crdata.public); %public, "=1 electricity from CNFL,  ICE,  ESPH/JASEC"
crdata.planpri = categorical(crdata.planpri);%planpri, =1 electricity from private plant
crdata.noelec = categorical(crdata.noelec);%noelec, =1 no electricity in the dwelling
crdata.coopele = categorical(crdata.coopele);%coopele, =1 electricity from cooperative
crdata.sanitario1 = categorical(crdata.sanitario1);%sanitario1, =1 no toilet in the dwelling
crdata.sanitario2 = categorical(crdata.sanitario2);%sanitario2, =1 toilet connected to sewer or cesspool
crdata.sanitario3 = categorical(crdata.sanitario3);%sanitario3, =1 toilet connected to  septic tank
crdata.sanitario5 = categorical(crdata.sanitario5);%sanitario5, =1 toilet connected to black hole or letrine
crdata.sanitario6 = categorical(crdata.sanitario6);%sanitario6, =1 toilet connected to other system
crdata.energcocinar1 = categorical(crdata.energcocinar1); %energcocinar1, =1 no main source of energy used for cooking (no kitchen)
crdata.energcocinar2 = categorical(crdata.energcocinar2);%energcocinar2, =1 main source of energy used for cooking electricity
crdata.abastaguadentro = categorical(crdata.energcocinar3);%energcocinar3, =1 main source of energy used for cooking gas
crdata.abastaguadentro = categorical(crdata.energcocinar4);%energcocinar4, =1 main source of energy used for cooking wood charcoal
crdata.elimbasu1 = categorical(crdata.elimbasu1);%elimbasu1, =1 if rubbish disposal mainly by tanker truck
crdata.elimbasu2 = categorical(crdata.elimbasu2);%elimbasu2, =1 if rubbish disposal mainly by botan hollow or buried
crdata.elimbasu3 = categorical(crdata.elimbasu3);%elimbasu3, =1 if rubbish disposal mainly by burning
crdata.elimbasu4 = categorical(crdata.elimbasu4);%elimbasu4, =1 if rubbish disposal mainly by throwing in an unoccupied space
% row removed above - crdata.elimbasu5 = categorical(crdata.elimbasu5);%elimbasu5, "=1 if rubbish disposal mainly by throwing in river,  creek or sea"
crdata.elimbasu6 = categorical(crdata.elimbasu6);%elimbasu6, =1 if rubbish disposal mainly other
crdata.epared1 = categorical(crdata.epared1);%epared1, =1 if walls are bad
crdata.epared2 = categorical(crdata.epared2);%epared2, =1 if walls are regular
crdata.epared3 = categorical(crdata.epared3);%epared3, =1 if walls are good
crdata.etecho1 = categorical(crdata.etecho1);%etecho1, =1 if roof are bad
crdata.etecho2 = categorical(crdata.etecho2);%etecho2, =1 if roof are regular
crdata.etecho3 = categorical(crdata.etecho3);%etecho3, =1 if roof are good
crdata.eviv1 = categorical(crdata.eviv1);%eviv1, =1 if floor are bad
crdata.eviv2 = categorical(crdata.eviv2); %eviv2, =1 if floor are regular
crdata.eviv3 = categorical(crdata.eviv3);%eviv3, =1 if floor are good
crdata.dis = categorical(crdata.dis);%dis, =1 if disable person
crdata.male = categorical(crdata.male);%male, =1 if male
crdata.female = categorical(crdata.female);%female, =1 if female
crdata.estadocivil1 = categorical(crdata.estadocivil1); %estadocivil1, =1 if less than 10 years old
crdata.estadocivil1 = categorical(crdata.estadocivil2);%estadocivil2, =1 if free or coupled uunion
crdata.estadocivil3 = categorical(crdata.estadocivil3);% estadocivil3, =1 if married
crdata.estadocivil4 = categorical(crdata.estadocivil4);%estadocivil4, =1 if divorced
crdata.estadocivil5 = categorical(crdata.estadocivil5);%estadocivil5, =1 if separated
crdata.estadocivil6 = categorical(crdata.estadocivil6);%estadocivil6, =1 if widow/er
crdata.estadocivil7 = categorical(crdata.estadocivil7);%estadocivil7, =1 if single
crdata.parentesco1 = categorical(crdata.parentesco1);%parentesco1, =1 if household head
crdata.parentesco2 = categorical(crdata.parentesco2);%parentesco2, =1 if spouse/partner
crdata.parentesco3 = categorical(crdata.parentesco3);%parentesco3, =1 if son/doughter
crdata.parentesco4 = categorical(crdata.parentesco4);%parentesco4, =1 if stepson/doughter
crdata.parentesco5 = categorical(crdata.parentesco5);%parentesco5, =1 if son/doughter in law
crdata.parentesco6 = categorical(crdata.parentesco6);%parentesco6, =1 if grandson/doughter
crdata.parentesco7 = categorical(crdata.parentesco7);%parentesco7, =1 if mother/father
crdata.parentesco8 = categorical(crdata.parentesco8);%parentesco8, =1 if father/mother in law
crdata.parentesco9 = categorical(crdata.parentesco9);%parentesco9, =1 if brother/sister
crdata.parentesco10 = categorical(crdata.parentesco10);%parentesco10, =1 if brother/sister in law
crdata.parentesco11 = categorical(crdata.parentesco11);%parentesco11, =1 if other family member
crdata.parentesco12 = categorical(crdata.parentesco12);%parentesco12, =1 if other non family member
%idhogar, Household level identifier
crdata.instlevel1 = categorical(crdata.instlevel1);%instlevel1, =1 no level of education
crdata.instlevel2 = categorical(crdata.instlevel2);%instlevel2, =1 incomplete primary
crdata.instlevel3 = categorical(crdata.instlevel3);%instlevel3, =1 complete primary
crdata.instlevel4 = categorical(crdata.instlevel4);%instlevel4, =1 incomplete academic secondary level
crdata.instlevel5 = categorical(crdata.instlevel5);%instlevel5, =1 complete academic secondary level
crdata.instlevel6 = categorical(crdata.instlevel6);%instlevel6, =1 incomplete technical secondary level
crdata.instlevel7 = categorical(crdata.instlevel7);%instlevel7, =1 complete technical secondary level
crdata.instlevel8 = categorical(crdata.instlevel8);%instlevel8, =1 undergraduate and higher education
crdata.instlevel9 = categorical(crdata.instlevel9);%instlevel9, =1 postgraduate higher education
crdata.tipovivi1 = categorical(crdata.tipovivi1);%tipovivi1, =1 own and fully paid house
crdata.tipovivi2 = categorical(crdata.tipovivi2);%tipovivi2, "=1 own,  paying in installments"
crdata.tipovivi3 = categorical(crdata.tipovivi3);%tipovivi3, =1 rented
crdata.tipovivi4 = categorical(crdata.tipovivi4);%tipovivi4, =1 precarious
crdata.tipovivi5 = categorical(crdata.tipovivi5);%tipovivi5, "=1 other(assigned,  borrowed)"
crdata.computer = categorical(crdata.computer);%computer, =1 if the household has notebook or desktop computer
crdata.television = categorical(crdata.television);%television, =1 if the household has TV
crdata.mobilephone= categorical(crdata.mobilephone);%mobilephone, =1 if mobile phone
crdata.lugar1 = categorical(crdata.lugar1);%lugar1, =1 region Central
crdata.lugar2 = categorical(crdata.lugar2);%lugar2, =1 region Chorotega
crdata.lugar3 = categorical(crdata.lugar3);%lugar3, =1 region PacÃ­fico central
crdata.lugar4 = categorical(crdata.lugar4);%lugar4, =1 region Brunca
crdata.lugar5 = categorical(crdata.lugar5);%lugar5, =1 region Huetar AtlÃ¡ntica
crdata.lugar6 = categorical(crdata.lugar6);%lugar6, =1 region Huetar Norte
crdata.area1 = categorical(crdata.area1); %area1, =1 zona urbana
crdata.area2 = categorical(crdata.area2);%area2, =2 zona rural

crdata.Target = categorical(crdata.Target); % setting the Target variable to categorical

X_cleandata = crdata;


