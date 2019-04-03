function [] = media_temporal (energia_sinal_analise, eixo_x_tempo)

    fs=44100;
    pressao_referencia=20e-6;
    %Criando os coeficientes do filtro de média temporal com a curva x(t) = e^(-t/tau)
    tau = 1;
    alfa = exp(-1/(tau*fs));

    %Aplicando o filtro ao sinal de energia usando a relação
    % y[n] = energia[n] + alfa * energia[n-1]
    curva_LAS(1) = energia_sinal_analise(1);
    for i=2:length(energia_sinal_analise)
        curva_LAS(i) = energia_sinal_analise(i) + alfa * curva_LAS(i-1);
    end
   
   %Normalizando e pegando o valor em dB
   curva_LAS = sqrt(curva_LAS/fs);
   curva_LAS = 20 * log10(curva_LAS/pressao_referencia);
   
    %Plotando o valor LAS obtido pelo tempo
   figure();
   plot(eixo_x_tempo,curva_LAS); 
   title('Valor LAS');
   xlabel('Tempo (s)');
   ylabel('Nível (dB)')
   grid on;
   
   
   
end