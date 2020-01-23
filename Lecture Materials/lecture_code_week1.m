%% Lecture code -- Week 1
% Single percent signs serve as comments.  

%  We will use .m files for lecture and homework.
%  Homework will be mlx, Live Markdown documents.
%  Project will be LaTeX. More details on website.


%% Double percent signs create sections in code (not in mlx files)

% Simple math.  
a = 2
b = 6
a*b
a/b
a^2
a-b

%%
a = 3

% Note the difference when I use a semicolon
a = 3;

%% 
% If you want to see your variables, here are the commands:

who
whos

% help:  tells you how to use a function
help var
%% 
% Vectors and matrices can be created in different ways.


a = [1 2 3 4 10]
size(a)
num_seq = 1:5:20

% Grab the 3 element of a vector
num_seq(3)

% Create a matrix from a vector.  Pay attention to how the numbers are
% filled in
newmat = reshape(num_seq, 2, 2)
% Quick way to make a matrix a vector (again, pay attention to how vector is created)
newmat(:)

% You can use the transpose to swap rows and columns of a matrix

mat = reshape(1:4, 2, 2)
mat'
%% 
% Element-wise math is done by adding a period before the command.


b = [1 2 3 4 10];
1./b
1./mat
%% 
% *On your own:* Create a 4x4 matrix that has the numbers 1-16 such that 
% the first *row*  is 1 2 3 4, second row is 5 6 7 8, etc.  



% You can create a matrix of 1's easily

ones(5, 2)

ones(3,8)

zeros(3,4)

%% 
% It is easy to extract and change portions of a matrix.


mat = reshape(1:16, 4, 4)

% First row
mat(1,:)

% First column
mat(:,1)

% First row, First column entry
mat(1,1)

% replace first column with 5
mat(:,1)=5

% "end" is a really great feature in MATLAB.  
% Automatically goes to the highest index
mat(end,end)

% You can also identify (T/F) where certan values occur

mat>10

mat2 = reshape(-2:1, 2,2);
% Change the negative values to 0
mat2
mat2(mat2<0) = 0
% For element-wise multiplication. Subtraction and addition are elementwise

% Also, "rand" generates random values from a uniform distribution
c = rand(2,2);
d = rand(2,2);

c+d
c.*d
% Notice things are different without the . with multiplication and
% squaring
c*d
c.^2
%% 
% *On your own:  *Figure out what the c^2 command (below) is doing.  You 
% can probably figure it out without googling or looking at help.

c^2

%% 
% I recommend you don't use the division symbol (either / or \), unless using element-wise division.  
% Just be careful if you do use it, it may not be intuitive to you, but it is 
% shorthand for solving systems of equations.  FYI, here's what it does:


a = reshape(1:4, 2, 2);
b = reshape(6:9, 2, 2);

