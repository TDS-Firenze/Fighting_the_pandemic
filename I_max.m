% This function plot Imax (the maximum number of infections) as a function of R_0

clear all

S0 = 0.99;
I0 = 0.01;

R0 = linspace(1, 50, 1000);

plot(R0, Imax(R0,S0,I0),'LineWidth',2)

xlabel('R_0','Fontsize',15);
ylabel('I_{max}','Fontsize',15);

% Definition of I_max 
function I = Imax(R0,S0,I0)
 I = I0 + S0  -  S0./ R0 .* (1 + log( R0 ) ); 
end
