function [xmax, fmax, N] = branch_and_bound (w, A, b, lb=nan, ub=nan)
   % Branch and Bound
  %
  % %%%%%%%%%%%%%%%%%
  %
  % Input:
  %   w  -> vetor de n elementos com os coeficientes da função objetivo
  %   A  -> matriz m x n que multiplica as variáveis nas desigualdades 
  %         de restrições 
  %   b  -> vetor de m elementos que indica as m restrições
  %   lb -> limite inferior das variáveis x
  %   ub -> limite superior das variáveis x
  %
  % Outputs:
  %   xmax -> vetor x que maximiza a função alvo
  %   fmax -> o valor da função alvo no ponto máximo
  %   N    -> número de vezes que a função glpk foi executada
  %
  % %%%%%%%%%%%%%%%%%

  num_x    = length(w); % Quantidade de variaveis X
  flag_int = 1;         % Variável de controle
  N        = 1;
  
  % Se for 'nan', referente a primeira iteração, cria os vetores corretamente.
  if (isnan(lb) && isnan(ub))
    lb = zeros(num_x, 1);
    ub = inf*ones(num_x, 1);  
  endif

  % Roda a a função de programação linear
  [X, v] = lp (w, A, b, lb, ub);

  for i = 1:num_x
    % Se não for inteiro
    if ( (!isnan(v)) && (!~mod(X(i),1)) )
      flag_int = 0;
      x_val    = floor(X(i));
      x_index  = i;
    endif
  endfor

    % Se todos os elementos forem inteiros
    if (flag_int == 1)
      if (isnan(v))
        xmax = NA;
        N    = 1;
        fmax = -inf;
      else
        xmax = X;
        N    = 1;
        fmax = v;
      endif
    else
      lb1 = lb2 = lb;
      ub1 = ub2 = ub;

      lb1(x_index) = x_val + 1;
      ub2(x_index) = x_val;

      [xmax1, fmax1, N1] = branch_and_bound (w, A, b, lb1, ub1);
      [xmax2, fmax2, N2] = branch_and_bound (w, A, b, lb2, ub2);
      
      if (fmax1 > fmax2)
        xmax = xmax1;
        N    = N1+N2;
        fmax = fmax1;
      else
        xmax = xmax2;
        N    = N1+N2;
        fmax = fmax2;
      endif
    endif
    
    return;
endfunction

function [ xmax, fmax ] = lp (f, A, b, lb, ub)
  % Programação Linear
  %
  % %%%%%%%%%%%%%%%%%
  %
  % Input:
  %   f  -> vetor de n elementos com os coeficientes da função objetivo
  %   A  -> matriz m x n que multiplica as variáveis nas desigualdades de restrições
  %   b  -> vetor de m elementos que indica as m restrições
  %   lb ->
  %   ub ->
  %
  % Outputs:
  %   xmax -> vetor x que maximiza a função alvo
  %   fmax -> o valor da função alvo no ponto máximo
  %
  % %%%%%%%%%%%%%%%%%
  ctype   = char(ones(1,length(b))*"U"); % Define o tipo de inequação: U: <=
  vartype = char(ones(1,length(f))*"C"); % Define o tipo das variaveis: C: Cont
  s       = -1;                          % Sense = -1 significa maximização

  param.msglev = 0;     % Não retorna mensagens de erros ou warnings
  param.itlim  = 1000;  % Limite de iterações

  [xmax, fmax, status, extra] = ...
      glpk (f, A, b, lb, ub, ctype, vartype, s, param);

endfunction