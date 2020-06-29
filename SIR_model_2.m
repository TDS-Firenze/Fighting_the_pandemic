clear all

tspan = linspace(0,10,1000) ;
y0 = [0.999 0.001 0] ;

alfa = 0.01;
gamma = 1;
beta = 3;


[t,y] = ode45(@(t,y) SIR2(t,y,alfa,beta,gamma), tspan, y0);

plot(t,y(:,1),'LineWidth',2,'Color','green')
hold on
plot(t,y(:,2),'LineWidth',2,'Color','blue')
plot(t,y(:,3),'LineWidth',2,'Color','red')

 

alfa = 0.99;
gamma = 1;
beta = 3;


[t,y] = ode45(@(t,y) SIR2(t,y,alfa,beta,gamma), tspan, y0);

plot(t,y(:,1),':','LineWidth',2,'Color','green')
plot(t,y(:,2),':','LineWidth',2,'Color','blue')
plot(t,y(:,3),':','LineWidth',2,'Color','red')
xlabel('Time t','Fontsize',16);
legend('S','I','R','S quarantine','I quarantine', 'R quarantine','Fontsize',16)


function  F = SIR2(t,y,alfa,beta,gamma)
% S' = - beta I S
% I' =   beta I S - gamma I - alfa I
% R' =   alfa I   +  gamma I

F = [- beta * y(1) * y(2); %
     beta * y(1) * y(2) - gamma * y(2) - alfa * y(2); %
     alfa * y(2) + gamma * y(2)];
end