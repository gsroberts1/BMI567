%% Lecture code for week 2 -- Statistics review
% Code by JEANETTE A MUMFORD
% (with a few minor changes by Daniel Pimentel)

% How the mean works
total_sales = [149 406 183 107 426 97]
mean(total_sales)

% This is review....
% If you have a matrix, mean computes means across columns
fake_data = rand(100, 10);
mean(fake_data)
% This is a quick way to get mean across rows
mean(fake_data')

fake_data2 = rand([100, 10, 3]);
test = mean(fake_data2);  

% example of when squeeze is helpful
size(test)

% squeeze can get rid of dimensions of 1
test2 = squeeze(test);
size(test2)

% Take the mean along other dimensions
junk = mean(fake_data2, 2);
size(junk)



%% Read in data, compute mean of first column, 
%  plot histogram

% Fix this path to match where you stored the file on your computer
% USE TAB TO AUTOCOMPLETE PATHS TO AVOID TYPOS!!!

load dat.mat
size(dat)  

% We'll only focus on the first column
mn_col1 = mean(dat(:,1))

figure
hist(dat(:,1))
set(get(gca, 'child'), 'facecolor', 'none')
hold on
plot(mn_col1, 0, 'red*', 'markersize', 20)
hold off

% look at the second column
mn_col2 = mean(dat(:,2));

figure
hist(dat(:,2), 20)
set(get(gca, 'child'), 'facecolor', 'none')
hold on
plot(mn_col2, 0, 'red*', 'markersize', 20)
hold off

lt_15 = dat(:,2)<15;
hist(dat(lt_15, 2))

% Outliers appear to be present.  
% How do they impact mean?
%% In class exercise
% Subset the second column and look at average
% over values less than 15 (this will omit the 
% two outliers)
% Do the means seem to differ?

col2 = dat(:,2);
col2_lt15 = col2(col2<15);

mean(col2)
mean(col2_lt15)

median(col2)
median(col2_lt15)

var(col2)
var(col2_lt15)

%% Variance and sd

var(dat(:,1))
var(dat(:,2))

std(dat(:,1))
sqrt(var(dat(:,1)))

%% In class exercise:How does the variance change
%   for the data in the second column when the
%   outliers are omitted?


%(go back to slides)
%% Law of large numbers

% Use MATLAB to flip a coin!
% Remember the Uniform distribution?  
% if <0.7 = Heads and >=0.7 = Tails 
% (unfair coin)

% One experiment = 10 flips of coin and we count how many heads
%  Let's repeat the experiment 10,000 times

flips = rand(10000, 10);
flips(flips<0.7) = 0;
flips(flips>=.7) = 1;

% compute the P(T) for each of the 10,000 experiments

pt_exp = mean(flips');

% compute the average p_flips for 1 experiment, 2, 3, etc... up to 10,000
% and plot
cum_avg = zeros(1, 1000);
for n=1:10000
    cum_avg(n) = mean(pt_exp(1:n));
end

figure
plot(cum_avg)

cum_avg2 = cumsum(pt_exp)./[1:10000];


%% Contstruct the Binomial pdf and then compute different
%% probabilities

% What is the number of trials?
n_trials = 6;
% Probability of opinion 
prob = .3 % means yes they have the opinion

% range of the random variable
x = 0:n_trials;

y = binopdf(x, n_trials, prob)

figure
bar(x, y)

%P(exactly 3)
binopdf(3, n_trials, prob)

%P(at most 2)
binocdf(2, n_trials, prob)

%P(at least 3)
binocdf(2, n_trials, prob, 'upper')

1-binocdf(2, n_trials, prob)


% Change p to 0.5 and also look at greater than 0.5, how does the
% probability distribution change??

n_trials = 6;
% Probability of opinion 
prob = .9 % means yes they have the opinion
% range of the random variable
x = 0:n_trials;
y = binopdf(x, n_trials, prob)
figure
bar(x, y)

