%%%% Função da Questão 2
%%
%%   Problema de Transporte
%%
%%%%

function [ x ] = transportation( W, s, d, verbose=false )
  % Problema de transporte
  %
  % %%%%%%%%%%%%%%%%%
  %
  % Input:
  %   W       -> matriz m x n com os custos wij
  %   s       -> vetor com a disponibilidade das m fontes
  %   d       -> vetor com a demanda dos n destinos
  %   verbose -> variável para debug. Se for verdadeiro, printa uma mensagem
  %              dizendo a qual problema de transporte a entrada pertence               
  %
  % Outputs:
  %   x -> matriz m x n com as unidades transportadas entre as fontes e
  %        os destinos
  %
  % %%%%%%%%%%%%%%%%%
 
  % Verificação do tipo de problema:
  %   - Balanceado: N_s == N_d
  %   - Desbalanceado: N_s < N_d
  %   - Desbalanceado: N_s > N_d
  if (sum(s) == sum(d))
    if (verbose)
      printf("Balanceado: Fonte = Demanda\n");
    endif
    
  elseif (sum(s) > sum(d))
    % No caso desbalanceado, onde a o total da fonte é maior que o total 
    % demandado, é adicionado uma demanda "dummy" para que o total da fonte 
    % e o total demandando fique balanceado. Dessa forma, o valor demandado 
    % do nó "dummy" será:
    %     d = sum(fonte) - sum(demanda)
    if (verbose)
      printf("Desbalanceado: Fonte > Demanda\n");
    endif
 
    W(:,end+1) = zeros(size(W,1),1);
    d(end+1)   = sum(s) - sum(d);
    
  elseif (sum(s) < sum(d))
    % No caso desbalanceado, onde a o total da fonte é menor que o total 
    % demandado, é adicionado uma fonte "dummy" para que o total da fonte 
    % e o total demandando fique balanceado. Dessa forma, o valor do nó 
    % "dummy" será:
    %     d = sum(demanda) - sum(fonte)
    if (verbose)
      printf("Desbalanceado: Fonte < Demanda\n");
    endif
    
    W(end+1,:) = zeros(1, size(W,2));
    s(end+1)   = sum(d) - sum(s);

  endif
  
  % Transformando a matriz de custos em um vetor
  W = W(:)';
  % Concatenando as restrições das disponibilidade das fontes com a demanda
  % dos detinos
  b = vertcat(s', d')';

  N_s = length(s); % Número de fontes
  N_d = length(d); % Número de destinos

  % Criação da matrix A baseado no número de fontes e destinos
  A = zeros(N_s + N_d, N_s*N_d);
  c = 0; % Variável de controle
  for i = 1:N_s
    A(i, 1+c:N_d+c) = 1;
    A(N_s+1:N_s+N_d, 1+c:i*N_d) = eye(N_d);
    c += N_d;
  endfor

  % Fazendo calculo do minimo usando programação linear
  lb = zeros(1,N_s*N_d);
  ub = [];
  [ xmax, fmax ] = lp (W, A, b, lb, ub);

  % Transformando vetor x em uma matrix m x n
  x = reshape(xmax, N_d, []).';

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

  ctype   = char(ones(1,length(b))*"S"); % Define o tipo de inequação: S : =
  vartype = char(ones(1,length(f))*"I"); % Define o tipo das variaveis: I : Int
  s       = 1;                           % Sense = 1 significa minimização

  param.msglev = 0;     % Não retorna mensagens de erros ou warnings
  param.itlim  = 1000;  % Limite de iterações

  [xmax, fmax, status, extra] = ...
      glpk (f, A, b, lb, ub, ctype, vartype, s, param);

endfunction