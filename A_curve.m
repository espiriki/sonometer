function [curva_A] = curva_A(frequencia)

    %Coeficientes da equação que gera a curva A
    coeff_1 = 12200^2 * frequencia .^ 4;
    coeff_2 = frequencia .^ 2 + 20.6 ^ 2;
    coeff_3 = frequencia .^ 2 + 107.7 ^ 2;
    coeff_4 = frequencia .^ 2 + 737.9 ^ 2;
    coeff_5 = frequencia .^ 2 + 12200 ^ 2;
    
    %Curva A em si (https://en.wikipedia.org/wiki/A-weighting)
    curva_A = (coeff_1) ./ ( (coeff_2) .* sqrt( (coeff_3) .* (coeff_4) ) .* (coeff_5) );
    curva_A = curva_A * 10 ^ (2/20);

    %Essa variável vai ser usada somente para plotar a curva e verificar
    %que a mesma está certa
    Curva_A_log = 2 + 20 * log10(curva_A);
    
    %Plotando a curva de ponderação A (A-weighting)
    figure();
    semilogx(frequencia,Curva_A_log);
    title('Curva A de ponderação');
    xlabel('Frequencia (Hz)');
    ylabel('Fator de atenuação (dB)');
    grid on;




end