a\b
pinv(a)*b
inv(a'*a)*a'*b

a/b
a*pinv(b)
a*inv(b'*b)*b'


%% 
% Random numbers aren't really random!  If we all ran this on a fresh MATLAB 
% session, we'd get the same number.  You need to be careful if you really need 
% random numbers.  Run rng('shuffle') before running the random number generators.  
% Note:  There are multiple fixes for this problem.|  |
%%
rand(1)
%% 
% *On your own: * What is the difference between rand() and randn().  Use 
% the help function to figure it out.  
% 
% We won't use characters much in this class, but it is worth pointing out 
% their odd behavior.
%%
% Characters
char1 = 'hi'

char2 = '3'
% careful!  This gives a numeric answer
char2*3
%% 
% Loops!  According to the class survey, most of you have written loops 
% before, so this probably won't be very different from what you've done in the 
% past.


for i=1:3
    i
end



% Looping through matrices can often be avoided, but is sometimes necessary

a = reshape(1:16, 4, 4);
for x = 1:4
    for y = 1:4
        a(x,y)
    end
end

% For example, squaring entries (and most mathematical operations) in a 
%  matrix via looping is not efficient

a_squared = zeros(4,4);
for x = 1:4
    for y = 1:4
        a_squared(x,y) = a(x,y)^2;
    end
end

%vs

% TO make an operation work element-wise, use a .
a_squared_easy = a.^2;

a_squared
a_squared_easy



b = reshape([1:8], 2, 2,2)
reshape(b, 2, 4)

%% if/else statements

num = 0;

if num<0
    disp('Number is negative')
elseif num >0
    disp('Number is positive')
else
    disp('Number is 0')
end  
%% 
% *On your own:  *Create a 1x10 row vector of random numbers using randn 
% (this generate normal values and loop through each value and print whether the 
% value is pos, neg or 0.
% 
% 
% 
% *Also on your own:  *Without using a loop, start with the same vector you 
% made in the last exercise and create a new vector (of the same size) that has 
% a 1 if the original value was positive and -1 if the original value was negative
% 
% You can compute min/max/mean/sd of columns of a matrix easily.
%%

a = randn(4,4);
a
min(a)
max(a)
mean(a)
std(a)
%% 
% *On your own* :Look at help or use what we already know to get the row 
% min/max

min(a')
min(a(:))

%% 
% 3 Dimensional arrays and the squeeze function.  We will also encounter 
% 3D arrays when our images are in RGB format.  The first two dimensions are the 
% 2 dimensions of space and 3rd is R, G or B values for that pixel.  You make 
% arrays the same way we made matrices.

array_ex = reshape(1:60, 5, 4, 3);
size(array_ex)


% Sometimes you'll find you're trying to work with a smaller portion of 
% an array that has a singleton dimension and you'd like to get rid of it.  

array_singleton_dim = ones(2, 1, 3);
size(array_singleton_dim)  % This is really a 2x3
%use squeeze to remove the singleton dimension
sq_array_singleton_dim = squeeze(array_singleton_dim);
size(sq_array_singleton_dim)
%% 
% Plotting data.


x = randn(1,10);
y = randn(1,10);

figure
plot(x,y)
%% 
% I'm about to add another plot here.  If you were just running this code 
% in the terminal OR using the "publish" option to publish the code you'd want 
% to start a new figure window with the figure command.  I've added it here, but 
% you won't see what I mean unless you run it (twice) in the terminal, so try 
% that out.

% Make points
figure % invokes a new figure
plot(x,y, '.')
% Change to plotting circles.
plot(x,y, 'o')
% multiple panel plots can be made with subplot

figure
subplot(2,2,1)
plot(x,y)
title('Plot 1: no point specification')
subplot(2,2,2)
plot(x,y, '.')
title('Plot 2: plot points')
subplot(2,2,3)
plot(x,y, 'o')
title('Plot 3: open circles')
subplot(2,2,4)
plot(x,y, 'g*')
title('Plot 4: star points')

%% 
% When using mlx, you'll want to use "figure" before each new figure or
% your output will not have all of the figures.  I often don't use "figure"
% for each new figure if I'm using .m because I end up with too many
% windows.

% Plotting multiple lines

x=(-2*pi):0.1:(2*pi);

figure
plot(x, sin(x))

figure
plot(x, sin(x), 'g.') % points

figure
plot(x, sin(x), 'g-') % line plot

% Add labels
plot(x, sin(x))
xlabel('x', 'Fontsize', 20)
ylabel('sin(x)')

% plot 2 lines and add legend
plot(x, sin(x), 'r')
hold on
plot(x, cos(x), 'b')
hold off
legend('sin(x)', 'cos(x)')

hold on
plot(x, 5*cos(x), 'g')
hold off

% To change font size in legend and linewidth
plot(x, sin(x), 'r', 'linewidth', 3)
hold on
plot(x, cos(x), 'b', 'linewidth', 3)
hold off
h_legend = legend('sin(x)', 'cos(x)');
set(h_legend, 'fontsize', 16)
%% 
% Mostly we'll be plotting images.  Here I'll use imagesc() and I'll also introduce 
% you to the meshgrid command.  Images are basically 3 dimensional data sets where 
% 2 dimensions indicate location and the 3rd is 
% the grayscale value (or color value within a color channel).  
% 
% The meshgrid command is a handy tool if you need to generate a matrix with 
% the row/column indices.  Let's say your image has 3 row and 5 columns, 
% so the resulting image would be 3 x 5.  Here's how you get matrices of the indices.  


x=1:3;
y=1:5;
[x_grid, y_grid] = ndgrid(x,y);

size(x_grid)
size(y_grid)
x_grid
y_grid

% To plot each of these side-by-side I'll use subplot
subplot(1,2,1)
imagesc(x_grid)
subplot(1,2,2)
imagesc(y_grid)


