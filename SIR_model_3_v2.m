close all
clear all
ii=1;
fpr     = 0.2553191;
fnr     = 0.03846154;
budget  = 100;
gamma = 0.01;
beta  = 4;
tspan = linspace(0,10,1000) ;
y0 = [0.999 0.001 0] ;

 for  sigma = 0.01: 0.01 : 1
%for sigma = 0.51;
alfaS = sigma * (fpr);
alfaI = sigma * (1 - fnr);
[t,y] = ode45(@(t,y) SIR3(t,y,alfaS,alfaI,beta,gamma), tspan, y0);
Imax(ii) = max(y(:,2));
Imean(ii)= mean(y(:,2) * (sigma - alfaI));

ii = ii + 1;
% plot(t,y(:,1),'LineWidth',2)
% hold on
% plot(t,y(:,2),'LineWidth',2)
% plot(t,y(:,3),'LineWidth',2)
% xlabel('Time t','Fontsize',15);
% legend('S(t)','I(t)','R(t)','Fontsize',15)

end
 
sigma = 0.01: 0.01 : 1 ;
plot(sigma,Imax)
xlabel('\sigma','Fontsize',18)
hold on
coste =linspace(0.95,1,length(sigma)) ;
figure(1)
plot(sigma,sigma)
legend('Imax','coste','Fontsize',15)
plot(sigma,sigma./100)
figure(2)
plot(sigma,Imean)
xlabel('\sigma','Fontsize',18)
ylabel('I_{mean}','Fontsize',18)

figure(3)
plot(sigma,(1-Imax)./coste)
xlabel('\sigma','Fontsize',18)



function  F = SIR3(t,y,alfaS,alfaI,beta,gamma)
% S' = - beta I S - alfaS S
% I' =   beta I S - gamma I - alfaI I 
% R' =   alfaI I   +  gamma I + alfaS S

F = [- beta * y(1) * y(2) - alfaS * y(1); ...
     beta * y(1) * y(2) - gamma * y(2) - alfaI * y(2); ...
     alfaI * y(2) + gamma * y(2) + alfaS * y(1)];
end

