clc;close all;clear all;

indice_figuras=1;
%% %% TRANSMITTER %% %%

%% Serial to Parallel
ILA_data_aux=readtable("Tx/SP/iladata/waveform.csv");

SP_I=table2array(ILA_data_aux(:,4:11));SP_I=SP_I'; SP_I=SP_I(:)';
SP_Q=table2array(ILA_data_aux(:,12:19));SP_Q=SP_Q'; SP_Q=SP_Q(:)';

limite_inf=1; limite_sup=10;
figure(indice_figuras)
subplot(2,1,1); plot([limite_inf:1/8:limite_sup-1/8],SP_I(limite_inf*8:limite_sup*8-1)), title('SP I');
subplot(2,1,2); plot([limite_inf:1/8:limite_sup-1/8],SP_Q(limite_inf*8:limite_sup*8-1)), title('SP Q');
indice_figuras=indice_figuras+1;

%% BC
ILA_data_aux=readtable("Tx/BC/iladata/waveform.csv");

BC_I=table2array(ILA_data_aux(:,4:11));BC_I=BC_I'; BC_I=BC_I(:)';
BC_I_valid=table2array(ILA_data_aux(:,12));BC_I_valid=BC_I_valid';
BC_Q=table2array(ILA_data_aux(:,13:20));BC_Q=BC_Q'; BC_Q=BC_Q(:)';
BC_Q_valid=table2array(ILA_data_aux(:,21));BC_Q_valid=BC_Q_valid';

limite_inf=1; limite_sup=50;
figure(indice_figuras)
subplot(4,1,1); plot([limite_inf:1/8:limite_sup-1/8],BC_I(limite_inf*8:limite_sup*8-1)), title('BC I');
subplot(4,1,2); plot([limite_inf:limite_sup],BC_I_valid(limite_inf:limite_sup)), title('BC I valid');
subplot(4,1,3); plot([limite_inf:1/8:limite_sup-1/8],SP_Q(limite_inf*8:limite_sup*8-1)), title('SP Q');
subplot(4,1,4); plot([limite_inf:limite_sup],BC_Q_valid(limite_inf:limite_sup)), title('BC Q valid');
indice_figuras=indice_figuras+1;

%% QPSK
ILA_data_aux=readtable("Tx/QPSK/iladata/waveform.csv");

QPSK_I=table2array(ILA_data_aux(:,4:11)).* 2^(-16);QPSK_I=QPSK_I'; QPSK_I=QPSK_I(:)';
QPSK_I_valid=table2array(ILA_data_aux(:,12));QPSK_I_valid=QPSK_I_valid';
QPSK_Q=table2array(ILA_data_aux(:,13:20)).* 2^(-16);QPSK_Q=QPSK_Q'; QPSK_Q=QPSK_Q(:)';
QPSK_Q_valid=table2array(ILA_data_aux(:,21));QPSK_Q_valid=QPSK_Q_valid';

limite_inf=1; limite_sup=50;
figure(indice_figuras)
subplot(4,1,1); plot([limite_inf:1/8:limite_sup-1/8],QPSK_I(limite_inf*8:limite_sup*8-1)), title('QPSK I');
subplot(4,1,2); plot([limite_inf:limite_sup],QPSK_I_valid(limite_inf:limite_sup)), title('QPSK I valid');
subplot(4,1,3); plot([limite_inf:1/8:limite_sup-1/8],QPSK_Q(limite_inf*8:limite_sup*8-1)), title('QPSK Q');
subplot(4,1,4); plot([limite_inf:limite_sup],QPSK_Q_valid(limite_inf:limite_sup)), title('QPSK Q valid');
indice_figuras=indice_figuras+1;

%% WC
ILA_data_aux=readtable("Tx/WC/iladata/waveform.csv");

WC_I=table2array(ILA_data_aux(:,4:11)).* 2^(-16);WC_I=WC_I'; WC_I=WC_I(:)';
WC_Q=table2array(ILA_data_aux(:,12:19)).* 2^(-16);WC_Q=WC_Q'; WC_Q=WC_Q(:)';
WC_valid=table2array(ILA_data_aux(:,20));WC_valid=WC_valid';

