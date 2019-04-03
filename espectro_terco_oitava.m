function [espectro] = espectro_terco_oitava (espectro_sinal_analise_ponderado_curva_A, frequencia)
    
    pressao_referencia=20e-6;

    %Preparando o espectro para o calculo
    X_ponderado = espectro_sinal_analise_ponderado_curva_A;
    X_ponderado = X_ponderado/length(X_ponderado);
    X_ponderado(end/2+1:end)= [];
    X_ponderado = X_ponderado * 2;%Teorema de Parseval

   
    %Encontra o valor de cada banda de oitava
    F_inferior = 8.85;
    for N = 1:33

		F_superior = 2 ^ (1/3) * F_inferior;

        %tmp é um vetor com valores que indicam a diferença (absoluta) de
        %todos os valores de frequência da FFT para o valor buscado (no caso o valor inferior
        %de frequencia da banda N)
        tmp = abs(frequencia - F_inferior);
        %idx vai conter o indíce do valor mais próximo, que é o indice da
        %menor diferença absoluta
        [idx idx] = min(tmp);
        
        %Isso serve para que um mesmo valor de amplitude de uma determinada
        %frequencia NÃO seja usada no cálculo do valor de 2 bandas diferentes
        if (N~=1)
            indice_frequencia_inferior_da_banda = idx + 1;
        else
            indice_frequencia_inferior_da_banda = idx;
        end
            
        %tmp é um vetor com valores que indicam a diferença (absoluta) de
        %todos os valores de frequência da FFT para o valor buscado (no
        %caso o valor superior da banda N)
        tmp = abs(frequencia - F_superior);
        %idx vai conter o indíce do valor mais próximo, que é o indice da
        %menor diferença absoluta
        [idx idx] = min(tmp);
        
        indice_frequencia_superior_da_banda = idx;
        
		%%Faz o calculo da amplitude rms e guarda o valor
		acc = 0;
		for j = indice_frequencia_inferior_da_banda:indice_frequencia_superior_da_banda

            % vem de Arms^2 = (A/sqrt(2))^2, como ta elevado ao quadrado fica Arms^2 =
            % A^2/2
			acc = acc + abs(X_ponderado(j)/sqrt(2))^2;
        end
       
		valor_da_banda = acc / pressao_referencia^2;
        
        valor_da_banda_dB = 10 * log10(valor_da_banda);
        
        espectro_terco_oitava(N) = valor_da_banda_dB;
        
        %Passa a proxima banda
		F_inferior = F_superior;
    end


    espectro = espectro_terco_oitava;


end