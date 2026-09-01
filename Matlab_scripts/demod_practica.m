clear all; close all; clc;
indice_figuras=1;
%%
ILA_data_aux=readtable("Rx/DEMODprevio/iladata/waveform.csv");
%ILA_data_aux=readtable("Rx/samplesIN/iladata/waveform.csv");

Sin_I=table2array(ILA_data_aux(:,4:11)).* 2^(-16);Sin_I=Sin_I'; Sin_I=Sin_I(:)';
Sin_valid=table2array(ILA_data_aux(:,20));Sin_valid=Sin_valid';
Sin_Q=table2array(ILA_data_aux(:,12:19)).* 2^(-16);Sin_Q=Sin_Q'; Sin_Q=Sin_Q(:)';


limite_inf=1; limite_sup=200;
figure(indice_figuras)
subplot(3,1,1); plot([limite_inf:1/8:limite_sup-1/8],Sin_I(limite_inf*8:limite_sup*8-1)), title('Frame Rx real');
subplot(3,1,2); plot([limite_inf:1/8:limite_sup-1/8],Sin_Q(limite_inf*8:limite_sup*8-1)), title('Frame Rx imag');
subplot(3,1,3); plot([limite_inf:limite_sup],Sin_valid(limite_inf:limite_sup)), title('Frame Rx Valid');
indice_figuras=indice_figuras+1;

%%
init=59; fin=init+8; desfase=-4;
un_simbolo_Q=Sin_Q((8*init-3-desfase):(fin*8-4-desfase));
un_simbolo_I=Sin_I((8*init-3-desfase):(fin*8-4-desfase));

figure(indice_figuras)
subplot(2,1,1); plot(un_simbolo_I), title('Frame Rx real');
subplot(2,1,2); plot(un_simbolo_Q), title('Frame Rx imag');
indice_figuras=indice_figuras+1;


%%

un_simbolo=complex(un_simbolo_I,un_simbolo_Q);
demod=fft(un_simbolo,64);
demod_I=real(demod); demod_Q=imag(demod);

figure(indice_figuras)
subplot(2,1,1); plot(demod_I), title('Demod matlab real');
subplot(2,1,2); plot(demod_Q), title('Demod matlab imag');
indice_figuras=indice_figuras+1;



%%%%%%%%
%% MOD
ILA_data_aux=readtable("Tx/CP/iladata/waveform.csv");

Sin_I=table2array(ILA_data_aux(:,4:11)).* 2^(-16);Sin_I=Sin_I'; Sin_I=Sin_I(:)';
Sin_valid=table2array(ILA_data_aux(:,20));Sin_valid=Sin_valid';
Sin_Q=table2array(ILA_data_aux(:,12:19)).* 2^(-16);Sin_Q=Sin_Q'; Sin_Q=Sin_Q(:)';


limite_inf=1; limite_sup=200;
figure(indice_figuras)
subplot(3,1,1); plot([limite_inf:1/8:limite_sup-1/8],Sin_I(limite_inf*8:limite_sup*8-1)), title('Frame Rx real');
subplot(3,1,2); plot([limite_inf:1/8:limite_sup-1/8],Sin_Q(limite_inf*8:limite_sup*8-1)), title('Frame Rx imag');
subplot(3,1,3); plot([limite_inf:limite_sup],Sin_valid(limite_inf:limite_sup)), title('Frame Rx Valid');
indice_figuras=indice_figuras+1;

%%
init=51; fin=init+8; desfase=-6;
un_simbolo_Q=Sin_Q((8*init-3-desfase):(fin*8-4-desfase));
un_simbolo_I=Sin_I((8*init-3-desfase):(fin*8-4-desfase));

figure(indice_figuras)
subplot(2,1,1); plot(un_simbolo_I), title('Frame Rx real');
subplot(2,1,2); plot(un_simbolo_Q), title('Frame Rx imag');
indice_figuras=indice_figuras+1;

%%

un_simbolo=complex(un_simbolo_I,un_simbolo_Q);
demod=fft(un_simbolo,64);
demod_I=real(demod); demod_Q=imag(demod);

figure(indice_figuras)
subplot(2,1,1); plot(demod_I), title('Demod matlab real');
subplot(2,1,2); plot(demod_Q), title('Demod matlab imag');
indice_figuras=indice_figuras+1;


