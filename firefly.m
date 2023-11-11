function [optimal_weights] = firefly(fitfunc, dim, lb, ub, n_fireflies, n_generations)
    % Initialize firefly population
    population = lb + (ub - lb) .* rand(n_fireflies, dim);
    
    % Evaluate initial population
    fitness = zeros(n_fireflies, 1);
    for i = 1:n_fireflies
        fitness(i) = fitfunc(population(i, :));
    end
    
    % Initialize light intensity
    light_intensity = 1 ./ (fitness + 1);
    
    % Initialize attractiveness
    attractiveness = light_intensity;
    
    % Firefly algorithm main loop
    for t = 1:n_generations
        for i = 1:n_fireflies
            for j = 1:n_fireflies
                if light_intensity(i) < light_intensity(j)
                    % Update position
                    population(i, :) = population(i, :) + rand * (population(j, :) - population(i, :));
                    
                    % Boundary check
                    population(i, :) = max(population(i, :), lb);
                    population(i, :) = min(population(i, :), ub);
                    
                    % Update fitness
                    fitness(i) = fitfunc(population(i, :));
                    
                    % Update light intensity and attractiveness
                    light_intensity(i) = 1 / (fitness(i) + 1);
                    attractiveness(i) = light_intensity(i);
                end
            end
        end
        
        % Update global best firefly
        [min_fitness, min_index] = min(fitness);
        optimal_weights = population(min_index, :);
    end
end
