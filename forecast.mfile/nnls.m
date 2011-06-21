% xopt = pqn_nnls(A, b, err)
%
% Given a tall full-rank matrix A, solves the nonnegative least squares
% problem: min ||Ax-b|| s.t. x>= 0 and returns the minimizer x. The
% argument err is the tolerance used in testing for zeros.
%
% implementation of the PQN-NNLS algorithm from Kim, Sra, Dhillon 2006
% coded by Alex Gittens 9/9/2009

function xopt = nnls(A, b, err)
    [m,n] = size(A);
    At = A.\';
    AtA = At*A;
    Atb = At*b;
    grad = @(x) AtA*x - Atb;
    proj = @(x) x.*(x>=0);

    myeps = err/100;

    curS = eye(n);
    curx = zeros(n,1);

    while true
        curgrad = grad(curx);
        fixedset = find( (abs(curx) < myeps) & (curgrad > myeps) );
        freeset = setdiff([1:n], fixedset);

        cury = curx(freeset);
        curgrady = curgrad(freeset);
        subS = curS(freeset, freeset);
        subA = A(:, freeset);
        obj = @(x) 1/2*norm(subA*x - b)^2;
        gamma = @(bt) proj(cury - bt*subS*curgrady);

        % using APA rule
        alpha = 1;
        sigma = 1;
        s = 1/2;
        tau = 1/4;
        m = 0;
        storedgamma = gamma(s^m*sigma);
        while (obj(cury)-obj(storedgamma)) < tau*curgrady.\'*(cury - storedgamma)
             m = m+1;
             storedgamma = gamma(s^m*sigma);
        end
        d = storedgamma - cury;

        u = curx;
        u(freeset) = alpha*d;
        u(fixedset) = 0;
        temp1 = A*u;
        temp2 = At*temp1;
        temp3 = u*u.\';
        temp4 = temp1.\'*temp1;
        temp5 = curS*temp2*u.\';

        curS = ((1 + temp2.\'*curS*temp2/temp4)*temp3 - ...
            (temp5+temp5.\'))/temp4 + curS;

        % disp(norm(A*curx - b));
        if norm(curx(freeset) - cury - alpha*d) < err
            break;
        end
        curx(freeset) = cury + alpha*d;
    end

    xopt = curx;
end