limite_inf=1; limite_sup=50;
figure(indice_figuras)
subplot(3,1,1); plot([limite_inf:1/8:limite_sup-1/8],WC_I(limite_inf*8:limite_sup*8-1)), title('WC I');
subplot(3,1,2); plot([limite_inf:1/8:limite_sup-1/8],WC_Q(limite_inf*8:limite_sup*8-1)), title('WC Q');
subplot(3,1,3); plot([limite_inf:limite_sup],WC_valid(limite_inf:limite_sup)), title('WC valid');
indice_figuras=indice_figuras+1;

%% Mod
ILA_data_aux=readtable("Tx/Mod/iladata/waveform.csv");

Mod_I=table2array(ILA_data_aux(:,4:11)).* 2^(-16);Mod_I=Mod_I'; Mod_I=Mod_I(:)';
Mod_Q=table2array(ILA_data_aux(:,12:19)).* 2^(-16);Mod_Q=Mod_Q'; Mod_Q=Mod_Q(:)';
Mod_valid=table2array(ILA_data_aux(:,20));Mod_valid=Mod_valid';

limite_inf=1; limite_sup=50;
figure(indice_figuras)
subplot(3,1,1); plot([limite_inf:1/8:limite_sup-1/8],Mod_I(limite_inf*8:limite_sup*8-1)), title('Mod I');
subplot(3,1,2); plot([limite_inf:1/8:limite_sup-1/8],Mod_Q(limite_inf*8:limite_sup*8-1)), title('Mod Q');
subplot(3,1,3); plot([limite_inf:limite_sup],Mod_valid(limite_inf:limite_sup)), title('Mod valid');
indice_figuras=indice_figuras+1;

%% VS
ILA_data_aux=readtable("Tx/VS/iladata/waveform.csv");

VS_I=table2array(ILA_data_aux(:,4:11)).* 2^(-16);VS_I=VS_I'; VS_I=VS_I(:)';
VS_Q=table2array(ILA_data_aux(:,12:19)).* 2^(-16);VS_Q=VS_Q'; VS_Q=VS_Q(:)';
VS_valid=table2array(ILA_data_aux(:,20));VS_valid=VS_valid';

limite_inf=1; limite_sup=50;
figure(indice_figuras)
subplot(3,1,1); plot([limite_inf:1/8:limite_sup-1/8],VS_I(limite_inf*8:limite_sup*8-1)), title('VS I');
subplot(3,1,2); plot([limite_inf:1/8:limite_sup-1/8],VS_Q(limite_inf*8:limite_sup*8-1)), title('VS Q');
subplot(3,1,3); plot([limite_inf:limite_sup],VS_valid(limite_inf:limite_sup)), title('VS valid');
indice_figuras=indice_figuras+1;

%% CP
ILA_data_aux=readtable("Tx/CP/iladata/waveform.csv");

CP_I=table2array(ILA_data_aux(:,4:11)).* 2^(-16);CP_I=CP_I'; CP_I=CP_I(:)';
CP_Q=table2array(ILA_data_aux(:,12:19)).* 2^(-16);CP_Q=CP_Q'; CP_Q=CP_Q(:)';
CP_valid=table2array(ILA_data_aux(:,20));CP_valid=CP_valid';

limite_inf=1; limite_sup=50;
figure(indice_figuras)
subplot(3,1,1); plot([limite_inf:1/8:limite_sup-1/8],CP_I(limite_inf*8:limite_sup*8-1)), title('CP I');
subplot(3,1,2); plot([limite_inf:1/8:limite_sup-1/8],CP_Q(limite_inf*8:limite_sup*8-1)), title('CP Q');
subplot(3,1,3); plot([limite_inf:limite_sup],CP_valid(limite_inf:limite_sup)), title('CP valid');
indice_figuras=indice_figuras+1;

%% Frame
ILA_data_aux=readtable("Tx/Frame/iladata/waveform.csv");

F_preamble=table2array(ILA_data_aux(:,4:11)).* 2^(-16);F_preamble=F_preamble'; F_preamble=F_preamble(:)';
F_symbols=table2array(ILA_data_aux(:,12:19)).* 2^(-16);F_symbols=F_symbols'; F_symbols=F_symbols(:)';
F_selector=table2array(ILA_data_aux(:,20));F_selector=F_selector';

