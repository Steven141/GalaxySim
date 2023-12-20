% N: number of cores
% tmax: Final solution time
% m: array with N core point masses
% level: Discretization level
% r0: N x 3 array of initial positions of core points
% v0: N x 3 array of initial velocities of core points
% ns: number of stars per core
% t: returns array of times
% r: returns array of positions
% v: returns array of velocities
function [t r v] = galaxy(N, tmax, m, level, r0, v0, ns)
    format long;
    avienable = 0;
    plotenable = 1;
    avifilename = 'galaxy.avi';
    aviframerate = 25;

    if avienable
        aviobj = VideoWriter(avifilename);
        open(aviobj);
    end

    nostars = ns == 0;

    nt = 2^level + 1;
    t = linspace(0.0, tmax, nt);
    dt = tmax / 2^level;
    dlim = 0.15;
    Ntot = N + ns * N;

    % r(particle i, x y or z cord, time step)
    r = zeros(Ntot, 3, nt);
    v = zeros(Ntot, 3, nt);

    % Initial Conditions r^1
    r(1:N,:,1) = r0;
    v(1:N,:,1) = v0;

    if ~nostars
        % ICs for mutual circular orbit
        secstart = N+1;
        secend = N+ns;
        for i = 1 : N
            rmin = 1.5;
            rmax = 3;
            rs = rmin + (rmax - rmin) * rand(ns, 1);
            theta = 2 * pi * rand(ns, 1);
            vs = sqrt(m(i) * rs) ./ rs;

            rx = rs .* cos(theta);
            ry = rs .* sin(theta);
            vx = -vs .* sin(theta);
            vy = vs .* cos(theta);

            r(secstart:secend,:,1) = [rx ry zeros(ns, 1)] + r0(i,:);
            v(secstart:secend,:,1) = [vx vy zeros(ns, 1)] + v0(i,:);

            % Shift the window
            secstart = secstart + ns;
            secend = secend + ns;
        end
    end

    % Calculate r^2
    r(:, :, 2) = r(:,:,1) + dt*v(:,:,1) + dt^2 * nbodyaccn(m, r(:,:,1)) / 2.0;

    % Core has a (marker) size of 10 ...
    coresize = 20;
    starsize = 1;
    % ... it's red ...
    core1color = 'g';
    core2color = 'm';
    star1color = 'g';
    star2color = 'm';
    % ... and it's plotted as a circle.
    coremarker = 'o';

    pausesecs = 0.01;

    for n = 2 : nt - 1
        % ------------ Graphics ------------
        if plotenable
            clf;
            hold on;
            axis equal;
            box on;
            lim = 20;
            xlim([-dlim - lim, lim + dlim]);
            ylim([-dlim - lim, lim + dlim]);

            titlestr = sprintf('Step: %d   Time: %.3f', fix(n), t(n));
            title(titlestr, 'FontSize', 16, 'FontWeight', 'bold', ...
               'Color', [0.25, 0.42, 0.31]);

            if N == 2
                plot(r(1,1,n), r(1,2,n), 'Marker', coremarker, 'MarkerSize', coresize, ...
                    'MarkerEdgeColor', core1color, 'MarkerFaceColor', core1color, 'LineStyle', 'none');
                plot(r(2,1,n), r(2,2,n), 'Marker', coremarker, 'MarkerSize', coresize, ...
                    'MarkerEdgeColor', core2color, 'MarkerFaceColor', core2color, 'LineStyle', 'none');
                plot(r(3:2+ns,1,n), r(3:2+ns,2,n), 'Marker', coremarker, 'MarkerSize', starsize, ...
                    'MarkerEdgeColor', star1color, 'MarkerFaceColor', star1color, 'LineStyle', 'none');
                plot(r(3+ns:2+ns*2,1,n), r(3+ns:2+ns*2,2,n), 'Marker', coremarker, 'MarkerSize', starsize, ...
                    'MarkerEdgeColor', star2color, 'MarkerFaceColor', star2color, 'LineStyle', 'none');
            elseif N == 1
                plot(r(1,1,n), r(1,2,n), 'Marker', coremarker, 'MarkerSize', coresize, ...
                    'MarkerEdgeColor', core1color, 'MarkerFaceColor', core1color, 'LineStyle', 'none');
                plot(r(2:1+ns,1,n), r(2:1+ns,2,n), 'Marker', coremarker, 'MarkerSize', starsize, ...
                    'MarkerEdgeColor', star1color, 'MarkerFaceColor', star1color, 'LineStyle', 'none');
            end

            drawnow;

            if avienable
                if t(n) == 0
                    framecount = 5 * aviframerate ;
                else
                    framecount = 1;
                end
                for iframe = 1 : framecount
                    writeVideo(aviobj, getframe(gcf));
                end
            end
        end
        
        % ------------ Dynamics ------------

        r(:,:,n+1) = dt^2 * nbodyaccn(m,r(:,:,n)) + 2*r(:,:,n) - r(:,:,n-1);
        v(:,:,n) = (r(:,:,n+1) - r(:,:,n-1)) / (2*dt);
    end
    
    % Use linear extrapolation to determine the value of v at the
    % final time step.
    v(:,:,nt) = 2 * v(:,:,nt-1) - v(:,:,nt-2);

    if avienable
        close(aviobj);
        fprintf('Created video file: %s\n', avifilename);
    end
end