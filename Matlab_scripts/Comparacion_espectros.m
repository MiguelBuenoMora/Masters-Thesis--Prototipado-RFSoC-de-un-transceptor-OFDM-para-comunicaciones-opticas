clc; close all; clear all;
%%
indice_figuras=1;

%ILA_data_Tx=readtable("Comp_Espectro/Tx/iladata/waveform.csv");
%Tx_Q=table2array(ILA_data_Tx(:,4:11)).* 2^(-15);Tx_Q=Tx_Q'; Tx_Q=Tx_Q(:)';
%Tx_valid=table2array(ILA_data_Tx(:,20));Tx_valid=Tx_valid';
%Tx_I=table2array(ILA_data_Tx(:,12:19)).* 2^(-15);Tx_I=Tx_I'; Tx_I=Tx_I(:)';

ILA_data_Rx_NoCal=readtable("Comp_Espectro/Rx_NoCal/iladata/waveform.csv"); 
Rx_NoCal_I=table2array(ILA_data_Rx_NoCal(:,4:11)).* 2^(-15);Rx_NoCal_I=Rx_NoCal_I'; Rx_NoCal_I=Rx_NoCal_I(:)';
Rx_NoCal_Q=table2array(ILA_data_Rx_NoCal(:,13:20)).* 2^(-15);Rx_NoCal_Q=Rx_NoCal_Q'; Rx_NoCal_Q=Rx_NoCal_Q(:)';
Rx_NoCal_valid=table2array(ILA_data_Rx_NoCal(:,12));Rx_NoCal_valid=Rx_NoCal_valid';


ILA_data_Rx_Cal=readtable("Comp_Espectro/Rx_Cal/iladata/waveform.csv"); 
Rx_Cal_I=table2array(ILA_data_Rx_Cal(:,4:11)).* 2^(-15);Rx_Cal_I=Rx_Cal_I'; Rx_Cal_I=Rx_Cal_I(:)';
Rx_Cal_Q=table2array(ILA_data_Rx_Cal(:,13:20)).* 2^(-15);Rx_Cal_Q=Rx_Cal_Q'; Rx_Cal_Q=Rx_Cal_Q(:)';
Rx_Cal_valid=table2array(ILA_data_Rx_Cal(:,12));Rx_Cal_valid=Rx_Cal_valid';



limite_inf=50; limite_sup=400;
figure(indice_figuras)
subplot(3,1,1); plot([limite_inf:1/8:limite_sup-1/8],Tx_I(limite_inf*8:limite_sup*8-1)), title('Frame Rx real');
subplot(3,1,2); plot([limite_inf:1/8:limite_sup-1/8],Tx_Q(limite_inf*8:limite_sup*8-1)), title('Frame Rx imag');
subplot(3,1,3); plot([limite_inf:limite_sup],Tx_valid(limite_inf:limite_sup)), title('Frame Rx Valid');
indice_figuras=indice_figuras+1;

limite_inf=50; limite_sup=100;
figure(indice_figuras)
subplot(3,1,1); plot([limite_inf:1/8:limite_sup-1/8],Rx_NoCal_I(limite_inf*8:limite_sup*8-1)), title('Frame Rx real');
subplot(3,1,2); plot([limite_inf:1/8:limite_sup-1/8],Rx_NoCal_Q(limite_inf*8:limite_sup*8-1)), title('Frame Rx imag');
subplot(3,1,3); plot([limite_inf:limite_sup],Rx_NoCal_valid(limite_inf:limite_sup)), title('Frame Rx Valid');
indice_figuras=indice_figuras+1;

%% Espectro de los 3 (Real e Imaginario)
Nfft = 1024; fsamp=2*10^9;
[P_Tx_I,fin_Tx_I] = pwelch(Tx_I, gausswin(Nfft), Nfft/2, Nfft,fsamp);
[P_Tx_Q,fin_Tx_Q] = pwelch(Tx_Q, gausswin(Nfft), Nfft/2, Nfft,fsamp);

[P_Rx_NoCal_I,fin_Rx_NoCal_I] = pwelch(Rx_NoCal_I, gausswin(Nfft), Nfft/2, Nfft,fsamp);
[P_Rx_NoCal_Q,fin_Rx_NoCal_Q] = pwelch(Rx_NoCal_Q, gausswin(Nfft), Nfft/2, Nfft,fsamp);

[P_Rx_Cal_I,fin_Rx_Cal_I] = pwelch(Rx_Cal_I, gausswin(Nfft), Nfft/2, Nfft,fsamp);
[P_Rx_Cal_Q,fin_Rx_Cal_Q] = pwelch(Rx_Cal_Q, gausswin(Nfft), Nfft/2, Nfft,fsamp);


figure(indice_figuras)
subplot(3,1,1); plot(fin_Tx_I,10.*log10(P_Tx_I)), title('Espectro Tx I');
subplot(3,1,2); plot(fin_Rx_NoCal_I,10*log10(P_Rx_NoCal_I)), title('Espectro Rx No Calibración I');
subplot(3,1,3); plot(fin_Rx_Cal_I,10*log10(P_Rx_Cal_I)), title('Espectro Rx Calibración I');
indice_figuras=indice_figuras+1;