limite_inf=100; limite_sup=200;
figure(indice_figuras)
subplot(3,1,1); plot([limite_inf:1/8:limite_sup-1/8],F_preamble(limite_inf*8:limite_sup*8-1)), title('Frame imag preamble');
subplot(3,1,2); plot([limite_inf:1/8:limite_sup-1/8],F_symbols(limite_inf*8:limite_sup*8-1)), title('Frame imag symbols');
subplot(3,1,3); plot([limite_inf:limite_sup],F_selector(limite_inf:limite_sup)), title('Frame Selector');
indice_figuras=indice_figuras+1;


%% SamplesOUT
ILA_data_aux=readtable("Tx/samplesOUT/iladata/waveform.csv");

Sout_Q=table2array(ILA_data_aux(:,4:11)).* 2^(-15);Sout_Q=Sout_Q'; Sout_Q=Sout_Q(:)';
Sout_I=table2array(ILA_data_aux(:,12:19)).* 2^(-15);Sout_I=Sout_I'; Sout_I=Sout_I(:)';
Sout_valid=table2array(ILA_data_aux(:,20));Sout_valid=Sout_valid';

limite_inf=300; limite_sup=500;
figure(indice_figuras)
subplot(3,1,1); plot([limite_inf:1/8:limite_sup-1/8],Sout_I(limite_inf*8:limite_sup*8-1)), title('Frame real');grid on;
subplot(3,1,2); plot([limite_inf:1/8:limite_sup-1/8],Sout_Q(limite_inf*8:limite_sup*8-1)), title('Frame imag');grid on;
subplot(3,1,3); plot([limite_inf:limite_sup],Sout_valid(limite_inf:limite_sup)), title('Frame Valid');grid on;
indice_figuras=indice_figuras+1;

%% %% Receiver %% %% 

%% SamplesIN
ILA_data_aux=readtable("Rx/samplesIN/iladata/waveform.csv");

Sin_Q=table2array(ILA_data_aux(:,4:11)).* 2^(-15);Sin_Q=Sin_Q'; Sin_Q=Sin_Q(:)';
Sin_valid=table2array(ILA_data_aux(:,12));Sin_valid=Sin_valid';
Sin_I=table2array(ILA_data_aux(:,13:20)).* 2^(-15);Sin_I=Sin_I'; Sin_I=Sin_I(:)';

%Cambio rápido por el cambio de convertidores
aux=Sin_Q;
Sin_Q=Sin_I;
Sin_I=aux;

limite_inf=200; limite_sup=400;
figure(indice_figuras)
subplot(3,1,1); plot([limite_inf:1/8:limite_sup-1/8],Sin_I(limite_inf*8:limite_sup*8-1)), title('Frame Rx real');grid on;
subplot(3,1,2); plot([limite_inf:1/8:limite_sup-1/8],Sin_Q(limite_inf*8:limite_sup*8-1)), title('Frame Rx imag');grid on;
subplot(3,1,3); plot([limite_inf:limite_sup],Sin_valid(limite_inf:limite_sup)), title('Frame Rx Valid');grid on;
indice_figuras=indice_figuras+1;

%% Detection
ILA_data_aux=readtable("Rx/D/iladata/waveform.csv");

D_correlation=table2array(ILA_data_aux(:,4:11)).* 2^(-15);D_correlation=D_correlation'; D_correlation=D_correlation(:)';
D_Energy=table2array(ILA_data_aux(:,12:19)).* 2^(-15);D_Energy=D_Energy'; D_Energy=D_Energy(:)';
D_Result=table2array(ILA_data_aux(:,20:27));D_Result=D_Result'; D_Result=D_Result(:)';

limite_inf=1; limite_sup=300;
figure(indice_figuras)
subplot(4,1,1); plot([limite_inf:1/8:limite_sup-1/8],D_correlation(limite_inf*8:limite_sup*8-1)), title('Detection Correlation signal');
subplot(4,1,2); plot([limite_inf:1/8:limite_sup-1/8],D_Energy(limite_inf*8:limite_sup*8-1)), title('Detection Energy signal');
subplot(4,1,3); plot([limite_inf:1/8:limite_sup-1/8],D_correlation(limite_inf*8:limite_sup*8-1)); hold on; plot([limite_inf:1/8:limite_sup-1/8],D_Energy(limite_inf*8:limite_sup*8-1)); title('Detection Correlation and Energy signals'); 
subplot(4,1,4); plot([limite_inf:1/8:limite_sup-1/8],D_Result(limite_inf*8:limite_sup*8-1)), title('Detection Result');
indice_figuras=indice_figuras+1;

