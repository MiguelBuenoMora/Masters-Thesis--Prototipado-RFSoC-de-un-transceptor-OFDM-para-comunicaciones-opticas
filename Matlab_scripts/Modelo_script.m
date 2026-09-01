clc; close all; clear all;

%Este script de Matlab busca replicar el funcionamiento del modelo de Model
%Composer que se está utilizando. (Tx).
%El objetivo es que en cada etapa se puedan insertar los datos de la etapa
%anterior o los datos extraidos a partir de los ILAs y las pruebas en
%placa.


%Importante: se tratatran los datos cómo si se utilizara un modelo SSR=8,
%siendo cada columna de las matrices el vector SSR en un instante dado.

%variables para determinar si se quiere graficar una etapa en concreto
graficar.inic=0;
graficar.SP=0;
graficar.burst=0;
graficar.QPSK=1;
graficar.IWC=1;
graficar.Mod=0;
graficar.PC=0;
graficar.CF=0;

%%%%%%%% TX %%%%%%%%
init.SSR=8;
numero_figura=0;
%Generar bits
init.columnas=500;%24*20; %idealmente par y múltiplo de 6
init.cantidad_bits_iniciales=8*init.columnas;
init.bits_iniciales=randi(2,[1,init.cantidad_bits_iniciales])-1;
init.bits_iniciales=reshape(init.bits_iniciales,init.SSR,init.columnas); %coge los primeros 8 elementos del array y los pone como columna


init.bits_iniciales_fijos=[];
for i=1:init.columnas
    init.bits_iniciales_fijos=[init.bits_iniciales_fijos [1 1 0 0 1 1 0 0]];
end
init.bits_iniciales_fijos=reshape(init.bits_iniciales_fijos,init.SSR,init.columnas); 

