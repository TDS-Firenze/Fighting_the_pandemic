%
global gamma beta alpha_s alpha_i rho

gamma = 1;
beta = 4 ;
alpha_s = 0;
alpha_i = 0.75;
rho = 0.001;

I0 = rho;
S0 = 1 - rho;
R0 = 0;


% Time integration:
dt      = 0.1;  % Time step in days
ii      = 1  ;  % Auxilliary index to store the solutions in an array
t0      = 0  ;  % Initial time, day 0
t_final = 50 ;  % Final time for the simulation

t_n     = t0;
y_n     = [S0 I0 R0];

SIR   = zeros([round(t_final/dt), length(y_n)]);


%Loop in time

while(t_n < t_final)
    
    if ii <= 10
        y_n = updateStepTimeDel(dt, y_n, @F, zeros(1,3));
    else
        % Update variables:
        y_n = updateStepTimeDel(dt, y_n, @F, SIR(ii-10,:));
    end
    
    % Save results:
    SIR(ii,:) = y_n;
%    print(np.sum(SIR[ii,:]))

    % Update iterators:
    t_n = t_n + dt;
    ii  = ii + 1;
end


%%%% START ODESOLVER %%%




function out = FS(y)
    global beta
    global alpha_s
    S = y(1);
    I = y(2);
    R = y(3);
    out = -beta * I * S - alpha_s * S;
end

function out = FR(y)
    global gamma
    global alpha_s
    S = y(1);
    I = y(2);
    R = y(3);
    out = gamma * I - alpha_s * S;
end

function out = FI(y)
    global gamma
    global beta
    global alpha_i
    S = y(1);
    I = y(2);
    R = y(3);
    out = beta * I * S - gamma * I - alpha_i * I;
end

function out = FSdel(y, ydel)

    global beta alpha_s 
   
    s=y(1);
    i=y(2);
    r=y(3);
    sdel = ydel(1);
    idel = ydel(2);
    rdel = ydel(3);
    out = -beta*i*s - alpha_s*s;
end

function out = FIdel(y, ydel)

    global beta alpha_i gamma 
   
    s=y(1);
    i=y(2);
    d=y(3);
    sdel = ydel(1);
    idel = ydel(2);
    if i <0
        idel =0;
    end
    rdel = ydel(3);
    out = beta*i*s - gamma *i - alpha_i*idel;
end

function out = FRdel(y, ydel)

    global alpha_s alpha_i gamma 
   
    s=y(1);
    i=y(2);
    d=y(3);
    sdel = ydel(1);
    idel = ydel(2);
    if i <0
        idel =0;
    end
    rdel = ydel(3);
    out =  gamma *i + alpha_s*s + alpha_i*idel;
end

function out = F (y,ydel)
    out = [FSdel(y,ydel) FIdel(y,ydel) FRdel(y,ydel)] ;
end