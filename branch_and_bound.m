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
  N        = 1;
  flag_int = 1;         % Variável de controle
  x_resp   = 0;         % Variável de controle

  % Se for 'nan', referente a primeira iteração, cria os vetores do limite
  % inferior e superior.
  if (isnan(lb) && isnan(ub))
    lb = zeros(num_x, 1);
    ub = inf*ones(num_x, 1);
  endif

  % Roda a a função de programação linear
  [X, v] = lp (w, A, b, lb, ub);

  for i = 1:num_x
    % Se não for inteiro
    if ( (!isnan(v)) && (!~mod(X(i),1)) )
      if (X(i) > x_resp)
        x_resp   = X(i);
        x_val    = floor(X(i));
        x_index  = i;
        flag_int = 0;
      endif
    endif
  endfor

    % Se todos os elementos forem inteiros
    if (flag_int == 1)
      if (isnan(v))
        % Se para uma dada restrição não houver resposta, uma vez que o problema
        % é de maximização, é atribuido o valor de '-inf' para o fmax para que
        % não haja problemas quando houver a comparação para pegar o maior
        % valor de fmax
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

      % Define os novos valores para o limite superior e inferior
      lb1(x_index) = x_val + 1;
      ub2(x_index) = x_val;

      % Roda a função branch_and_bound de forma recursiva para a esquerda 
      % (visualizando o problema como uma arvore) e posteriormente para a 
      % direita.
      [xmax2, fmax2, N2] = branch_and_bound (w, A, b, lb2, ub2); % Esquerda
      [xmax1, fmax1, N1] = branch_and_bound (w, A, b, lb1, ub1); % Direita

      % Pega o maior valor entre fmax1 e fmax2
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
  %   lb -> limite inferior das variaveis x
  %   ub -> limite superior das variaveis x
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