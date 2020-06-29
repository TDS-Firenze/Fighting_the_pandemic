close all
clear all

global a beta  rho gamma gamma_e
beta    = 4 ;
gamma   = 1 ;
gamma_e = 0.1;
rho     = 0.001;
a       = 0.99;

tspan = linspace(0,10,1000) ;
y0 = [0.999 0.001 0 0] ;
[t,y] = ode45(@(t,y) odefun(t,y), tspan, y0);

figure(1)
plot(t,y(:,1),'LineWidth',2)
hold on
plot(t,y(:,2),'LineWidth',2)
plot(t,y(:,3),'LineWidth',2)
plot(t,y(:,4),'LineWidth',2)
xlabel('Time t','Fontsize',15);
legend('S(t)','E(t)','I(t)','R(t)','Fontsize',15)

function  out = odefun(t,y)
 S = y(1);
 E = y(2);
 I = y(3);
 R = y(4);

out(1)  = - beta * I * S  - beta * E * S       ;        
out(2)  =   beta*(E + I)*S -a*E - gamma_e*E    ; 
out(3)  =   a * E - gamma * I                  ;
out(4)  =   gamma* I + gamma_e * E             ;
out = out';
end 

