% Uncomment the simulation you want to run
function simGalaxy()
    % Single Galaxy Moving Circular Orbit Check
    %[t r v] = galaxy(1, 30, [1], 10, [-15 -15 0], [1 1 0], 50);

    % Unravel Collision Sim
    %[t r v] = galaxy(2, 40, [0.5 0.5], 11, [-3.5 -3.5 0; 3.5 3.5 0], [0.4 0 0; -0.4 0 0], 5000); 

    % Stars Escape Collision Sim
    %[t r v] = galaxy(2, 140, [0.5 0.5], 11, [-4 -4 0; 4 4 0], [0.2 -0.05 0; -0.2 0.05 0], 5000);  

    % No Lost Stars Collision Sim
    [t r v] = galaxy(2, 60, [0.5 0.5], 11, [-3.2 -3.8 0; 3.2 3.8 0], [0.3 0 0; -0.3 0 0], 5000); 
end