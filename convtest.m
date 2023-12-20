% Convergence test of basic finite difference solution using two 
% particles (cores) with distinct masses (say 1.0 and 0.5) in 
% mutual circular orbit about each other.
function convtest()
    pausesecs = 5;
    tmax = 140;
    plot1en = 1;
    plot2en = 1;
    plot3en = 1;

    % ICs for mutual circular orbit
    r = 4;
    mc1 = 1;
    mc2 = 0.5;
    r1 = mc2 * r / (mc2 + mc1);
    r2 = mc1 * r / (mc2 + mc1);
    v1 = sqrt(mc2 * r1) / r;
    v2 = sqrt(mc1 * r2) / r;

    % Get position values at levels 6, 7, 8
    [t6 r6 v6] = galaxy(2, tmax, [mc1 mc2], 6, [r1 0 0; -r2 0 0], [0 v1 0; 0 -v2 0], 0);
    [t7 r7 v7] = galaxy(2, tmax, [mc1 mc2], 7, [r1 0 0; -r2 0 0], [0 v1 0; 0 -v2 0], 0);
    [t8 r8 v8] = galaxy(2, tmax, [mc1 mc2], 8, [r1 0 0; -r2 0 0], [0 v1 0; 0 -v2 0], 0);

    % Reshape vectors to only consider one particle's x dimension
    r6 = reshape(r6(1,1,:), [1, length(t6)]);
    r7 = reshape(r7(1,1,:), [1, length(t7)]);
    r8 = reshape(r8(1,1,:), [1, length(t8)]);

    % Plot position vs time for all levels
    if plot1en
        clf;
        hold on;
        titlestr = sprintf('Position vs Time');
        title(titlestr, 'FontSize', 16, 'FontWeight', 'bold', ...
            'Color', [0.25, 0.42, 0.31]);
        xlabel('Time (s)');
        ylabel('Position');
        plot(t6, r6, 'r-.o');
        plot(t7, r7, 'g-.+'); 
        plot(t8, r8, 'b-.*');
        legend('r6', 'r7', 'r8');
        pause(pausesecs);
    end

    % Downsample level 7 & 8 to length of level 6
    r7 = r7(1:2:end);
    r8 = r8(1:4:end);

    % Compute differences of grid functions between levels
    r67 = r6 - r7;
    r78 = r7 - r8;

    % Plot position differences vs time between levels
    if plot2en
        clf; 
        hold on;
        titlestr = sprintf('Position Difference vs Time');
        title(titlestr, 'FontSize', 16, 'FontWeight', 'bold', ...
            'Color', [0.25, 0.42, 0.31]);
        xlabel('Time (s)');
        ylabel('Position Difference');
        plot(t6, r67, 'r-.o'); 
        plot(t6, r78, 'g-.+');
        legend('r67', 'r78');
        pause(pausesecs);
    end

    % Scale level 7,8 difference
    r78 = r78 * 4;

    % Plot scaled position differences vs time between levels
    if plot3en
        clf; 
        hold on; 
        titlestr = sprintf('Scaled Position Difference vs Time');
        title(titlestr, 'FontSize', 16, 'FontWeight', 'bold', ...
           'Color', [0.25, 0.42, 0.31]);
        xlabel('Time (s)');
        ylabel('Position Difference');
        plot(t6, r67, 'r-.o'); 
        plot(t6, r78, 'g-.+');
        legend('r67', 'r78');
    end
end