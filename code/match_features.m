% Local Feature Matching Code
% Written by James Hays, Georgia Tech
% Modified for Octave by Jon Denning, Taylor University


% 'features1' and 'features2' are the n x feature dimensionality features
%   from the two images.
% If you want to include geometric verification in this stage, you can add
% the x and y locations of the features as additional inputs.
%
% 'matches' is a k x 2 matrix, where k is the number of matches. The first
%   column is an index in features 1, the second column is an index
%   in features2. 
% 'Confidences' is a k x 1 matrix with a real valued confidence for every
%   match.
% 'matches' and 'confidences' can empty, e.g. 0x2 and 0x1.
function [matches, confidences] = match_features(features1, features2)

% This function does not need to be symmetric (e.g. it can produce
% different numbers of matches depending on the order of the arguments).

% To start with, simply implement the "ratio test", equation 4.18 in
% section 4.1.3 of Szeliski. For extra credit you can implement various
% forms of spatial verification of matches.

% Placeholder that you can delete. Random matches and confidences
%num_features = min(size(features1, 1), size(features2,1));
%matches = zeros(num_features, 2);
%matches(:,1) = randperm(num_features); 
%matches(:,2) = randperm(num_features);
%confidences = rand(num_features,1);

% Change this according to the image, hard to tune
threshold = 0.83;

% Create matrix for good matches
matches = zeros(length(features1), 2);
% Matrix for level of confidence
confidences = zeros(length(features1), 1);

%Loop through indexes in image 1
for i = 1:length(features1)
    % Repeat current feature over size of features 2 matrix
    % http://www.mathworks.com/help/matlab/ref/repmat.html
    temp_features_set = repmat(features1(i,:), length(features2), 1);   
    % Calculate distances of features from the current feature
    distances = sqrt(sum((temp_features_set - features2).^2, 2));
    %Sort distances by ascending order
    [sortdist, indices] = sort(distances, 'ascend');
    % Compare the shortest distance to the second shortest
    ratio = sortdist(1) / sortdist(2);
    % If the ratio is less than our threshold, we have a fairly confident
    % match
    if ratio < threshold
        matches(i,:) = [i,indices(1)];
        confidences(i) = 1 - ratio;
    end
end

% Find values where we have a confidence greater than 0
matched = find(confidences > 0);
% Return array of matches based upon values where confidence is good enough
matches = matches(matched, :);
confidences = confidences(matched);

% Sort the matches so that the most confident onces are at the top of the
% list. You should probably not delete this, so that the evaluation
% functions can be run on the top matches easily.
[confidences, ind] = sort(confidences, 'descend');
matches = matches(ind,:);