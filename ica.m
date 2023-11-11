function [optimal_weights] = ica(fitfunc, dim, lb, ub, n_countries, n_generations)
    % Initialize country population
    population = lb + (ub - lb) .* rand(n_countries, dim);
    
    % Evaluate initial population
    fitness = zeros(n_countries, 1);
    for i = 1:n_countries
        fitness(i) = fitfunc(population(i, :));
    end
    
    % Initialize imperialists and colonies
    [fitness, sorted_indices] = sort(fitness);
    population = population(sorted_indices, :);
    n_imperialists = round(0.1 * n_countries);
    n_colonies = n_countries - n_imperialists;
    
    % Firefly algorithm main loop
    for t = 1:n_generations
        for i = 1:n_imperialists
            for j = 1:n_colonies
                if fitness(i) < fitness(n_imperialists + j)
                    % Update position
                    population(n_imperialists + j, :) = population(n_imperialists + j, :) + rand * (population(i, :) - population(n_imperialists + j, :));
                    
                    % Boundary check
                    population(n_imperialists + j, :) = max(population(n_imperialists + j, :), lb);
                    population(n_imperialists + j, :) = min(population(n_imperialists + j, :), ub);
                    
                    % Update fitness
                    fitness(n_imperialists + j) = fitfunc(population(n_imperialists + j, :));
                end
            end
        end
        
        % Update global best country
        [min_fitness, min_index] = min(fitness);
        optimal_weights = population(min_index, :);
    end
end
