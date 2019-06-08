ti = csvread("data_t.csv");
yi = csvread("data_y.csv");

ti_square = ti .* ti;
Ksi = horzcat(ones(length(ti), 1), transpose(ti), transpose(ti_square));
display(Ksi);

theta = inv(transpose(Ksi) * Ksi) * transpose(Ksi) * transpose(yi);
y_cap = theta(1) + theta(2) * ti + theta(3) * ti_square;

delta = sqrt(sum((yi - y_cap).^2));

fprintf("delta is %.2f\n thetas: %.2f, %.2f, %.2f\n", delta, theta(1), theta(2), theta(3));
 
plot(ti, yi, '.b');
hold on;
plot(ti, y_cap, 'r');
hold off;
axis tight; 
grid on;
