for it=1:10000
    [gt,ga,gb,recon] = cdgradient(lTheta,laa,lbb,visible);
    vaa = mom*vaa + eta*ga; vbb = mom*vbb + eta*gb; vt = mom*vt + eta*gt;
    lTheta = lTheta + vt; laa = laa + vaa; lbb = lbb + vbb;eta = 0.9999*eta;
    if (mod(it,100) == 0)
        fprintf('Iter: %d recon: %g',it,recon);
        fprintf('Distance of learned theta to ground truth theta: %g\n',...
        min([norm(lTheta - Theta) norm(lTheta - Theta(:,[2 1]))]))
    end
    
end