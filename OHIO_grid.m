
% Load the shapefile using shaperead
S= shaperead('ODOT_County_Boundaries.shp');

% Get the bounding box of the shapefile
bbox = [S.BoundingBox];
min_x = -85;
max_x = -80.5;
min_y = 38;
max_y = 42;

% Calculate the number of intervals for 60 grid lines
num_intervals_x = 51 - 1; % Subtract 1 because the edges are included
num_intervals_y = 51 - 1;

% Calculate the grid spacing
grid_spacing_x = (max_x - min_x) / num_intervals_x;
grid_spacing_y = (max_y - min_y) / num_intervals_y;

% Create the vectors for grid lines
x_grid = linspace(min_x, max_x, 51); % 61 points including the boundaries for 60 intervals
y_grid = linspace(min_y, max_y, 51); % Same for y

% Plot the shapefile using mapshow or geoshow
figure;
mapshow(S);
hold on;

% Draw the vertical grid lines
for i = 1:length(x_grid)
    plot([x_grid(i) x_grid(i)], [min_y max_y], 'k-', 'LineWidth', 0.5);
end

% Draw the horizontal grid lines
for i = 1:length(y_grid)
    plot([min_x max_x], [y_grid(i) y_grid(i)], 'k-', 'LineWidth', 0.5);
end

% Set the axis tick marks to every 5th grid line
xtick_indices = 1:5:51; % Indices for every 5th line starting from 1
ytick_indices = 1:5:51; % Same for y

xticks(x_grid(xtick_indices));
yticks(y_grid(ytick_indices));

% Set the tick labels to go from 1 to 60, but only at every 5th position
xticklabels(0:5:50);
yticklabels(0:5:50);

% Adjust the axis limits
xlim([min_x max_x]);
ylim([min_y max_y]);

% Set the axis labels and title with larger font and bold text
xlabel('Columns', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Rows', 'FontSize', 14, 'FontWeight', 'bold');
title('Shapefile with Superimposed Grid', 'FontSize', 16, 'FontWeight', 'bold');

% Make the xticks and yticks bolder
ax = gca; % Current axes
ax.FontSize = 12; % Change the font size if needed
ax.FontWeight = 'bold'; % Make tick labels bolder

% Remove the hold on the plot
hold off;