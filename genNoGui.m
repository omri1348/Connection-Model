function genNoGui(config,generations)
    config.Processing.max_number_of_generations = generations;
    genetic(config);
end