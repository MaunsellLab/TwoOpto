% plot isopleths for d'

% Make Circles
[x1, y1] = isopleth(0,0,1);
[x2, y2] = isopleth(0,0,2);
[x3, y3] = isopleth(0,0,3);
[x4, y4] = isopleth(0,0,4);

figure;
hold on;
axis square;
plot(x1, y1, 'LineStyle', '--', 'Color', 'k', 'LineWidth', 0.5);
plot(x2, y2, 'LineStyle', '--', 'Color', 'k', 'LineWidth', 0.5);
plot(x3, y3, 'LineStyle', '--', 'Color', 'k', 'LineWidth', 0.5);
plot(x4, y4, 'LineStyle', '--', 'Color', 'k', 'LineWidth', 0.5);
xlim([0 4.5]);
ylim([0 4.5]);
set(gca, 'TickDir', 'out');
set(gca, 'FontSize', 14);
set(gca, 'LineWidth', 1);
set(gca, 'XTick', [0 1 2 3 4]);
set(gca, 'YTick', [0 1 2 3 4]);
hold off;