%% DPA
ILA_data_aux=readtable("Rx/DPA/iladata/waveform.csv");

DPA_V2S=table2array(ILA_data_aux(:,4));DPA_V2S=DPA_V2S';
DPA_Result=table2array(ILA_data_aux(:,5));DPA_Result=DPA_Result';

limite_inf=1; limite_sup=1000;
figure(indice_figuras)
subplot(2,1,1); plot(DPA_V2S(limite_inf:limite_sup)), title('DPA V2S');
subplot(2,1,2); plot(DPA_Result(limite_inf:limite_sup)), title('DPA Result');
indice_figuras=indice_figuras+1;

%% SLTS
ILA_data_aux=readtable("Rx/SLTS/iladata/waveform.csv");

SLTS_I=table2array(ILA_data_aux(:,4:11)).* 2^(-15);SLTS_I=SLTS_I'; SLTS_I=SLTS_I(:)';
SLTS_Q=table2array(ILA_data_aux(:,12:19)).* 2^(-15);SLTS_Q=SLTS_Q'; SLTS_Q=SLTS_Q(:)';
SLTS_Imean=table2array(ILA_data_aux(:,20:27)).* 2^(-15);SLTS_Imean=SLTS_Imean'; SLTS_Imean=SLTS_Imean(:)';
SLTS_Qmean=table2array(ILA_data_aux(:,28:35)).* 2^(-15);SLTS_Qmean=SLTS_Qmean'; SLTS_Qmean=SLTS_Qmean(:)';

limite_inf=300; limite_sup=400; 
figure(indice_figuras)
subplot(4,1,1); stem([limite_inf:1/8:limite_sup-1/8],SLTS_I(limite_inf*8:limite_sup*8-1)), title('SLTS I'); grid on;
subplot(4,1,2); stem([limite_inf:1/8:limite_sup-1/8],SLTS_Imean(limite_inf*8:limite_sup*8-1)); title('SLTS Imean'); grid on;
subplot(4,1,3); stem([limite_inf:1/8:limite_sup-1/8],SLTS_Q(limite_inf*8:limite_sup*8-1)), title('SLTS Q'); grid on;
subplot(4,1,4); stem([limite_inf:1/8:limite_sup-1/8],SLTS_Qmean(limite_inf*8:limite_sup*8-1)), title('SLTS Qmean'); grid on;
indice_figuras=indice_figuras+1;

%% DEMOD previo
ILA_data_aux=readtable("Rx/DEMODprevio/iladata/waveform.csv");

DEMODprevio_I=table2array(ILA_data_aux(:,4:11)).* 2^(-15);DEMODprevio_I=DEMODprevio_I'; DEMODprevio_I=DEMODprevio_I(:)';
DEMODprevio_Q=table2array(ILA_data_aux(:,12:19)).* 2^(-15);DEMODprevio_Q=DEMODprevio_Q'; DEMODprevio_Q=DEMODprevio_Q(:)';
DEMODprevio_valid=table2array(ILA_data_aux(:,20));DEMODprevio_valid=DEMODprevio_valid';

limite_inf=300; limite_sup=450; 
figure(indice_figuras)
subplot(3,1,1); stem([limite_inf:1/8:limite_sup-1/8],DEMODprevio_I(limite_inf*8:limite_sup*8-1)), title('DEMODprevio I'); grid on;
subplot(3,1,2); stem([limite_inf:1/8:limite_sup-1/8],DEMODprevio_Q(limite_inf*8:limite_sup*8-1)), title('DEMODprevio Q'); grid on;
subplot(3,1,3); plot([limite_inf:limite_sup],DEMODprevio_valid(limite_inf:limite_sup)), title('DEMODprevio valid'); grid on;
indice_figuras=indice_figuras+1;

%% DEMOD
ILA_data_aux=readtable("Rx/DEMOD/iladata/waveform.csv");

