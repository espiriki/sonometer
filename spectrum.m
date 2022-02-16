function [eixo_magnitude_dB eixo_magnitude_linear eixo_x_frequencia] = sonometro(sinal_analise, fs, booleano)

    %Fazendo a fft, seguindo as dicas passadas em aula
    X = fft(sinal_analise)/length(sinal_analise);
    X(end/2+1:end)= [];
    X = X * 2;%Parseval
    
    %Ajustando o eixo das frequencias
    eixo_x_frequencia = (0:length(X)-1)/length(X)*(fs/2);  

    %Criando o espectro em dB
    X_log = 20*log10(abs(X)/20e-6);
    
    if (booleano ~= 1)
        figure();
        semilogx(eixo_x_frequencia,X_log);
        grid on;
        xlabel('Frequencia (Hz)');
        ylabel('Magnitude (dB)'); 
        title('Espectro do sinal a ser analisado');
        axis tight
    end
    
    %Associando as saidas
    eixo_magnitude_dB = X_log;
    eixo_magnitude_linear = X;
    



end