%init.bits_siguiente_etapa=init.bits_iniciales;
init.bits_siguiente_etapa=init.bits_iniciales_fijos;
%init.bits_siguiente_etapa=load(); %para meter datos desde fuera (también habrá que comprobar el tamño de la matriz)
if graficar.inic
    numero_figura=numero_figura+1;
    figure(numero_figura)
    stem(init.bits_siguiente_etapa');
end
%% Serie a paralelo
SP.columnas=init.columnas/2; %columnas únicas, pero cada vector dura dos ciclos

SP.i_symbols=zeros(init.SSR,SP.columnas*2);
SP.q_symbols=zeros(init.SSR,SP.columnas*2);
SP.valid=[];
for i=0:(SP.columnas-1)
    SP.i_symbols(:,2*(i)+1)=init.bits_siguiente_etapa(:,(2*(i)+1));
    SP.i_symbols(:,2*(i)+2)=init.bits_siguiente_etapa(:,(2*(i)+1));

    SP.q_symbols(:,2*(i)+1)=init.bits_siguiente_etapa(:,(2*(i)+2));
    SP.q_symbols(:,2*(i)+2)=init.bits_siguiente_etapa(:,(2*(i)+2));

    SP.valid=[SP.valid [1 0]];
end

SP.i_siguiente=SP.i_symbols;
SP.q_siguiente=SP.q_symbols;
SP.valid_siguiente=SP.valid;

if graficar.SP
    numero_figura=numero_figura+1;
    figure(numero_figura)
    subplot(3,1,1),stem(SP.i_siguiente');  title("Serie/paralelo I (SSR)");
    subplot(3,1,2),stem(SP.q_siguiente'); title("Serie/paralelo Q (SSR)");
    subplot(3,1,3),stem(SP.valid_siguiente'); title("Serie/paralelo Valid (SSR)");
    
    SP.i_siguiente_array=SP.i_siguiente; SP.i_siguiente_array=SP.i_siguiente_array(:)';
    SP.q_siguiente_array=SP.q_siguiente; SP.q_siguiente_array=SP.q_siguiente_array(:)';
    
    SP.time=0:1/init.SSR:(size(SP.i_siguiente,2) - 1/init.SSR);
    SP.time_valid=0:(size(SP.i_siguiente,2) - 1);
    
    numero_figura=numero_figura+1;
    figure(numero_figura)
    subplot(3,1,1),stem(SP.time,SP.i_siguiente_array'); title("Serie/paralelo I (Desvectorizado)");
    subplot(3,1,2),stem(SP.time,SP.q_siguiente_array'); title("Serie/paralelo Q (Desvectorizado)");
    subplot(3,1,3),stem(SP.time_valid,SP.valid_siguiente');  title("Serie/paralelo Valid (Desvectorizado)");
end

%% Ráfaga de 48 bits y 1 T por vector, ráfaga de 6 T
[~,Burst.columnas]=size(SP.i_siguiente);
Burst.cantidad_rafagas=Burst.columnas/(6*2);

Burst.i_symbols=zeros(init.SSR,Burst.columnas);
Burst.q_symbols=zeros(init.SSR,Burst.columnas);
Burst.valid=zeros(1,Burst.columnas);
j=0; %cantidad de vectores añadidos
k=1; %indice de Burst.x_synbols
for i=1:Burst.columnas
    if (mod(i,2))~=0 % si es impar (ciclo con valid a 1)
        Burst.i_symbols(:,k)=SP.i_siguiente(:,i);
        Burst.q_symbols(:,k)=SP.q_siguiente(:,i);
        Burst.valid(k)=1;
        j=j+1;
        k=k+1;

        if (mod((j),6)) == 0 
            k=k+6;
        end
        
    end
end

Burst.i_siguiente=Burst.i_symbols;
Burst.q_siguiente=Burst.q_symbols;
Burst.valid_siguiente=Burst.valid;

if graficar.burst
    numero_figura=numero_figura+1;
    figure(numero_figura)
    subplot(3,1,1),stem(Burst.i_siguiente'); title("Ráfaga I (SSR)");
    subplot(3,1,2),stem(Burst.q_siguiente'); title("Ráfaga Q (SSR)");
    subplot(3,1,3),stem(Burst.valid_siguiente); title("Ráfaga Valid (SSR)");
    
    Burst.i_siguiente_array=Burst.i_siguiente; Burst.i_siguiente_array=Burst.i_siguiente_array(:)';
    Burst.q_siguiente_array=Burst.q_siguiente; Burst.q_siguiente_array=Burst.q_siguiente_array(:)';
    
    Burst.time=0:1/init.SSR:(size(Burst.i_siguiente,2) - 1/init.SSR);
    Burst.time_valid=0:(size(Burst.i_siguiente,2) - 1);
    
    numero_figura=numero_figura+1;
    figure(numero_figura)
    subplot(3,1,1),stem(Burst.time,Burst.i_siguiente_array'); title("Ráfaga I (Desvectorizado)");
    subplot(3,1,2),stem(Burst.time,Burst.q_siguiente_array'); title("Ráfaga Q (Desvectorizado)");
    subplot(3,1,3),stem(Burst.time_valid,Burst.valid_siguiente');  title("Ráfaga Valid (Desvectorizado)");
end

%% Mapeado QPSK
M_QPSK.amplitude=sqrt(3/13);
aux=size(Burst.i_siguiente); M_QPSK.columnas=aux(2);
aux=aux(1)*aux(2);

M_QPSK.i_symbols=Burst.i_siguiente;
M_QPSK.q_symbols=Burst.q_siguiente;
%Este bucle hace el mapeado
for i=1:aux
    if (M_QPSK.i_symbols(i)) == 1
        M_QPSK.i_symbols(i)=M_QPSK.amplitude;
    else
        M_QPSK.i_symbols(i)=-1*M_QPSK.amplitude;
    end

    if (M_QPSK.q_symbols(i)) == 1
        M_QPSK.q_symbols(i)=M_QPSK.amplitude;
    else
        M_QPSK.q_symbols(i)=-1*M_QPSK.amplitude;
    end
end

%Este bucle elimina los ciclos dónde el valid está a 0
for i=1:M_QPSK.columnas
    if Burst.valid_siguiente(i) == 0
        M_QPSK.i_symbols(:,i)=zeros(8,1);
        M_QPSK.q_symbols(:,i)=zeros(8,1);
    end
end

M_QPSK.i_siguiente=M_QPSK.i_symbols;
M_QPSK.q_siguiente=M_QPSK.q_symbols;
M_QPSK.valid_siguiente=Burst.valid_siguiente;

if graficar.QPSK
    numero_figura=numero_figura+1;
    figure(numero_figura)
    subplot(3,1,1),stem(M_QPSK.i_siguiente'); title("QPSK I (SSR)");
    subplot(3,1,2),stem(M_QPSK.q_siguiente'); title("QPSK Q (SSR)");
    subplot(3,1,3),stem(M_QPSK.valid_siguiente); title("QPSK Valid (SSR)");
    
    M_QPSK.i_siguiente_array=M_QPSK.i_siguiente; M_QPSK.i_siguiente_array=M_QPSK.i_siguiente_array(:)';
    M_QPSK.q_siguiente_array=M_QPSK.q_siguiente; M_QPSK.q_siguiente_array=M_QPSK.q_siguiente_array(:)';
    
    M_QPSK.time=0:1/init.SSR:(size(M_QPSK.i_siguiente,2) - 1/init.SSR);
    M_QPSK.time_valid=0:(size(M_QPSK.i_siguiente,2) - 1);
    
    numero_figura=numero_figura+1;
    figure(numero_figura)
    subplot(3,1,1),stem(M_QPSK.time,M_QPSK.i_siguiente_array'); title("QPSK I (Desvectorizado)");
    subplot(3,1,2),stem(M_QPSK.time,M_QPSK.q_siguiente_array'); title("QPSK Q (Desvectorizado)");
    subplot(3,1,3),stem(M_QPSK.time_valid,M_QPSK.valid_siguiente');  title("QPSK Valid (Desvectorizado)");
end

%% IFFT window construction (IWC)
contador_ciclos=0;
[~,IWC.columnas]=size(M_QPSK.i_siguiente);
IWC.valid=M_QPSK.valid_siguiente;

IWC.i_symbols=M_QPSK.i_siguiente;
IWC.q_symbols=M_QPSK.q_siguiente;

i=1;
while i < (IWC.columnas+1)
    if IWC.valid(i) == 1
        contador_ciclos=contador_ciclos+1;
    end
    
    if contador_ciclos == 6
        %IFFT shift
        IWC.burst_i_buffer=[IWC.i_symbols(:,i-2)' IWC.i_symbols(:,i-1)' IWC.i_symbols(:,i)'...
            IWC.i_symbols(:,i-5)' IWC.i_symbols(:,i-4)' IWC.i_symbols(:,i-3)'];
        IWC.burst_q_buffer=[IWC.q_symbols(:,i-2)' IWC.q_symbols(:,i-1)' IWC.q_symbols(:,i)'...
            IWC.q_symbols(:,i-5)' IWC.q_symbols(:,i-4)' IWC.q_symbols(:,i-3)'];
        %IFFT Window Construction
        IWC.burst_i_aux=[0  IWC.burst_i_buffer(1:24) zeros(1,15)  IWC.burst_i_buffer(25:48)];
        IWC.burst_q_aux=[0  IWC.burst_q_buffer(1:24) zeros(1,15)  IWC.burst_q_buffer(25:48)];

        IWC.burst_i_aux=reshape(IWC.burst_i_aux,init.SSR,8); %coge los primeros 8 elementos del array y los pone como filas
        IWC.burst_q_aux=reshape(IWC.burst_q_aux,init.SSR,8); 

        IWC.i_symbols(:,(i-5):(i+2))=IWC.burst_i_aux;
        IWC.q_symbols(:,(i-5):(i+2))=IWC.burst_q_aux;
        IWC.valid(i+1)=1; IWC.valid(i+2)=1; %extension de valid
        i=i+2;
        contador_ciclos=0;
    end
    
    i=i+1;
end

IWC.i_siguiente=IWC.i_symbols;
IWC.q_siguiente=IWC.q_symbols;
IWC.valid_siguiente=IWC.valid;

if graficar.IWC
    numero_figura=numero_figura+1;
    figure(numero_figura)
    subplot(3,1,1),stem(IWC.i_siguiente'); title("Window I (SSR)");
    subplot(3,1,2),stem(IWC.q_siguiente'); title("Window Q (SSR)");
    subplot(3,1,3),stem(IWC.valid_siguiente); title("Window I (SSR)");
    
    IWC.i_siguiente_array=IWC.i_siguiente; IWC.i_siguiente_array=IWC.i_siguiente_array(:)';
    IWC.q_siguiente_array=IWC.q_siguiente; IWC.q_siguiente_array=IWC.q_siguiente_array(:)';
    
    IWC.time=0:1/init.SSR:(size(IWC.i_siguiente,2) - 1/init.SSR);
    IWC.time_valid=0:(size(IWC.i_siguiente,2) - 1);
    
    numero_figura=numero_figura+1;
    figure(numero_figura)
    subplot(3,1,1),stem(IWC.time,IWC.i_siguiente_array'); title("Window I (Desvectorizado)");
    subplot(3,1,2),stem(IWC.time,IWC.q_siguiente_array'); title("Window Q (Desvectorizado)");
    subplot(3,1,3),stem(IWC.time_valid,IWC.valid_siguiente');  title("Window Valid (Desvectorizado)");
end

%% Modulación (IFFT)
contador_ciclos=0;
[~,Mod.columnas]=size(IWC.i_siguiente);
Mod.valid=IWC.valid_siguiente;

Mod.i_symbols=IWC.i_siguiente;
Mod.q_symbols=IWC.q_siguiente;

i=1;
while i < Mod.columnas
    if Mod.valid(i) == 1
        contador_ciclos=contador_ciclos+1;
    end

    if contador_ciclos == 8
        Mod.burst_aux_i=[Mod.i_symbols(:,i-7)' Mod.i_symbols(:,i-6)' Mod.i_symbols(:,i-5)' ...
            Mod.i_symbols(:,i-4)' Mod.i_symbols(:,i-3)' Mod.i_symbols(:,i-2)' ...
            Mod.i_symbols(:,i-1)' Mod.i_symbols(:,i)' ];

        Mod.burst_aux_q=[Mod.q_symbols(:,i-7)' Mod.q_symbols(:,i-6)' Mod.q_symbols(:,i-5)' ...
            Mod.q_symbols(:,i-4)' Mod.q_symbols(:,i-3)' Mod.q_symbols(:,i-2)' ...
            Mod.q_symbols(:,i-1)' Mod.q_symbols(:,i)' ];

        %no hace falta dividir por 64
        Mod.burst_aux=ifft(complex(Mod.burst_aux_i,Mod.burst_aux_q),64);
        
        Mod.burst_aux_i=real(Mod.burst_aux);
        Mod.burst_aux_q=imag(Mod.burst_aux);

        Mod.burst_aux_i=reshape(Mod.burst_aux_i,init.SSR,8); %coge los primeros 8 elementos del array y los pone como 8 filas
        Mod.burst_aux_q=reshape(Mod.burst_aux_q,init.SSR,8); 

        Mod.i_symbols(:,(i-7):(i))=Mod.burst_aux_i;
        Mod.q_symbols(:,(i-7):(i))=Mod.burst_aux_q;

        contador_ciclos=0;
    end

    i=i+1;
end


Mod.i_siguiente=Mod.i_symbols;
Mod.q_siguiente=Mod.q_symbols;
Mod.valid_siguiente=Mod.valid;

if graficar.Mod
    numero_figura=numero_figura+1;
    figure(numero_figura)
    subplot(3,1,1),plot(Mod.i_siguiente'); title("Mod I (SSR)");
    subplot(3,1,2),plot(Mod.q_siguiente'); title("Mod Q (SSR)");
    subplot(3,1,3),plot(Mod.valid_siguiente); title("Mod Valid (SSR)");
    
    Mod.i_siguiente_array=Mod.i_siguiente; Mod.i_siguiente_array=Mod.i_siguiente_array(:)';
    Mod.q_siguiente_array=Mod.q_siguiente; Mod.q_siguiente_array=Mod.q_siguiente_array(:)';
    
    Mod.time=0:1/init.SSR:(size(Mod.i_siguiente,2) - 1/init.SSR);
    Mod.time_valid=0:(size(Mod.i_siguiente,2) - 1);
    
    numero_figura=numero_figura+1;
    figure(numero_figura)
    subplot(3,1,1),plot(Mod.time,Mod.i_siguiente_array'); title("Mod I (Desvectorizado)");
    subplot(3,1,2),plot(Mod.time,Mod.q_siguiente_array'); title("Mod Q (Desvectorizado)");
    subplot(3,1,3),plot(Mod.time_valid,Mod.valid_siguiente');  title("Mod Valid (Desvectorizado)");
end

%entradas de la funcion extraer
path='Tx_post_mod/iladata/waveform.csv';
plotear=1;SSR_o_serializado=2;
punto_inicio=1;punto_final=init.columnas;
cantidad_columnas=[8 8 1];
precision=[[18;16] , [18;16] , [1;0]]; 
numero_figura=numero_figura+1;
variables.rafaga_I=[];variables.rafaga_q=[];variables.valid=[];

[variables , variables_array, numero_figura] = extraer_y_plotear(path,plotear,SSR_o_serializado...
    ,numero_figura,punto_inicio,punto_final,cantidad_columnas...
    ,precision,variables);

%[senal_out] = extraer_valid(senal, valid, tamano_rafaga);


%% Prefijo Cíclico
contador_ciclos=0;
[~,PC.columnas]=size(Mod.i_siguiente);
PC.valid=Mod.valid_siguiente;

PC.i_symbols=Mod.i_siguiente;
PC.q_symbols=Mod.q_siguiente;


i=1;
while i < PC.columnas
    if PC.valid(i) == 1
        contador_ciclos=contador_ciclos+1;
    end

    if contador_ciclos == 8
        PC.burst_aux_i=[PC.i_symbols(:,i-7)' PC.i_symbols(:,i-6)' PC.i_symbols(:,i-5)' ...
            PC.i_symbols(:,i-4)' PC.i_symbols(:,i-3)' PC.i_symbols(:,i-2)' ...
            PC.i_symbols(:,i-1)' PC.i_symbols(:,i)' ...
            PC.i_symbols(:,i-7)' PC.i_symbols(:,i-6)' ]; %prefijo cíclico

        PC.burst_aux_q=[PC.q_symbols(:,i-7)' PC.q_symbols(:,i-6)' PC.q_symbols(:,i-5)' ...
            PC.q_symbols(:,i-4)' PC.q_symbols(:,i-3)' PC.q_symbols(:,i-2)' ...
            PC.q_symbols(:,i-1)' PC.q_symbols(:,i)' ...
            PC.q_symbols(:,i-7)' PC.q_symbols(:,i-6)' ]; %prefijo cíclico

        PC.burst_aux_i=reshape(PC.burst_aux_i,init.SSR,10); %coge los primeros 8 elementos del array y los pone como 8 filas
        PC.burst_aux_q=reshape(PC.burst_aux_q,init.SSR,10); 

        PC.i_symbols(:,(i-7):(i+2))=PC.burst_aux_i;
        PC.q_symbols(:,(i-7):(i+2))=PC.burst_aux_q;


        PC.valid(i+1)=1;PC.valid(i+2)=1;
         i=i+2;

        contador_ciclos=0;
    end

    i=i+1;
end

PC.i_siguiente=PC.i_symbols;
PC.q_siguiente=PC.q_symbols;
PC.valid_siguiente=PC.valid;

if graficar.PC
    numero_figura=numero_figura+1;
    figure(numero_figura)
    subplot(3,1,1),stem(PC.i_siguiente'); title("PC I (SSR)");
    subplot(3,1,2),stem(PC.q_siguiente'); title("PC Q (SSR)");
    subplot(3,1,3),stem(PC.valid_siguiente); title("PC Valid (SSR)");
    
    PC.i_siguiente_array=PC.i_siguiente; PC.i_siguiente_array=PC.i_siguiente_array(:)';
    PC.q_siguiente_array=PC.q_siguiente; PC.q_siguiente_array=PC.q_siguiente_array(:)';
    
    PC.time=0:1/init.SSR:(size(PC.i_siguiente,2) - 1/init.SSR);
    PC.time_valid=0:(size(PC.i_siguiente,2) - 1);
    
    numero_figura=numero_figura+1;
    figure(numero_figura)
    subplot(3,1,1),stem(PC.time,PC.i_siguiente_array'); title("PC I (Desvectorizado)");
    subplot(3,1,2),stem(PC.time,PC.q_siguiente_array'); title("PC Q (Desvectorizado)");
    subplot(3,1,3),stem(PC.time_valid,PC.valid_siguiente');  title("PC Valid (Desvectorizado)");
end

%% Construcción del Frame (CF)
contador_ciclos=0;
contador_simbolos_OFDM=0;

[~,CF.columnas]=size(PC.i_siguiente);
CF.valid=PC.valid_siguiente;

CF.i_symbols=PC.i_siguiente;
CF.q_symbols=PC.q_siguiente;

aux=load('preambulo.mat'); %CF.preambulo
CF.preambulo=aux.preambulo; %si no hago lo del aux no me lo coge bien no sé por qué
CF.preambulo_real=real(CF.preambulo);
CF.preambulo_imag=imag(CF.preambulo);

CF.simbolos_por_frame=20;
CF.longitud_simbolos=10; %en ciclos

CF.buffer_simbolos_i=[];
CF.buffer_simbolos_q=[];

CF.senal_i=[];
CF.senal_q  =[];

i=1;
while i < CF.columnas
    if CF.valid(i) == 1
        contador_ciclos=contador_ciclos+1;
    end

    if contador_ciclos == 10
        CF.buffer_simbolos_i=[CF.buffer_simbolos_i...
            CF.i_symbols(:,i-9)' CF.i_symbols(:,i-8)' CF.i_symbols(:,i-7)' ...
            CF.i_symbols(:,i-6)' CF.i_symbols(:,i-5)' CF.i_symbols(:,i-4)' ...
            CF.i_symbols(:,i-3)' CF.i_symbols(:,i-2)' ...
            CF.i_symbols(:,i-1)' CF.i_symbols(:,i)'];

         CF.buffer_simbolos_q=[CF.buffer_simbolos_q...
            CF.q_symbols(:,i-9)' CF.q_symbols(:,i-8)' CF.q_symbols(:,i-7)' ...
            CF.q_symbols(:,i-6)' CF.q_symbols(:,i-5)' CF.q_symbols(:,i-4)' ...
            CF.q_symbols(:,i-3)' CF.q_symbols(:,i-2)' ...
            CF.q_symbols(:,i-1)' CF.q_symbols(:,i)'];
        
        contador_simbolos_OFDM=contador_simbolos_OFDM+1;
        contador_ciclos=0;
    end

    if contador_simbolos_OFDM == 20
        CF.senal_i=[CF.senal_i...
            CF.preambulo_real...
            CF.buffer_simbolos_i];
    
        CF.senal_q=[CF.senal_q...
            CF.preambulo_imag...
            CF.buffer_simbolos_q];
        
        CF.buffer_simbolos_i=[];
        CF.buffer_simbolos_q=[];
        contador_simbolos_OFDM=0;
    end

    i=i+1;

    if (i == CF.columnas) && (contador_simbolos_OFDM < 20) %si no quedan más simbolos que añadir
        [~,CF.long_ultimo_frame] = size( CF.buffer_simbolos_i);
        CF.long_padding=(CF.simbolos_por_frame * CF.longitud_simbolos * init.SSR) - CF.long_ultimo_frame;
        
        CF.buffer_simbolos_i=[CF.buffer_simbolos_i zeros(1,CF.long_padding)];
        CF.buffer_simbolos_q=[CF.buffer_simbolos_q zeros(1,CF.long_padding)];

        CF.senal_i=[CF.senal_i...
            CF.preambulo_real...
            CF.buffer_simbolos_i];
    
        CF.senal_q=[CF.senal_q...
            CF.preambulo_imag...
            CF.buffer_simbolos_q];

    end

end

CF.senal_i=reshape(CF.senal_i , init.SSR , size(CF.senal_i,2) / init.SSR); %coge los primeros 8 elementos del array y los pone como 8 filas
CF.senal_q=reshape(CF.senal_q , init.SSR , size(CF.senal_q,2) / init.SSR); 

CF.i_siguiente=CF.senal_i;
CF.q_siguiente=CF.senal_q;

if graficar.CF
    numero_figura=numero_figura+1;
    figure(numero_figura)
    subplot(2,1,1),stem(CF.i_siguiente'); title("FRAME I (SSR)");
    subplot(2,1,2),stem(CF.q_siguiente'); title("FRAME Q (SSR)");
    
    CF.i_siguiente_array=CF.i_siguiente; CF.i_siguiente_array=CF.i_siguiente_array(:)';
    CF.q_siguiente_array=CF.q_siguiente; CF.q_siguiente_array=CF.q_siguiente_array(:)';
    
    CF.time=0:1/init.SSR:(size(CF.i_siguiente,2) - 1/init.SSR);
    CF.time_valid=0:(size(CF.i_siguiente,2) - 1);
    
    numero_figura=numero_figura+1;
    figure(numero_figura)
    subplot(2,1,1),stem(CF.time,CF.i_siguiente_array'); title("FRAME I (Desvectorizado)");
    subplot(2,1,2),stem(CF.time,CF.q_siguiente_array'); title("FRAME Q (Desvectorizado)");
end





%%%%Comparacion

ILA_samples_I=readtable("TX_samples/TX_I_samples/iladata/waveform.csv");
ILA_samples_Q=readtable("TX_samples/TX_Q_samples/iladata/waveform.csv");

samples_I=table2array(ILA_samples_I(:,4:11)).* 2^(-15);samples_I=samples_I'; samples_I=samples_I(:)';
samples_I_valid=table2array(ILA_samples_I(:,12))';

samples_Q=table2array(ILA_samples_Q(:,4:11)).* 2^(-15);samples_Q=samples_Q'; samples_Q=samples_Q(:)';
samples_Q_valid=table2array(ILA_samples_Q(:,12))';

limite=2000;
subplot(2,1,1); plot([0:1/8:limite/8-1/8],samples_I(1:limite)), title('samples_I');
subplot(2,1,2); plot(samples_I_valid(1:limite/8)), title('samples_I_valid');

first_value=find((samples_I >= (0.0312*0.99)) & (samples_I <= (0.0312*1.01)));

%diff=samples_I(first_value(1,1):(first_value(1,1)+2999)) - CF.i_siguiente_array(1:3000);
diff=zeros(1,10);

numero_figura=numero_figura+1;
figure(numero_figura)
subplot(3,1,1),stem(CF.i_siguiente_array(1:3000)); title("Frame I Matlab");
subplot(3,1,2),stem(samples_Q(first_value(1,1)+1000:(first_value(1,1)+2999-1400))); title("Frame I Vivado");    
subplot(3,1,3),stem(diff); title("Diff");    


variables=[];
init.columnas=300;
path='slices_Rx/1/iladata/waveform.csv';
plotear=1;SSR_o_serializado=2;
punto_inicio=150;punto_final=init.columnas;
cantidad_columnas=[8];
precision=[[16;15]]; 
numero_figura=numero_figura+1;
variables.primer_ILA=[];

[variables , variables_array, numero_figura] = extraer_y_plotear(path,plotear,SSR_o_serializado...
    ,numero_figura,punto_inicio,punto_final,cantidad_columnas...
    ,precision,variables);

variables=[];
init.columnas=300;
path='slices_Rx/2/iladata/waveform.csv';
plotear=200;SSR_o_serializado=2;
punto_inicio=150;punto_final=init.columnas;
cantidad_columnas=[8];
precision=[[16;15]]; 
variables.segundo_ILA=[];

[variables , variables_array, numero_figura] = extraer_y_plotear(path,plotear,SSR_o_serializado...
    ,numero_figura,punto_inicio,punto_final,cantidad_columnas...
    ,precision,variables);
