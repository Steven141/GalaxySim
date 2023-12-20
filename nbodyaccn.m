% m: Vector of length N containing the core masses
% r: N + ns x 3 array containing the core + star positions
% a: N + ns x 3 array containing the computed core + star accelerations
function [a] = nbodyaccn(m, r)
    a = zeros(size(r, 1), 3);
    for i = 1 : size(r, 1)
        for j = 1 : length(m)
            if i == j
                continue
            end

            rij3 = norm((r(j,:) - r(i,:)))^3;

            a(i,:) = a(i,:) + m(j) * (r(j,:) - r(i,:)) / (rij3);
        end
    end
end