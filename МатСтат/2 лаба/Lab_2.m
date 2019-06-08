function Lab2() 
    sample = importdata('data.txt');
    
    [exp, s2] = CalcExpDisp(sample);
    fprintf('mat. expectation: %.6f\ndispersion: %.6f\n', exp, s2);
    
    gamma = input('Input gamma: ');
    if isempty(gamma) gamma = 0.9; disp(gamma); end
    N = input('Input N: ');
    if isempty(N) N = length(sample); disp(N); end
    
    [lowM, highM] = CalcBordersExp(exp, s2, gamma, N);
    [lowD, highD] = CalcBordersDisp(s2, gamma, N);
    fprintf('mat.exp. borders: (%.6f .. %.6f)\n', lowM, highM);
    fprintf('dispersion borders: (%.6f .. %.6f)\n', lowD, highD);
    
    figure(1);
    hold on;
    PlotMathExps(sample, gamma, N);
    
    figure(2);
    hold on;
    PlotDispersions(sample, gamma, N); 
end
 

function [exp, s2] = CalcExpDisp(sample)
%% вычисление точечных оценок математического ожидания и дисперсии
 
    n = length(sample);
 
    exp = sum(sample) / n;
    if n > 1
        s2 = sum((sample - exp).^2) / (n-1);
    else
        s2 = 0;
    end
end
 
 
function [lowM, highM] = CalcBordersExp(exp, s2, gamma, N)
%% вычисление нижней и верхней границ матожидания
 
    %неизвестны матожидание и дисперсия, оцениваем матожидание;
    %статистика ~St(n-1): P{|(m - mu^)/sqrt(s2)*sqrt(n)| < q_alpha} = gamma
    alpha = 1 - (1 - gamma) / 2;
    quantile = tinv(alpha, N-1);
    
    border = quantile * sqrt(s2) / sqrt(N);
    lowM = exp - border;
    highM = exp + border;
    
end
 
 
function [lowD, highD] = CalcBordersDisp(s2, gamma, N)
%% вычисление нижней и верхней границ дисперсии
 
    %неизвестны матожидание и дисперсия, оцениваем дисперсию;
    %статистика ~chi2(n-1): P{ q_low < s2*(n-1)/disp < q_high } = gamma
    
    low = (1 - gamma) / 2;
    a_quantile = chi2inv(low, N-1);
    highD = s2*(N-1) / a_quantile;
    
    high = 1 - low;
    a_quantile = chi2inv(high, N-1);
    lowD = s2*(N-1) / a_quantile;
    
end
 
 
function PlotMathExps(sample, gamma, N)
%% на координатной плоскости Oyn построить прямую y=mu^(x_N), а также
%графики функций mu^(x_n), mu_down(x_n), mu_up(x_n) как функций от объема n
%выборки, где n изменяется от 1 до N
 
    %определяем матожидания и дисперсии для разных n
    mu = zeros(N,1);
    s2 = zeros(N,1);
    for i = 1:N
        part = sample(1:i);
        [mu(i), s2(i)] = CalcExpDisp(part);
    end
    
    %заполняем массив значений для прямой
    mu_line = zeros(N,1);
    mu_line(1:N) = mu(N);
    
    %заполняем массивы значений для границ
    mu_down = zeros(N,1);
    mu_up = zeros(N,1);
    for i = 1:N
        [mu_down(i), mu_up(i)] = CalcBordersExp(mu(i), s2(i), gamma, i);
    end
    
    plot((1:N), mu_line, 'g');
    plot((1:N), mu, 'k');
    plot((1:N), mu_up, 'b');
    plot((1:N), mu_down, 'r');
    grid on;
    xlabel('n');
    ylabel('\mu');
    legend('\mu\^(x_N)', '\mu\^(x_n)', '\mu^{up}(x_n)', '\mu_{down}(x_n)');    
end
 
 
function PlotDispersions(sample, gamma, N)
%% на координатной плоскости Ozn построить прямую y=S2(x_N), а также
%графики функций S2(x_n), sigma_down(x_n), sigma_up(x_n) как функций от
%объема n выборки, где n изменяется от 1 до N
 
%на малых n дисперсия прыгает до 300, мелкие значения не разглядеть
start = 5;
 
 
    %определяем матожидания и дисперсии для разных n
    mu = zeros(N,1);
    s2 = zeros(N,1);
    for i = start:N
        part = sample(1:i);
        [mu(i), s2(i)] = CalcExpDisp(part);
    end
    
    %заполняем массив значений для прямой
    s2_line = zeros(N,1);
    s2_line(1:N) = s2(N);
    
    %заполняем массивы значений для границ
    sigma_down = zeros(N,1);
    sigma_up = zeros(N,1);
    for i = start:N
        [sigma_down(i), sigma_up(i)] = CalcBordersDisp(s2(i), gamma, i);
    end
    
    nvalues = (start:N);
    plot(nvalues, s2_line(nvalues), 'g');
    plot(nvalues, s2(nvalues), 'k');
    plot(nvalues, sigma_up(nvalues), 'b');
    plot(nvalues, sigma_down(nvalues), 'r');
    grid on;
    xlabel('n');
    ylabel('\sigma');
    legend('S^2(x_N)', 'S^2(x_n)', '\sigma^{up}(x_n)', '\sigma_{down}(x_n)');
end 
