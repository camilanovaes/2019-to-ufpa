%function [ x ] = newton_method (x)
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
  hessiana_f       = [4, -1, -1; -1, 2, -1; -1, -1, 2]
  inv_hessiana_f   = inv(hessiana_f)
  
  grad_fxk         = double(grad_f(x(1), x(2), x(3)))
  mod_grad_fxk     = sqrt(grad_fxk(1)^2 + grad_fxk(2)^2 + grad_fxk(3)^2)
  pk               = - inv_hessiana_f * grad_fxk
  grad_fxk_pk      = grad_fxk' * pk
  alpha            = 1
  x                = x + alpha*pk
  
  
  
%endfunction