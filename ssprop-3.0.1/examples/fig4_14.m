T = 100;                     % time window (period)
nt = 2^12;                   % number of points
dt = T/nt;                   % timestep (dt)
t = ((1:nt)'-(nt+1)/2)*dt;   % time vector
w = wspace(T,nt);            % angular frequency vector
vs = fftshift(w/(2*pi));     % shifted for plotting
z = 5;                       % propagation distance
nz = 2000;                   % number of steps
dz = z/nz;                   % step size

betap = [0,0,0,1];           % dispersion polynomial

u0 = gaussian(t,0,2*sqrt(log(2)));  % u0 = exp(-t.^2/2);

u = sspropc(u0,dt,dz,nz,0,betap,1);
U = fftshift(abs(dt*ifft(u)*nt/sqrt(2*pi)).^2);

subplot(121);
plot (t,abs(u).^2);
xlim([-4 16]);
xlabel ('(t-\beta_1z)/T_0');
ylabel ('|u(z,t)|^2/P_0');

subplot(122);
plot (vs,U);
xlim([-0.6 0.6]);
xlabel ('(\nu-\nu_0) T_0');
ylabel ('|U(z,\nu)|^2/P_0');
