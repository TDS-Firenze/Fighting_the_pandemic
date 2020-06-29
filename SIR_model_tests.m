% This function solve the SIR model with tests


clear all

%for sigma = 0.01: 0.01 : 0.99 
sigma = 0.51;
fpr   = 0.2553191;                 % False Positive Rate
fnr   = 0.03846154;                % False Negative Rate
alfaS = sigma * (1 - fpr);
alfaI = sigma * (1 - fnr);
gamma = 0.01;
beta  = 4;

tspan = linspace(0,10,1000) ;
y0 = [0.999 0.001 0] ;
[t,y] = ode45(@(t,y) SIR3(t,y,alfaS,alfaI,beta,gamma), tspan, y0);


plot(t,y(:,1),'LineWidth',2,'Color','green')
hold on
plot(t,y(:,2),'LineWidth',2,'Color','blue')
plot(t,y(:,3),'LineWidth',2,'Color','red')
xlabel('Time t','Fontsize',15);


sigma = 0.99;
fpr   = 0.2553191;
fnr   = 0.03846154;
alfaS = sigma * (1 - fpr);
alfaI = sigma * (1 - fnr);
gamma = 0.01;
beta  = 4;

tspan = linspace(0,10,1000) ;
y0 = [0.999 0.001 0] ;
[t,y] = ode45(@(t,y) SIR3(t,y,alfaS,alfaI,beta,gamma), tspan, y0);

plot(t,y(:,1),':','LineWidth',2,'Color','green')
plot(t,y(:,2),':','LineWidth',2,'Color','blue')
plot(t,y(:,3),':','LineWidth',2,'Color','red')
xlabel('Time t','Fontsize',15);
legend('S','I','R','S with \sigma = 0.99 ','I with \sigma = 0.99', 'R with \sigma = 0.99','Fontsize',16)


% Definition of function 
function  F = SIR3(t,y,alfaS,alfaI,beta,gamma)
% S' = - beta I S - alfaS S
% I' =   beta I S - gamma I - alfaI I 
% R' =   alfaI I   +  gamma I + alfaS S

F = [- beta * y(1) * y(2) - alfaS * y(1); ...
     beta * y(1) * y(2) - gamma * y(2) - alfaI * y(2); ...
     alfaI * y(2) + gamma * y(2) + alfaS * y(1)];
end