figure(indice_figuras)
subplot(3,1,1); plot(fin_Tx_Q,10.*log10(P_Tx_Q)), title('Espectro Tx Q');
subplot(3,1,2); plot(fin_Rx_NoCal_Q,10*log10(P_Rx_NoCal_Q)), title('Espectro Rx No Calibración Q');
subplot(3,1,3); plot(fin_Rx_Cal_Q,10*log10(P_Rx_Cal_Q)), title('Espectro Rx Calibración Q');
indice_figuras=indice_figuras+1;


%% Normalización y Diferencia 
prueba = 0;
if prueba==1
    offsets= [0.00292682647705078 -0.00336503982543945 0.000178575515747070 ...
        0.00473940372467041 -0.00257539749145508 -0.000822544097900391 ...
        0.000622153282165527 -0.000930666923522949];
    offsets_aux=offsets;
    
    gains=[0.0646860195892747 0.0954118878482761 0.140583596991671 ...
        0.114573594753194 0.0655458042764321 0.0609336596934456 0.0628533030107459 ...
        0.0616103939576442];
    gains_aux=gains;
    ganancia_objetivo = mean(gains);
    for l=1:1023
        offsets=[offsets offsets_aux];
        gains=[gains gains_aux];
    end
    Tx_I=(Tx_I-offsets) .* ganancia_objetivo./gains;
end

Tx_I_norm=Tx_I./(max(Tx_I)-min(Tx_I));
Tx_Q_norm=Tx_Q./(max(Tx_Q)-min(Tx_Q));

Rx_NoCal_I_norm=Rx_NoCal_I./(max(Rx_NoCal_I)-min(Rx_NoCal_I));
Rx_NoCal_Q_norm=Rx_NoCal_Q./(max(Rx_NoCal_Q)-min(Rx_NoCal_Q));

Rx_Cal_I_norm=Rx_Cal_I./(max(Rx_Cal_I)-min(Rx_Cal_I));
Rx_Cal_Q_norm=Rx_Cal_Q./(max(Rx_Cal_Q)-min(Rx_Cal_Q));

% No Cal
limite_inf=300; limite_sup=500; 
desfase=-309;
diff_I_NoCal=Tx_I_norm(limite_inf*8:limite_sup*8-1)-Rx_NoCal_I_norm(limite_inf*8+desfase:limite_sup*8-1+desfase);

figure(indice_figuras)
subplot(3,1,1); plot([limite_inf:1/8:limite_sup-1/8],Tx_I_norm(limite_inf*8:limite_sup*8-1)), title('Tx I');
subplot(3,1,2); plot([limite_inf:1/8:limite_sup-1/8],Rx_NoCal_I_norm(limite_inf*8+desfase:limite_sup*8-1+desfase)), title('Rx No Cal');
subplot(3,1,3); plot([limite_inf:1/8:limite_sup-1/8],diff_I_NoCal), title('Diff No Cal');
indice_figuras=indice_figuras+1;

desfase=desfase-1;

diff_Q_NoCal=Tx_Q_norm(limite_inf*8:limite_sup*8-1)-Rx_NoCal_Q_norm(limite_inf*8+desfase:limite_sup*8-1+desfase);

figure(indice_figuras)
subplot(3,1,1); plot([limite_inf:1/8:limite_sup-1/8],Tx_Q_norm(limite_inf*8:limite_sup*8-1)), title('Tx Q');
subplot(3,1,2); plot([limite_inf:1/8:limite_sup-1/8],Rx_NoCal_Q_norm(limite_inf*8+desfase:limite_sup*8-1+desfase)), title('Rx No Cal');
subplot(3,1,3); plot([limite_inf:1/8:limite_sup-1/8],diff_Q_NoCal), title('Diff No Cal');
indice_figuras=indice_figuras+1;
%%
% Cal
limite_inf=50; limite_sup=400;

desfase=771;
diff_I_Cal=Tx_I_norm(limite_inf*8:limite_sup*8-1)-Rx_Cal_I_norm(limite_inf*8+desfase:limite_sup*8-1+desfase);

figure(indice_figuras)
subplot(3,1,1); plot([limite_inf:1/8:limite_sup-1/8],Tx_I_norm(limite_inf*8:limite_sup*8-1)), title('Tx I');
subplot(3,1,2); plot([limite_inf:1/8:limite_sup-1/8],Rx_Cal_I_norm(limite_inf*8+desfase:limite_sup*8-1+desfase)), title('Rx Cal');
subplot(3,1,3); plot([limite_inf:1/8:limite_sup-1/8],diff_I_Cal), title('Diff Cal');
indice_figuras=indice_figuras+1;

desfase=desfase-1;
diff_Q_Cal=Tx_Q_norm(limite_inf*8:limite_sup*8-1)-Rx_Cal_Q_norm(limite_inf*8+desfase:limite_sup*8-1+desfase);