DEMOD_I=table2array(ILA_data_aux(:,4:11)).* 2^(-16);DEMOD_I=DEMOD_I'; DEMOD_I=DEMOD_I(:)';
DEMOD_Q=table2array(ILA_data_aux(:,12:19)).* 2^(-16);DEMOD_Q=DEMOD_Q'; DEMOD_Q=DEMOD_Q(:)';
DEMOD_valid=table2array(ILA_data_aux(:,20));DEMOD_valid=DEMOD_valid';

limite_inf=400; limite_sup=500; 
figure(indice_figuras)
subplot(3,1,1); plot([limite_inf:1/8:limite_sup-1/8],DEMOD_I(limite_inf*8:limite_sup*8-1)), title('DEMOD I');
subplot(3,1,2); plot([limite_inf:1/8:limite_sup-1/8],DEMOD_Q(limite_inf*8:limite_sup*8-1)), title('DEMOD Q');
subplot(3,1,3); plot([limite_inf:limite_sup],DEMOD_valid(limite_inf:limite_sup)), title('DEMOD valid');
indice_figuras=indice_figuras+1;

%% WR
ILA_data_aux=readtable("Rx/WR/iladata/waveform.csv");

WR_I=table2array(ILA_data_aux(:,4:11)).* 2^(-16);WR_I=WR_I'; WR_I=WR_I(:)';
WR_Q=table2array(ILA_data_aux(:,12:19)).* 2^(-16);WR_Q=WR_Q'; WR_Q=WR_Q(:)';
WR_valid=table2array(ILA_data_aux(:,20));WR_valid=WR_valid';

limite_inf=200; limite_sup=300; 
figure(indice_figuras)
subplot(3,1,1); plot([limite_inf:1/8:limite_sup-1/8],WR_I(limite_inf*8:limite_sup*8-1)), title('WR I');
subplot(3,1,2); plot([limite_inf:1/8:limite_sup-1/8],WR_Q(limite_inf*8:limite_sup*8-1)), title('WR Q');
subplot(3,1,3); plot([limite_inf:limite_sup],WR_valid(limite_inf:limite_sup)), title('WR valid');
indice_figuras=indice_figuras+1;

%% Equalizer
ILA_data_aux=readtable("Rx/E/iladata/waveform.csv");

E_I=table2array(ILA_data_aux(:,4:11)).* 2^(-16);E_I=E_I'; E_I=E_I(:)';
E_Q=table2array(ILA_data_aux(:,12:19)).* 2^(-16);E_Q=E_Q'; E_Q=E_Q(:)';
E_valid=table2array(ILA_data_aux(:,20));E_valid=E_valid';

limite_inf=150; limite_sup=250; 
figure(indice_figuras)
subplot(3,1,1); plot([limite_inf:1/8:limite_sup-1/8],E_I(limite_inf*8:limite_sup*8-1)), title('Equalizer I');
subplot(3,1,2); plot([limite_inf:1/8:limite_sup-1/8],E_Q(limite_inf*8:limite_sup*8-1)), title('Equalizer Q');
subplot(3,1,3); plot([limite_inf:limite_sup],E_valid(limite_inf:limite_sup)), title('Equalizer valid');
indice_figuras=indice_figuras+1;

%% Constelation 
E_valid_extendido=reshape(repmat(E_valid,8,1),1,[]); %Extiende cada valor x8 
E_I_seleccionado=E_I(E_valid_extendido==1);
E_Q_seleccionado=E_Q(E_valid_extendido==1);

%subplot(2,1,1);plot(E_I(20:60));
%subplot(2,1,2);plot(E_valid_extendido(20:60));

QPSK_symbols=[E_I_seleccionado' , E_Q_seleccionado'];
figure(indice_figuras)
%scatterplot(QPSK_symbols);
% Referencia
refs=[sqrt(3/13),sqrt(3/13);-sqrt(3/13),sqrt(3/13); ...
    sqrt(3/13),-sqrt(3/13);-sqrt(3/13),-sqrt(3/13)];
for k=1:4
    plot(refs(k,1),refs(k,2),'square','MarkerSize',10);
    hold on;
end

cantidad_simbolos=size(QPSK_symbols,1);
for k=1:cantidad_simbolos
    plot(QPSK_symbols(k,1),QPSK_symbols(k,2),"x");
    hold on;
end
grid on; 
set(gca, 'XAxisLocation', 'origin');
set(gca, 'YAxisLocation', 'origin');
indice_figuras=indice_figuras+1;
%% QPSK demapping
ILA_data_aux=readtable("Rx/QPSK/iladata/waveform.csv");