%% Demod LTS

ILA_data_aux=readtable("Rx/samplesIN/iladata/waveform.csv");


Sin_Q=table2array(ILA_data_aux(:,4:11)).* 2^(-16);Sin_Q=Sin_Q'; Sin_Q=Sin_Q(:)';
Sin_valid=table2array(ILA_data_aux(:,12));Sin_valid=Sin_valid';
Sin_I=table2array(ILA_data_aux(:,13:20)).* 2^(-16);Sin_I=Sin_I'; Sin_I=Sin_I(:)';


limite_inf=200; limite_sup=300;
figure(indice_figuras)
subplot(3,1,1); plot([limite_inf:1/8:limite_sup-1/8],Sin_I(limite_inf*8:limite_sup*8-1)), title('Frame Rx real');
subplot(3,1,2); plot([limite_inf:1/8:limite_sup-1/8],Sin_Q(limite_inf*8:limite_sup*8-1)), title('Frame Rx imag');
subplot(3,1,3); plot([limite_inf:limite_sup],Sin_valid(limite_inf:limite_sup)), title('Frame Rx Valid');
indice_figuras=indice_figuras+1;

%%

init=240; fin=init+8; desfase=1;
un_simbolo_Q=Sin_Q((8*init-2-desfase):(fin*8-3-desfase));
un_simbolo_I=Sin_I((8*init-3-desfase):(fin*8-4-desfase));

figure(indice_figuras)
subplot(2,1,1); plot(un_simbolo_I), title('Frame Rx real');
subplot(2,1,2); plot(un_simbolo_Q), title('Frame Rx imag');
indice_figuras=indice_figuras+1;


%%

un_simbolo=complex(un_simbolo_I,un_simbolo_Q);
demod=fft(un_simbolo,64);
demod_I=real(demod); demod_Q=imag(demod);

figure(indice_figuras)
subplot(2,1,1); plot(demod_I), title('Demod matlab real');
subplot(2,1,2); plot(demod_Q), title('Demod matlab imag');
indice_figuras=indice_figuras+1;


%% Demod Tx

ILA_data_aux=readtable("Tx/samplesOUT/iladata/waveform.csv");


Sin_Q=table2array(ILA_data_aux(:,4:11)).* 2^(-15);Sin_Q=Sin_Q'; Sin_Q=Sin_Q(:)';
Sin_valid=table2array(ILA_data_aux(:,20));Sin_valid=Sin_valid';
Sin_I=table2array(ILA_data_aux(:,12:19)).* 2^(-15);Sin_I=Sin_I'; Sin_I=Sin_I(:)';


limite_inf=270; limite_sup=340;
figure(indice_figuras)
subplot(3,1,1); plot([limite_inf:1/8:limite_sup-1/8],Sin_I(limite_inf*8:limite_sup*8-1)), title('Frame Rx real');
subplot(3,1,2); plot([limite_inf:1/8:limite_sup-1/8],Sin_Q(limite_inf*8:limite_sup*8-1)), title('Frame Rx imag');
subplot(3,1,3); plot([limite_inf:limite_sup],Sin_valid(limite_inf:limite_sup)), title('Frame Rx Valid');
indice_figuras=indice_figuras+1;


%%

init=306; fin=init+8; desfase=4;
un_simbolo_Q=Sin_Q((8*init-3-desfase):(fin*8-4-desfase));
un_simbolo_I=Sin_I((8*init-3-desfase):(fin*8-4-desfase));

figure(indice_figuras)
subplot(2,1,1); plot(un_simbolo_I), title('Frame Rx real');
subplot(2,1,2); plot(un_simbolo_Q), title('Frame Rx imag');
indice_figuras=indice_figuras+1;

%%
un_simbolo=complex(un_simbolo_I,un_simbolo_Q);
demod=fft(un_simbolo,64);
demod_I=real(demod); demod_Q=imag(demod);

figure(indice_figuras)
subplot(2,1,1); plot(demod_I), title('Demod matlab real');
subplot(2,1,2); plot(demod_Q), title('Demod matlab imag');
indice_figuras=indice_figuras+1;