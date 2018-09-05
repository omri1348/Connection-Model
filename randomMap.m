function membMap = randomMap(nAgents)
% Creates a random environment
    membMap = rand(nAgents);
    membMap = double((membMap - tril(membMap)) > 0.5);
    membMap = membMap + membMap';
end