DQPSK_I=table2array(ILA_data_aux(:,4:11));DQPSK_I=DQPSK_I'; DQPSK_I=DQPSK_I(:)';
DQPSK_I_valid=table2array(ILA_data_aux(:,12));DQPSK_I_valid=DQPSK_I_valid';
DQPSK_Q=table2array(ILA_data_aux(:,13:20));DQPSK_Q=DQPSK_Q'; DQPSK_Q=DQPSK_Q(:)';
DQPSK_Q_valid=table2array(ILA_data_aux(:,21));DQPSK_Q_valid=DQPSK_Q_valid';

limite_inf=1; limite_sup=250;
figure(indice_figuras)
subplot(4,1,1); plot([limite_inf:1/8:limite_sup-1/8],DQPSK_I(limite_inf*8:limite_sup*8-1)), title('Demapping QPSK I');
subplot(4,1,2); plot([limite_inf:limite_sup],DQPSK_I_valid(limite_inf:limite_sup)), title('Demapping QPSK I valid');
subplot(4,1,3); plot([limite_inf:1/8:limite_sup-1/8],DQPSK_Q(limite_inf*8:limite_sup*8-1)), title('Demapping QPSK Q');
subplot(4,1,4); plot([limite_inf:limite_sup],DQPSK_Q_valid(limite_inf:limite_sup)), title('Demapping QPSK Q valid');
indice_figuras=indice_figuras+1;

%% SC
ILA_data_aux=readtable("Rx/SC/iladata/waveform.csv");

SC_I=table2array(ILA_data_aux(:,4:11));SC_I=SC_I'; SC_I=SC_I(:)';
SC_Q=table2array(ILA_data_aux(:,12:19));SC_Q=SC_Q'; SC_Q=SC_Q(:)';
SC_valid=table2array(ILA_data_aux(:,20));SC_valid=SC_valid';

limite_inf=1; limite_sup=250;
figure(indice_figuras)
subplot(3,1,1); plot([limite_inf:1/8:limite_sup-1/8],SC_I(limite_inf*8:limite_sup*8-1)), title('SC I');
subplot(3,1,2); plot([limite_inf:1/8:limite_sup-1/8],SC_Q(limite_inf*8:limite_sup*8-1)), title('SC Q');
subplot(3,1,3); plot([limite_inf:limite_sup],SC_valid(limite_inf:limite_sup)), title('SC valid');
indice_figuras=indice_figuras+1;

%% PS
ILA_data_aux=readtable("Rx/PS/iladata/waveform.csv");

PS_I=table2array(ILA_data_aux(:,4:11));PS_I=PS_I'; PS_I=PS_I(:)';
PS_Q=table2array(ILA_data_aux(:,12:19));PS_Q=PS_Q'; PS_Q=PS_Q(:)';
PS_selector=table2array(ILA_data_aux(:,20));PS_selector=PS_selector';
PS_enable=table2array(ILA_data_aux(:,21));PS_enable=PS_enable';

limite_inf=1; limite_sup=250;
figure(indice_figuras)
subplot(4,1,1); plot([limite_inf:1/8:limite_sup-1/8],PS_I(limite_inf*8:limite_sup*8-1)), title('PS I');
subplot(4,1,2); plot([limite_inf:1/8:limite_sup-1/8],PS_Q(limite_inf*8:limite_sup*8-1)), title('PS Q');
subplot(4,1,3); plot([limite_inf:limite_sup],PS_selector(limite_inf:limite_sup)), title('PS selector');
subplot(4,1,4); plot([limite_inf:limite_sup],PS_enable(limite_inf:limite_sup)), title('PS enable');
indice_figuras=indice_figuras+1;

%% Bits OUT
ILA_data_aux=readtable("Rx/bitsOUT/iladata/waveform.csv");

bitsOUT=table2array(ILA_data_aux(:,4:11));bitsOUT=bitsOUT'; bitsOUT=bitsOUT(:)';

limite_inf=1; limite_sup=10;
figure(indice_figuras)
plot([limite_inf:1/8:limite_sup-1/8],bitsOUT(limite_inf*8:limite_sup*8-1)), title('Recovered bits');
indice_figuras=indice_figuras+1;


