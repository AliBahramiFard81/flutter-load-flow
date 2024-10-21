%% by Ali Bahrami Fard

clc;
clear;
format short;  

%% Loading the data from csv
filePath = dir;
folder = filePath(1).folder;
line_data = readmatrix(fullfile(folder, 'line_data.csv'));
bus_data = readmatrix(fullfile(folder, 'bus_data.csv'));


disp(folder);
%% line data
% 1.from bus    2.to bus    3.R     4.X
% should be in per unit
read_line_data = line_data;

%% bus data
% 1.P    2.Q    3.V     4.Delta     5.bus type
% should be in per unit
% when - is load when + is generating
% if column 5 = 1 => PQ if 5 = 0 => PV and 2 is slack
read_bus_data = bus_data;

r = read_line_data(:,3);
x = read_line_data(:,4);

PQ=find(read_bus_data(:,5)==1);   % PQ bus
PV=find(read_bus_data(:,5)==0);   % PV bus

% ----- CALCUALTION OF Ybus -----
number_of_bus = max(max(read_line_data(:,2)), max(read_line_data(:,1)));

y = read_line_data(:,3)+1i*read_line_data(:,4);
Ybus = zeros(number_of_bus,number_of_bus);

for l=1:length(y)
    if(real(y(l))) == 0 && imag(y(l)) == 0
        y(l) = 0;
    else
        y(l) = 1/y(l);
    end
end

for m=1:length(read_line_data(:,1))
    Ybus(read_line_data(m,1), read_line_data(m,2)) = -y(m);
    Ybus(read_line_data(m,2), read_line_data(m,1)) = Ybus(read_line_data(m,1), read_line_data(m,2));
end

for n=1:number_of_bus
    for c=1:length(y)
        if read_line_data(c,1) == n || read_line_data(c,2) == n
            Ybus(n,n) = Ybus(n,n) + y(c);
        end
    end
end

YbusReal = real(Ybus);
YbusImag = imag(Ybus);

ybusR=zeros(number_of_bus,number_of_bus);
ybusA=zeros(number_of_bus,number_of_bus);
% converting rec to polar
for v=1:length(read_line_data(:,1))
    % size
    ybusR (read_line_data(v,1), read_line_data(v,2)) = abs(-y(v));
    ybusR (read_line_data(v,2), read_line_data(v,1)) = ybusR (read_line_data(v,1), read_line_data(v,2));
    if v <= number_of_bus
        ybusR (v,v) = abs(-Ybus(v,v));
    end
    % angle
    ybusA (read_line_data(v,1), read_line_data(v,2)) = angle(-y(v));
    ybusA (read_line_data(v,2), read_line_data(v,1)) = ybusA (read_line_data(v,1), read_line_data(v,2));
    if v <= number_of_bus
        ybusA(v,v) = angle(Ybus(v,v));
    end
end

%% Calculation of B' ~ B1 and it's inverse
B1 = YbusImag;
% remove the first row
B1 = B1(2:end,:);
% remove the first column
B1 = B1(:,2:end);
B1_inverse = inv(B1);
%% Calculation of B'' ~ B2 and it's inverse
B1test = B1;
B2 = zeros(number_of_bus - 1 -length(PV), number_of_bus - 1 -length(PV));

for i=1:length(B2)
    B1test(PV(i) - 1,:) = [];
    B1test(:, PV(i) - 1) = [];
end

B2 = B1test;
B2_inverse = inv(B2);

%% Calculation of power flow

tol_max = 2.5 * 10e-4;
tol = 1;
number_of_iterration = 0;

while tol > tol_max
    % ----- CALCUALTION OF P AND Q -----
    Pcalc = zeros(number_of_bus,1);
    Qcalc = zeros(number_of_bus,1);
    
    for i=1:number_of_bus
        if read_bus_data(i,1) ~= 0
            for b=1:number_of_bus
                Pcalc(i) = Pcalc(i) + read_bus_data(i,3) * read_bus_data(b,3) * ybusR(i,b) * cos(ybusA(i,b) - read_bus_data(i,4) + read_bus_data(b,4));
                if read_bus_data(i,2) ~= 0
                    Qcalc(i) = Qcalc(i) - read_bus_data(i,3) * read_bus_data(b,3) * ybusR(i,b) * sin(ybusA(i,b) - read_bus_data(i,4) + read_bus_data(b,4));
                end
            end
        end
    end
    Pcalc = Pcalc(2:end,:);
    Qcalc = Qcalc(2:end,:);

    % ----- CALCUALTION OF DELTA P AND Q -----
    DeltaP = zeros(number_of_bus - 1);
    DeltaQ = zeros(length(PQ),1);
    
    for f=2:number_of_bus
        DeltaP(f - 1) = read_bus_data(f,1) - Pcalc(f - 1);
    end 
    
    for g=1:length(PQ)
        DeltaQ(g) = read_bus_data(g + 1 ,2) - Qcalc(g);
    end

    DeltaP = DeltaP(:,1);
    DeltaQ = DeltaQ(:,1);

    % ----- CALCULATION OF ΔP/V AND ΔQ/V -----
    DeltaP_V = zeros(length(DeltaP),1);
    DeltaQ_V = zeros(length(DeltaQ),1);

    for i=1:length(DeltaP_V)
        DeltaP_V(i) = DeltaP(i) / read_bus_data(i + 1,3);
    end
    for i=1:length(DeltaQ_V)
        DeltaQ_V(i) = DeltaQ(i) / read_bus_data(i + 1 ,3);
    end

    % ----- CALCULATION OF Δδ AND ΔV -----
    dDelta = zeros(length(DeltaP),1);
    dVoltage = zeros(length(DeltaQ),1);
    
    dDelta = -1 * B1_inverse * DeltaP_V;
    dVoltage = -1 * B2_inverse * DeltaQ_V;
    

    % ----- UPDATING THE VALUES OF THE BUS DATA -----
    for x = 2:number_of_bus
        read_bus_data(x, 4) = read_bus_data(x, 4) + dDelta(x - 1);
    end

    counter = 1;
    for x = 2:number_of_bus
        if read_bus_data(x,5) == 1  
            read_bus_data(x, 3) = read_bus_data(x, 3) + dVoltage(x - counter);
        end
        counter = counter + 1;
    end

    number_of_iterration = number_of_iterration + 1;
    tol = max(abs([DeltaP;DeltaQ]));

    fprintf("----------------- Iteration %d -----------------\n",number_of_iterration);
    disp("DeltaP and DeltaQ");
    disp([DeltaP;DeltaQ]);
    disp("Δδ AND ΔV");
    disp([dDelta;dVoltage]);
    disp("      P           Q        V       Delta");
    disp(read_bus_data);
end