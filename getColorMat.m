function colorMat = getColorMat(config)
% Constructing the intrinsic value matrix based on the config variable.
    colorMat = zeros(config.Environment.number_of_agents);
    color = config.Model.color' * config.Model.color;
    colorMat(color == 1) =  config.Model.w(1);
    colorMat(color == 2) =  config.Model.w(2);
    colorMat(color == 4) =  config.Model.w(3);
end