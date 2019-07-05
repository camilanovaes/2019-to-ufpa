%%%% Funcao da Questao 3.2
%%
%% Passos do metodo Hungaro
%%  1. Subtraia a menor entrada de cada linha de todas as entradas da mesma
%%     linha. Dessa forma, cada linha tera pelo menos uma entrada zero e todas
%%     as outras sao nao-negativas.
%%
%%  2. Subtraia a menor entrada de cada coluna de todas as entradas de mesma
%%     coluna. Dessa forma, cada coluna terao pelo menos uma entrada zero e todas
%%     as outras entradas sao nao-negativas.
%%
%%  3. Risque um traco ao longo de linhas e colunas de tal modo que todas as
%%     entradas zero da matriz-custo fiquem riscadas. Para isso, utilize um
%%     numero minimo de tracos.
%%
%%  4. Teste de otimizacao
%%     a. Se o numero miinimo de tracos necessarios para cobrir os zeros eh n,
%%        entao uma alocacao otima de zeros eh posssivel e encerramos o
%%        procedimento.
%%     b. Se o numero minimo de tracos necessarios para cobrir os zeros eh menor
%%        que n, entao ainda nao e possivel uma alocacao otima de zeros. Nesse
%%        caso vai para o passo 5.
%%
%%  5. Determine a menor entrada nao riscada por nenhum traco. Subtraia esta
%%     entrada de todas as entradas nao riscada e depois a some a todas as
%%     entradas riscadas tanto horizontais quanto verticalmente. Retorne ao
%%     passo 3.
%%
%% Referências:
%% - https://bri.ifsp.edu.br/portal2/phocadownload/2016/Matematica/TCC/2015/Utilizando%20o%20Mtodo%20Hngaro%20e%20o%20Matlab%20em%20Problemas%20de%20Alocao%20de%20Tarefas.pdf
%% - https://www.mathworks.com/matlabcentral/fileexchange/20328-munkres-assignment-algorithm
%%%%

function [assignment] = hungarian_method(W)

  %% Pre-Passo
  % Padronizacao das matrizes inseridas na funcao para que todas possam
  % ser resolvidas pelo algorithm hungaro

  assignment = false(size(W));
  cost = 0;

  W(W~=W)=Inf;
  validMat = W<Inf;
  validCol = any(validMat);
  validRow = any(validMat,2);

  nRows = sum(validRow);
  nCols = sum(validCol);
  n = max(nRows,nCols);

  if ~n
    return
  end

  dMat = zeros(n);
  dMat(1:nRows,1:nCols) = W(validRow,validCol);


  %% Passo 1 (referente as linhas)
  dMat = bsxfun(@minus, dMat, min(dMat,[],2));

  %% Passo 2 (referente as colunas)
  zP = ~dMat;
  starZ = false(n);

  while any(zP(:))
    [r,c]=find(zP,1);
    starZ(r,c)=true;
    zP(r,:)=false;
    zP(:,c)=false;
  end

while 1
  %% Passo 3 cria um vetor para indicar todas as entradas com zero ao longo das
  %% colunas e das linhas
  primeZ = false(n);
  coverColumn = any(starZ);

  if ~any(~coverColumn)
    break
  end

  coverRow = false(n,1);
  while 1
    % Passo 4 - verifica se a solucao ja esta em um caso otimo. Caso contrario,
    % vai para o passo 5
    zP(:) = false;
    zP(~coverRow,~coverColumn) = ~dMat(~coverRow,~coverColumn);
    Step = 5;
    while any(any(zP(~coverRow,~coverColumn)))
      [uZr,uZc] = find(zP,1);
      primeZ(uZr,uZc) = true;
      stz = starZ(uZr,:);
      if ~any(stz)
        Step = 0;
        break;
      end
      coverRow(uZr) = true;
      coverColumn(stz) = false;
      zP(uZr,:) = false;
      zP(~coverRow,stz) = ~dMat(~coverRow,stz);
    end
      if Step == 5
        %% Some o menor valor nao tracado em cada linha tracada, e a subtraia
        %% de cada coluna nao tracadaCom a menor entrada nao riscada, entao
        %% volte ao passo 3.
        M=dMat(~coverRow,~coverColumn);
        minval=min(min(M));
        if minval==inf
          return
        end
          dMat(coverRow,coverColumn)=dMat(coverRow,coverColumn)+minval;
          dMat(~coverRow,~coverColumn)=M-minval;
        else
          break
        end
    end
  %  Sei que essa ultima parte contribui no codigo, mas tenho minhas duvidas
  %  sobre ela.

  %**************************************************************************
  % STEP 5:
  %  Construct a series of alternating primed and starred zeros as
  %  follows:
  %  Let Z0 represent the uncovered primed zero found in Step 4.
  %  Let Z1 denote the starred zero in the column of Z0 (if any).
  %  Let Z2 denote the primed zero in the row of Z1 (there will always
  %  be one).  Continue until the series terminates at a primed zero
  %  that has no starred zero in its column.  Unstar each starred
  %  zero of the series, star each primed zero of the series, erase
  %  all primes and uncover every line in the matrix.  Return to Step 3.
  %**************************************************************************
    rowZ1 = starZ(:,uZc);
    starZ(uZr,uZc)=true;
      while any(rowZ1)
        starZ(rowZ1,uZc)=false;
        uZc = primeZ(rowZ1,:);
        uZr = rowZ1;
        rowZ1 = starZ(:,uZc);
        starZ(uZr,uZc)=true;
      end
  end

  % Cost of assignment
  assignment(validRow,validCol) = starZ(1:nRows,1:nCols);
  cost = sum(W(assignment));

endfunction

