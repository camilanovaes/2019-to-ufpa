%%%% Função da Questão 3.1
%%
%%   Problema de Designação usando LP
%%
%%%%

function [ x ] = designation_problem( W )
  % Problema de designação
  %
  % %%%%%%%%%%%%%%%%%
  %
  % Input:
  %   W -> matriz n x n com os custos wij
  %
  % Outputs:
  %   x -> matriz n x n com as associações entre os nós i e j
  %
  % %%%%%%%%%%%%%%%%%
  
  p   = ones(size(W,1)); % 'Pessoas'
  t   = ones(size(W,2)); % 'Tarefas'
  
  % Os problemas de designação podem ser modelados e resolvidos da mesma maneira
  % que os problemas de transporte, onde a disponibilidade de cada fonte é igual
  % a 1, a demanda de cada destino é 1 e a capacidade máxima de cada arco também
  % é 1. Logo, utilizamos a mesma função de transporte, chamada de 
  % 'transportation' para resolver o problema de designação.
  [ x ]  = transportation(W, p, t);
  
endfunction
