%% 
%     COURSE: Master MATLAB through guided problem-solving
%    SECTION: Getting started
%      VIDEO: Using MATLAB for a personal budget
% Instructor: mikexcohen.com
%
%%

% monthly income (post-tax)
income = 2500;


% list monthly expenses
rent  = 1200;
utils =  300; % water, electricity, internet, etc.
car   =  250; % gas and insurance
food  =  300; % assuming 75/week
phone =   50; % gotta have unlimited downloads!
retirement = income * 0.1; % you should be saving 10% of your income!


% total monthly expenditures
outflow = rent + utils + car + food + phone + retirement;

% amount left over for nonessential expenses
nonessentials = income - outflow;


% how much can you spend per day?
perday = nonessentials/30.0;
disp([ 'I can spend ' num2str(perday) ' extra each day.' ])


% what if you spend twice as much during the weekend as during the week?

%%

perweek = nonessentials / (30/7);
inThirds = perweek /3;
weekend = inThirds * 2;
weekday = inThirds / 5;



