% function [] = sonometro(sinal_analise_arquivo)

sinal_analise_arquivo = 'ruido.wav';

    pressao_referencia = 20e-6;
    close all;
    [sinal_calibracao, fs_calibracao]=audioread('sinal_94dB.wav');
    fs = fs_calibracao;

    valor_rms_sinal_calibracao = rms(sinal_calibracao);
    
    %Como sabemos que um sinal de 94dB equivale a uma pressão rms de 1 Pascal, a
    %sensibilidade do sistema é S = (valor_rms_sinal_calibracao / 1 pa) =
    %0.0094
    sensibilidade = rms(sinal_calibracao);

    %Analisando o sinal dado
    [sinal_analise, fs_analise] = audioread(sinal_analise_arquivo);
    
    %Divide o sinal a ser analisado pelo valor de calibração
    sinal_analise_calibrado = sinal_analise/sensibilidade;
    
    %Gerando o eixo do tempo do sinal a ser analisado
    eixo_x_tempo = 0 : 1/fs_analise : length(sinal_analise)/fs_analise;
    eixo_x_tempo = eixo_x_tempo(1:end-1);
    
    %Plotando o gráfico do sinal a ser analisado no tempo
    figure();
    plot(eixo_x_tempo,sinal_analise_calibrado);
    xlabel('Tempo (s)');
    ylabel('Pressão (Pa)');
    title('Sinal a ser analisado');
    axis tight;
    grid on;

    %Calculando o valor LEQ (em dB) do sinal a ser analisado
    valor_LEQ = 20 * log10(rms(sinal_analise_calibrado)/pressao_referencia);
    
    %Imprimindo no console
    fprintf( '\n');
    fprintf( '------------------------Sonômetro JCCF--------------------\n');
    fprintf( 'O valor LEQ do sinal passado como parâmetro é de %.2f dB\n', valor_LEQ);
    fprintf( '----------------------------------------------------------\n\n');

    %Gerando o espectro do sinal a ser analisado
    [valores_dB_espectro valores_lineares_espectro frequencias_espectro] = espectro(sinal_analise_calibrado,fs_analise,0);
 
    [Curva_A] = curva_A(frequencias_espectro);
      
    %Para podermos fazer a ifft do sinal, precisamos utilizar as frequências
    %negativas. Então precisamos "espelhar" a curva A para abranger essas
    %frequências
    curva_A_espelhada = [Curva_A Curva_A(end:-1:1)];

    %Realizando a FFT do sinal a ser analisado e multiplicando o espectro resultante pela
    %curva de ponderação
    fft_do_sinal = fft(sinal_analise_calibrado);
    espectro_sinal_analise_ponderado_curva_A = fft_do_sinal .* curva_A_espelhada';
      
    %Fazendo a IFFT do espectro ponderado pela curva A para obter o sinal ponderado no
    %tempo
    sinal_ponderado_curva_A_tempo = real(ifft(espectro_sinal_analise_ponderado_curva_A));
    
    %Plotando o sinal ponderado no tempo
    figure();
    plot(eixo_x_tempo,[sinal_ponderado_curva_A_tempo sinal_analise_calibrado]);
    title('Sinal antes e depois do A-weighting');
    xlabel('Tempo (s)');
    ylabel('Pressão (Pa)');
    
    %Calculando a energia do sinal ponderado
    energia_sinal_analise  = sinal_ponderado_curva_A_tempo .^ 2;
    
    %Plotando a energia do sinal ponderado pelo tempo
    figure();
    plot(eixo_x_tempo,energia_sinal_analise);
    title('Energia do sinal ponderado pela curva A - linear');
    xlabel('Tempo (s)');
    
    %Plotando a energia do sinal ponderado em dB pelo tempo
    figure();
    plot(eixo_x_tempo,10 * log10(energia_sinal_analise/pressao_referencia ^ 2));
    title('Energia do sinal ponderado pela curva A - dB');
    xlabel('Tempo (s)');
    
    %Função que calcula a curva do valor LAS
    media_temporal(energia_sinal_analise,eixo_x_tempo);
     
    %Calculando o espectro de terço de oitava do sinal ponderado
    espectro_terco = espectro_terco_oitava(espectro_sinal_analise_ponderado_curva_A, frequencias_espectro);    
    
    %Valores de frequencia utilizados para plotar o espectro de terco de
    %oitava
    valores_frequencia = [10 12 16 20 25 31.5 40 50 63 80 100 125 160 200 250 315 400 500 630 800 1000 1250 1600 2000 2500 3150 4000 5000 6300 8000 10000 12500 16000];
   
    %aplica uma compressão logaritimica para diminuir o range no eixo das
    %frequências e assim as barras do grafico não ficarem muito proximas umas das
    %outras nas baixas frequências
    xplot = (1.25).^(log10(valores_frequencia)); 
    xplot = xplot'; 
   
    espectro_terco = abs(espectro_terco);   
   
    figure();
    bar(xplot, espectro_terco,'BarWidth', 1);
    set(gca,'XTick', xplot); 
    set(gca,'XTickLabel', valores_frequencia);
      
     for i=1:numel(espectro_terco)
        text(xplot(i),espectro_terco(i),num2str(espectro_terco(i),'%0.2f'),...
                   'HorizontalAlignment','center',...
                   'VerticalAlignment','bottom')
     end
   
     title ('Espectro de terço de oitava');
     xlabel('Frequências (Hz)');
     ylabel('Magnitude (dB)');
     grid on;
   
% end
   


