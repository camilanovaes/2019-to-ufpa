function [ xmax, fmax, N, res ] = branch_and_bound(w, A, b)
  % Branch and Bound
  %
  % %%%%%%%%%%%%%%%%%
  %
  % Input:
  %   w -> vetor de n elementos com os coeficientes da função objetivo
  %   A -> matriz m x n que multiplica as variáveis nas desigualdades de restrições 
  %   b -> vetor de m elementos que indica as m restrições
  %
  % Outputs:
  %   xmax -> vetor x que maximiza a função alvo
  %   fmax -> o valor da função alvo no ponto máximo
  %   N    -> número de vezes que a função glpk foi executada
  %
  % %%%%%%%%%%%%%%%%%
  lb = zeros(1,length(w));
  ub = ones(1,length(w)) * inf;

  c = false;
  N = 1;

  [xmax, fmax] = lp(w, A, b, lb, ub);
  res(N).idx  = 0;
  res(N).fmax = fmax;
  res(N).xmax = xmax;
  res(N).lb   = lb;
  res(N).ub   = ub;

  % Go full right
  for i = 2:length(xmax) + 1
    [x_resp, x_i] = takeX(xmax);
    [ ub ]        = defineBound("left", x_resp, x_i, ub);
    [xmax, fmax]  = lp(w, A, b, lb, ub);

    N++;
  endfor
endfunction

function [ x_resp, x_i ]  = takeX(xmax)
  % Escolhe o próximo X a ser trabalhado. O X precisar ser o maior dentre
  % os não inteiros
  %
  % %%%%%%%%%%%%%%%%%
  %
  % Input:
  %   xmax   ->
  %
  % Outputs:
  %   x_resp ->
  %   x_i    ->
  %
  % %%%%%%%%%%%%%%%%%
  x_resp = 0;
  x_i    = 0;

  for i = 1:length(xmax)
    if (xmax(i) > x_resp) && (!isInt(xmax(i)))
      x_resp = xmax(i);
      x_i    = i;
    endif
  endfor
endfunction

function [ b_resp ] = defineBound (d, x_resp, x_i, b)
  % Define o novo limite superior ou inferior
  %
  % %%%%%%%%%%%%%%%%%
  %
  % Input:
  %   d      -> Direção na árvore. "left" ou "right".
  %   x_resp ->
  %   x_i    ->
  %   b      ->
  %
  % Outputs:
  %   b_resp ->
  %
  % %%%%%%%%%%%%%%%%%
  if (d == "left")
    % Upper bound
    ub_x   = ceil(x_resp) - 1;
    b_resp = b;
    b_resp(1, x_i) = ub_x;
  elseif (d == "right")
    % Lower bound
    lb_x   = ceil(x_resp);
    b_resp = b;
    b_resp(1, x_i) = lb_x;
  else
    error ("invalid argument");
  endif

endfunction

function [ res ] = isInt(x)
  % Verifica se a variável x é inteira
  %
  % %%%%%%%%%%%%%%%%%
  %
  % Input:
  %   x -> Variavel a ser avaliada
  %
  % Outputs:
  %   res -> 'true' se a variável for inteira, 'false' caso contrário
  %
  % %%%%%%%%%%%%%%%%%
  if (mod(x,1) == 0)
    res = true;
  else
    res = false;
  end
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
  ctype   = char(ones(1,length(b))*"U"); % Define o tipo de inequação: U : <=
  vartype = char(ones(1,length(f))*"C"); % Define o tipo das variaveis: C : Cont
  s       = -1;                          % Sense = -1 significa maximização

  param.msglev = 0;     % Não retorna mensagens de erros ou warnings
  param.itlim  = 1000;  % Limite de iterações

  [xmax, fmax, status, extra] = ...
      glpk (f, A, b, lb, ub, ctype, vartype, s, param);

endfunction