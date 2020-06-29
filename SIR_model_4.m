
alfa = 0.4;
gamma = 1;
tau
beta = 0.8 * (gamma + alfa);


lags = 2;

tspan = linspace(0,10,1000) ;
y0 = [0.999 0.001 0] ;
y = dde23(@(t,y) ddefun(t,y,alfa,beta,gamma), tspan, y0);
sol = dde23(@ddex1de,[1, 0.2],@ddex1hist,[0, 5]);
tint = linspace(0,5);
yint = deval(sol,tint);
plot(tint,yint);

plot(t,y(:,1),'LineWidth',2)

hold on
plot(t,y(:,2),'LineWidth',2)
plot(t,y(:,3),'LineWidth',2)
xlabel('Time t');
legend('Suscetibles','Infectious','Removed')
 
function  F = ddefun(t,y,Z)

F = [- beta * y(1) * y(2); %
     beta * y(1) * y(2) - gamma * y(2) - alfa * y(2); %
     alfa * y(2) + gamma * y(2)];
endn)

