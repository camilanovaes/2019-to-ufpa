%
% Dependecies: 
%  - Python and SymPy
%  - Ot octave, install 'symbolic' and load it: 
%     * 'pkg install -forge symbolic'
%     * 'pkg load symbolic'
%

function [ x ] = gradient_descent (x)
  pkg load symbolic

  syms x1 x2 x3;

  % x
  %x = [0; 0;]
  
  % Função objetivo
  f(x1,x2,x3)      = 2*x1^2 + (x2 - 5)^2 + (x3 - 5)^2 - x1*x2 - x1*x3 - x2*x3
  %f(x1, x2) = 2*x1^2 + x2^2 - 4*x1 + 4*x2
  %f(x1, x2) = x1 - x2 + (x1 + x2)^2 + x1^2
  
  % Gradiente de f
  grad_f(x1,x2,x3) = gradient(f)
  
  % Pk
  pk(x1,x2,x3)     = - grad_f(x1,x2,x3)

  %% Calculos
  fk          = double(f(x(1), x(2), x(3)))
  grad_fxk    = double(grad_f(x(1), x(2), x(3)))
  mod_grad_fxk= sqrt(grad_fxk(1)^2 + grad_fxk(2)^2 + grad_fxk(3)^2)
  pk          = - grad_fxk
  grad_fxk_pk = grad_fxk' * pk
  alphak      = backtracking (f, x, pk, grad_fxk)
  x           = x + alphak*pk


endfunction


