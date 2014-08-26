function plt = PlotCircle(center, r, iNumPts)
    t = linspace(0, 2*pi, iNumPts);
    x = center(1) + r * cos(t);
    y = center(2) + r * sin(t);

    plt = plot(x, y, 'Color', [0, 0, 0]);
end