figure(indice_figuras)
subplot(3,1,1); plot([limite_inf:1/8:limite_sup-1/8],Tx_Q_norm(limite_inf*8:limite_sup*8-1)), title('Tx Q');
subplot(3,1,2); plot([limite_inf:1/8:limite_sup-1/8],Rx_Cal_Q_norm(limite_inf*8+desfase:limite_sup*8-1+desfase)), title('Rx Cal');
subplot(3,1,3); plot([limite_inf:1/8:limite_sup-1/8],diff_Q_Cal), title('Diff Cal');
indice_figuras=indice_figuras+1;


%% Espectro diferencia

Nfft = 1024; fsamp=2*10^9;
[P_diff_NoCal_I,fin_diff_NoCal_I] = pwelch(diff_I_NoCal, gausswin(Nfft), Nfft/2, Nfft,fsamp);
[P_diff_NoCal_Q,fin_diff_NoCal_Q] = pwelch(diff_Q_NoCal, gausswin(Nfft), Nfft/2, Nfft,fsamp);

[P_diff_Cal_I,fin_diff_Cal_I] = pwelch(diff_I_Cal, gausswin(Nfft), Nfft/2, Nfft,fsamp);
[P_diff_Cal_Q,fin_diff_Cal_Q] = pwelch(diff_Q_Cal, gausswin(Nfft), Nfft/2, Nfft,fsamp);

figure(indice_figuras)
subplot(2,2,1); plot(fin_diff_NoCal_I,10.*log10(P_diff_NoCal_I)), title('Espectro diferencia No Cal I');
subplot(2,2,2); plot(fin_diff_NoCal_Q,10*log10(P_diff_NoCal_Q)), title('Espectro diferencia No Cal Q');
subplot(2,2,3); plot(fin_diff_Cal_I,10*log10(P_diff_Cal_I)), title('Espectro diferencia Cal I');
subplot(2,2,4); plot(fin_diff_Cal_Q,10*log10(P_diff_Cal_Q)), title('Espectro diferencia Cal Q');
indice_figuras=indice_figuras+1;


figure(indice_figuras)
subplot(2,2,1); plot(fin_diff_NoCal_I,10.*log10(P_diff_NoCal_I)), title('Espectro diferencia No Cal I / Con No Cal I');
hold on; plot(fin_Rx_NoCal_I,10*log10(P_Rx_NoCal_I));
subplot(2,2,2); plot(fin_diff_NoCal_Q,10*log10(P_diff_NoCal_Q)), title('Espectro diferencia No Cal Q / Con No Cal Q');
hold on; plot(fin_Rx_NoCal_Q,10*log10(P_Rx_NoCal_Q));
subplot(2,2,3); plot(fin_diff_Cal_I,10*log10(P_diff_Cal_I)), title('Espectro diferencia Cal I / Con Cal I');
hold on; plot(fin_Rx_Cal_I,10*log10(P_Rx_Cal_I));
subplot(2,2,4); plot(fin_diff_Cal_Q,10*log10(P_diff_Cal_Q)), title('Espectro diferencia Cal Q / Con No Cal Q');
hold on; plot(fin_Rx_Cal_Q,10*log10(P_Rx_Cal_Q));
indice_figuras=indice_figuras+1;



%%
% Analiza solo la rama I (repite para Q)
ssr_width = 8;
%Rx_Cal_Q
data_reshaped = reshape(Tx_Q_norm(1:floor(length(Tx_Q_norm)/ssr_width)*ssr_width), ssr_width, []);
%Rx_Cal_I
% Verificar Offset Mismatch 
figure(indice_figuras) 
offsets = mean(data_reshaped, 2); 
subplot(2,1,1); bar(offsets); title('Offset por muestra SSR');


% Verificar Gain Mismatch 
gains = std(double(data_reshaped), 0, 2);
subplot(2,1,2); bar(gains); title('Ganancia por muestra SSR');
indice_figuras=indice_figuras+1;

%% 
% Configuración
ssr = 8; 
datos_I = Rx_Cal_I; % Tu vector de datos I
ventana = 100;    % Tamaño de la media móvil (ajusta según necesites suavizar)

% Reshape para separar los 8 canales (filas = canales, columnas = tiempo)
n_bloques = floor(length(datos_I) / ssr);
I_mat = reshape(datos_I(1:n_bloques*ssr), ssr, n_bloques);

% Calcular la Media Móvil para cada uno de los 8 canales
% Usamos movmean a lo largo de la dimensión 2 (columnas/tiempo)
medias_moviles = movmean(I_mat, ventana, 2);


figure;
t_eje = 1:n_bloques;
plot(t_eje, medias_moviles'); % Grafica las 8 líneas
grid on;
title('Media Móvil por Canal SSR (I)');
xlabel('Ciclos de Reloj (250 MHz)');
ylabel('Nivel de Offset (DC)');
legend('Muestra 1','Muestra 2','Muestra 3','Muestra 4',...
       'Muestra 5','Muestra 6','Muestra 7','Muestra 8');

% 5. Identificar el canal con el error de -0.028
media_final = mean(I_mat, 2); 
fprintf('Offsets detectados por canal:\n');
disp(media_final);
