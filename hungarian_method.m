%%%% Funcao da Questao 3.2
%%
%%  Metodo Hungaro
%% 
%%  Equipe:
%%    - Camila Novaes
%%    - Felipe Reis
%%    - Masaaki Nakamura
%%%%

function [ X ] = hungarian_method(W)
  % Método Hungaro
  %
  % %%%%%%%%%%%%%%%%%
  %
  % Input:
  %   W -> matriz n x n com os custos wij
  %
  % Outputs:
  %   X -> matriz n x n com as associações entre os nós i e j
  %
  % %%%%%%%%%%%%%%%%%

  %% Pre-Passo
  % Padronizacao das matrizes inseridas na funcao para que todas possam
  % ser resolvidas pelo algorithm hungaro

  X = false(size(W));

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
  %% Passo 3
  % Cria um vetor para indicar todas as entradas com zero ao longo das
  % colunas e das linhas
  primeZ = false(n);
  coverColumn = any(starZ);

  if ~any(~coverColumn)
    break
  end

  coverRow = false(n,1);
  while 1
    %% Passo 4
    % Verifica se a solucao ja esta em um caso otimo. Caso contrario,
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
  
    %% Passo 5
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

  X(validRow,validCol) = starZ(1:nRows,1:nCols);

endfunction

