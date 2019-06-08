function Lab1()
%% Построение гистограммы и эмпирической функции распределения
%Вариант № 8

    sample = importdata('data.txt');
    sample = sort(sample);
    
    [Min, Max, span] = CalcMinMaxSpan(sample);
    fprintf('min: %.6f   |   max: %.6f\n', Min, Max);
    fprintf('span (R): %.6f\n', span);

    [exp, disp] = CalcExpDisp(sample);
    fprintf('mat. expectation: %.6f\ndispersion: %.6f\n', exp, disp);
    
    [m, delta, group] = GroupSample(sample, span);
    for i = 1:m
        if i == 1
            fprintf('[%.6f', Min);
        else
            fprintf('[%.6f', group(i-1, 1));
        end
        fprintf(' .. %.6f', group(i, 1));
        if i == m
            fprintf(']');
        else
            fprintf(')');
        end
        fprintf(':  %d elements\n', group(i, 2));
    end
    
    figure(1);
    grid;
    hold on;
    PlotChartAndDensity(group, delta, sample, exp, disp, Min, Max);
    
    figure(2);
    grid;
    hold on;
    PlotEmpiricAndDistribution(sample, exp, disp, Min, Max);

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [Min, Max, span] = CalcMinMaxSpan(sample)
%% вычисление минимального и максимального значений выборки
%вычисление размаха выборки

    Min = min(sample);
    Max = max(sample);
    span = Max - Min;
end


function [exp, disp] = CalcExpDisp(sample)
%% вычисление значений \mu\cap и S^2 математического ожидания MX и дисперсии
% DX

    n = length(sample);

    exp = sum(sample) / n;
    %disp = sum((sample - exp).^2) / n;
    %s2 = sum((sample - exp).^2) / (n-1);
    disp = sum((sample - exp).^2) / (n-1);
end


function [m, delta, group] = GroupSample(sample, span)
%% группировка значений выборки в
% $x^2+m=[log_{2}(n)]+2$
%интервала

    n = length(sample);
    m = floor(log2(n)) + 2;
    delta = span / m;
    group = zeros(m, 2);
    
    %указываем границы интервалов
    for j = 1:m
        group(j,1) = sample(1)+delta*j;
    end
    
    %раскидываем элементы по интервалам
    j = 1;
    i = 1;
    border = sample(1)+delta;
    while i < n
        if sample(i) >= border && border < sample(n)
            border = border + delta;
            j = j + 1;
            continue; %чтобы корректно обрабатывать ситуациии, когда в
            %интервал не попадает ни один элемент выборки
        end
        group(j, 2) = group(j, 2) + 1;
        i = i + 1;
    end
    group(m, 2) = group(m, 2) + 1; %последний (n-й) элемент всегда будет
    %принадлежать последнему (m-му) интервалу
end


function PlotChartAndDensity(group, delta, sample, exp, disp, Min, Max)
%% построение на одной координатной плоскости гистограммы и графика функции
%плотности распределения вероятностей нормальной случайной величины с
%математическим ожиданием M и дисперсией S2

    %модифицируем Х для гистограммы - чтобы значения отображались для середин
    %интервалов
    m = length(group);
    gist = zeros(m,2);
    gist(1,1) = (sample(1) + group(1,1)) ./ 2;
    for i = 2:m
        gist(i,1) = (group(i-1,1) + group(i,1)) ./ 2;
    end

    %модифицируем Y для гистограммы - количество_попаданий / (n*delta)
    n = length(sample);
    for i = 1:m
        g = group(i,2);
        g = g ./ (n*delta);
        gist(i,2) = g;
    end

    %вычисляем значения функции плотности распределения для всех Х в
    %пределах выборки
    count = 120;
    step = (Max-Min) / count;
    xs = Min:step:Max; %zeros(count,1);
    ys = normpdf(xs,exp,sqrt(disp));

    %отображаем значения
    stairs(gist(:,1), gist(:,2), 'b'), grid;
    plot(xs,ys, 'r'), grid;
end


function PlotEmpiricAndDistribution(sample, exp, disp, Min, Max)
%% построение на другой координатной плоскости графика эмпирической функции
%распределения и функции распределения нормальной случайной величины с
%математическим ожиданием M и дисперсией S2

    %получаем функцию распределения для нормальной случайной величины
    count = 120;
    step = (Max - Min) / count;
    xs = Min:step:Max;
    F = normcdf(xs, exp, disp);
   
    %строим эмпирическую функцию распределения
    n = length(sample);
    E = zeros(n,1);
    for i = 1:n
        E(i) = F_Empiric(sample(i), sample);
    end
    
    %для сравнения, упрощенный вариант эмпирической
    % ! при этом в выборке есть повторяющиеся значения
    E2 = zeros(n,1);
    for i = 1:n
        E2(i) = (i-1)./n;
    end
    
    %строим графики
    plot(xs, F), grid;
    %stairs(sample, E2, 'k'), grid;
    stairs(sample, E, 'r'), grid;
    hold off;
end

function f = F_Empiric(x, sample)
    n = length(sample);
    count = 0;
    for i = 1:n
        if sample(i) < x
            count = count+1;
        end
    end
    f = count / n;
end

%Lab1()
