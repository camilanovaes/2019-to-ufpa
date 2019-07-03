%%%% Função da Questão 3.2
%%
%% Passos do método Húngaro
%%  1. Subtraia a menor entrada de cada linha de todas as entradas da mesma
%%     linha. Sessa forma, cada linha terá pelo menos uma entrada zero e todas
%%     as outras são não-negativas.
%%
%%  2. Subtraia a menor entrada de cada coluna de todas as entradas de mesma 
%%     coluna. Dessa forma, cada coluna terá pelo menos uma entrada zero e todas
%%     as outras entradas são não-negativas.       
%%
%%  3. Risque um traço ao longo de linhas e colunas de tal modo que todas as 
%%     entradas zero da matriz-custo fiquem riscadas. Para isso, utilize um 
%%     número mínimo de traços.
%%
%%  4. Teste de otimização
%%     a. Se o número mínimo de traços necessários paara cobrir os zeros é n,
%%        então uma alocação ótima de zeros é possível e encerramos o
%%        procedimento.
%%     b. Se o número mínimo de traços necessários para cobrir os zeros é menor
%%        que n, então ainda não é possível uma alocação ótima de zeros. Nesse
%%        caso vá para o passo 5.
%%
%%  5. Determine a menor entrada não riscada por nenhum traço. Subtraia esta
%%     entrada de todas as entradas não riscada e depois a some a todas as
%%     entradas riscadas tanto horizontais quanto verticalmente. Retorne ao
%%     passo 3.
%%
%% Referências:
%% - https://bri.ifsp.edu.br/portal2/phocadownload/2016/Matematica/TCC/2015/Utilizando%20o%20Mtodo%20Hngaro%20e%20o%20Matlab%20em%20Problemas%20de%20Alocao%20de%20Tarefas.pdf
%% - https://www.mathworks.com/matlabcentral/fileexchange/20328-munkres-assignment-algorithm
%%%%