beta = 4;
gamma = 1;

tspan = linspace(0,10) ;
y0 = [0.999 0.001 0] ;
[t,y] = ode45(@(t,y) SIR(t,y,beta,gamma), tspan, y0);

% subplot(2,2,1)
% plot(t,y(:,1));
% title('Solution of SIR model (R_0 = 100) with ode45');
% xlabel('Time t');
% ylabel('Suscetibles S ');
% 
% subplot(2,2,2)
% plot(t,y(:,2));
% title('Solution of SIR model  with ode45');
% xlabel('Time t');
% ylabel('Infectious I');
% 
% 
% subplot(2,2,3)
% plot(t,y(:,3));
% title('Solution of SIR model  with ode45');
% xlabel('Time t');
% ylabel('Removed R ');
% 
% subplot(2,2,4)
% plot(y(:,1),y(:,2));
% title('Phase Plane');
% xlabel('Suscetibles S');
% ylabel('Infectious I');


plot(t,y(:,1),'LineWidth',2)

hold on
plot(t,y(:,2),'LineWidth',2)
plot(t,y(:,3),'LineWidth',2)
xlabel('Time t','Fontsize',16);
legend('S','I','R','Fontsize',16)
 
function  F = SIR(t,y,beta,gamma)
% S' = - beta I S
% I' =   beta I S - gamma I
% R' =   gamma I

F = [- beta * y(1) * y(2); %
     beta * y(1) * y(2) - gamma * y(2); %
     gamma * y(2)];
end