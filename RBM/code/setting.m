nv = 3; nh = 2;
n = 100;
% ground truth params
Theta = [ -10 10; -10 -10; 10 -10];
bb = [2;2]; aa = [-5;+5;-5];
hidden = rand(nh,n)>0.5;
% sample from p(h,v)
for it=1:100
    visible = sample(Theta,aa,hidden);
    hidden = sample(Theta',bb,visible);
end
% step size
eta = 0.05;
% momentum
mom = 0.95;
% learned parameters
lTheta = 0.1*randn(size(Theta));laa = zeros(size(aa));lbb = zeros(size(bb));
% update direction
vt = zeros(size(Theta));vaa = zeros(size(aa));vbb = zeros(size(bb));
