% clear
clc;clear;

% import
data = importdata("./data.txt");

%=============================================> num-1
dataMin = min(data);
dataMax = max(data);
step = dataMax - dataMin + 1;

xList = linspace(dataMin, dataMax, step);
% histogram(data, 13);
%=============================================> num-2
% generate random testSet
index = randperm(10000, 1000);
testSet = [];
i = 1;
while i <= 1000
    testSet = [data(index(i)), testSet];
    i = i + 1;
end

% testify
lambda = poissfit(testSet);
%=============================================> num-3
% generate 1000 e(x) list.
selectSet = [];
for i=1:1000
    index30 = randperm(10000,30);
    j = 1;sum30 = 0;
    while j <= 30
        sum30 = sum30 + data(index30(j));
        j = j + 1;
    end
    selectSet = [sum30 / 30, selectSet];
    % selectSet = sort(selectSet);
end
% step & xList
minSelect = min(selectSet);
maxSelect = max(selectSet);
selectStep = ceil((maxSelect - minSelect) / 0.2);
selectList = linspace(minSelect,maxSelect,selectStep);
%=============================================> num-4
% para
mu = mean(selectSet);
sigma = std(selectSet);
n = 1000;p = 0.95;
chi2 = chi2inv(p,length(selectList)-4);
averageX = mean(selectSet);
m = averageX - tinv(p, n-1) * sigma / n^1/2;
n = averageX + tinv(p, n-1) * sigma / n^1/2;

% count
count = [];
for i = 1:(length(selectList) - 1)
    countTemp = numel(selectSet(selectSet >= selectList(i) & selectSet < selectList(i+1)));
    if i == (length(selectList) - 1)
        countTemp = countTemp + 1;
    end
    if countTemp < 5
        fprintf("Modify!\n");
    end
    count = [countTemp, count];
end
% generate normal distribution
pd = makedist("Normal","mu",mu,"sigma",sigma);

% calculate p_i
pSelect = [cdf(pd,selectList(2))];
for i = 3:(length(selectList) - 1)
    pSelect = [cdf(pd,selectList(i)) - cdf(pd,selectList(i-1)), pSelect];
end
pSelect = [1-sum(pSelect), pSelect];
% sum(pSelect)

% final calc
finalList = [];
tempList = [];
for i = 1:(length(selectList)-1)
    temp = 1000 * pSelect(i);
    tempList = [temp, tempList]; 
    final = (count(i) - temp).^2 / temp;
    finalList = [final, finalList];
    % save in excel
end

%================> print result
fprintf("=============================第四题=======================================\n");
fprintf("分组编号i    质点数ni    概率估计pi    期望观测数n*pi    (ni-n*pi)^2/(n*pi)\n");
for i = 1:length(count)
    fprintf("%8d %11d %13f %16f %16f\n",...
    i,count(i),pSelect(i),tempList(i),finalList(i));
end
fprintf("==========================================================================\n");
fprintf("总和:%3d %11d %13f %16f %16f\n",length(count),sum(count),sum(pSelect),sum(tempList),sum(finalList));

fprintf("卡方%f 计算%f\n",chi2,sum(finalList));
