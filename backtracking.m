function [ alphak ] = backtracking (f, xk, pk, grad_fxk)
  warning('off', 'all');
  alpha = 1;
  c     = 0.01;
  p     = 0.5;
  
  do
    alpha = alpha*p
    
    xk_f1 = xk + alpha*pk
    
    f1    = double(f(xk_f1(1), xk_f1(2), xk_f1(3)))
  
    f2    = double(f(xk(1), xk(2), xk(3))) + c*alpha*grad_fxk'*pk
    
  until (f1 < f2)
  
  alphak = alpha;
  
endfunction
