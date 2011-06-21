function [x, y] = newton(A,b,x0,niter)
%[x, y] = newton(A,b,x0,niter);
%solves the linear least squares problem with nonnegative variables using the newton's algorithm in [1].
%Input:
%   A:      [MxN] matrix 
%   b:      [Mx1] vector
%   x0:     [Nx1] vector of initial values. x0 > 0. Default value: ones(n,1)
%   niter:  Number of iterations. Default value: 10
%Output
%   x:      solution
%   y:      complementary solution
%
% [1] Portugal, Judice and Vicente, A comparison of block pivoting and
% interior point algorithms for linear least squares problems with
% nonnegative variables, Mathematics of Computation, 63(1994), pp. 625-643
%
%Uriel Roque
%02.05.2006

[m,n] = size(A);

if nargin < 3
    x0 = ones(n,1);
    niter = 10;
elseif nargin < 4
    niter = 10;
end

if isempty(x0)
    x0 = ones(n,1);
elseif any(x0 <= 0)
    disp('Error. The initial vector should be nonzero');
    x = [];
    y = [];
    return
end

AtA = A'*A;
Atb = A'*b;

In = eye(n);
e = ones(n,1);

%Step 0
y0 = x0;
k = 0;
TOL1 = n*eps;
TOL2 = n*sqrt(eps);
xk = x0;
yk = y0;

noready = 1;
while noready
    
    k= k+1;
    
    %Step 1
    mk = (xk'*yk)./(n^2);
    
    Xk = diag(xk);
    Yk = diag(yk);
    Xk_inv = diag(1./xk);
    Xk_sqrt_inv = diag(1./sqrt(xk));
    Yk_sqrt = diag(sqrt(yk));
    Yk_sqrt_inv = diag(1./sqrt(yk));
                
    C = [A; Xk_sqrt_inv*Yk_sqrt];
    d = [b-A*Xk*e; Xk_sqrt_inv*Yk_sqrt_inv*mk*e ];
    uk = C\d;
    vk = -Yk*e + Xk_inv*mk*e - Xk_inv*Yk*uk;
     
    %Step2
    T1 = min(-xk(uk < 0) ./ uk(uk < 0)); 
    T2 = min(-yk(vk < 0) ./ vk(vk < 0));
    theta = 0.99995 * min(T1,T2);
    if isempty(theta)
        theta = 0;
        noready = 0;
    end
    
    xk = xk + theta*uk;
    yk = yk + theta*vk;
    
    %Step 3
    if (xk'*yk < TOL1) & (norm(AtA*xk-Atb-yk) < TOL2)
        noready = 0;
    elseif k == niter
        noready = 0;
    end
    
end

x = xk;
y = yk;
