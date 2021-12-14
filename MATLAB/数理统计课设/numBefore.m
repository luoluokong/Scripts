clc;clear;
format short;%%%输出短格式，小数点后保留4位。
%%%第一问
data = importdata('data.txt');%%%引入数据
in = min(data); ax = max(data); group = ax - in + 1;
x = linspace(in,ax,group);
mapping(data,in,ax,group,'g');%%绘图
%%%%%%%%%%%%%%%%%%%%%%%%第二问
q = randperm(10000,1000);%产生1000个随机数作为下标索引
data_1 = [];i = 1;
while i <= 1000    %根据索引抽取data中的数
    data_1 = [data(q(i)),data_1];    i = i + 1;
end
counts_1 = mapping(data_1,in,ax,group,'g')%作图，利用counts_1计数，为期望观测数
%%%%Matlab内置函数检验
lambda = poissfit(data_1);%基于泊松分布的MLE，计算泊松分布参数lambda
fprintf("泊松分布的概率估计值为%s",num2str(lambda));
pd = fitdist(x','Poisson','Frequency',counts_1');
expCounts = 1000 * pdf(pd,x);
[h,p_1,st] = chi2gof(x,'Ctrs',x,...
                        'Frequency',counts_1, ...
                        'Expected',expCounts,...
                        'NParams',1,'Alpha',0.05)%%%%%%%%%%%%sbMatlab内置函数怎么这么多？这也有内置函数？？？？？？？ccccccfuck
if h==0
    disp("服从泊松分布");
else
    disp("不服从泊松分布");
end
%%%据理论自行检验
OutPut(x,counts_1);%绘制表格
fP = @(x) (lambda ^ x) * exp(-lambda) / factorial(x);%%泊松分布概率估计值函数
for i = 1:13     %%泊松分布概率估计值
    p(i) = fP(i - 1);
end
p=poisspdf(x,lambda);
for i = 1:13     %(ni-np)^2/np
    tjl(i) = (counts_1(i) - 1000 * p(i)) ^ 2 / (1000 * p(i));
end
p = ntsum(p);
counts_1 = ntsum(counts_1);%%合并，观测数为9-12的数值
tjl = ntsum(tjl);tjl(10) = (counts_1(10) - 1000 * p(10)) ^ 2 / (1000 * p(10));
l = fitting(x,counts_1,p,tjl);%%绘表
Tj = sum(tjl);fprintf("卡方检验统计量值为%s",num2str(Tj));
if    Tj < chi2inv(0.95,8)      %%%判断是否服从泊松分布
    fprintf("对α = 0.05，可以认为服从参数为%s的泊松分布",num2str(lambda));
else
    fprintf("对α = 0.05，不可以认为服从参数为%s的泊松分布",num2str(lambda));
end
TJF = chi2cdf(Tj,8);fprintf("此处检验的p值为%s",num2str(TJF));%%计算检验的p值
%%%%%%第三问
i = 1;
for i=1:1000     %%循环1000次
    q = [];q = randperm(10000,30);%产生30个随机数作为下标
    data_1 = [];j = 1;
    while j <= 30     %%利用下标索引data中的数，产生30个数
        data_1 = [data(q(j)),data_1];    j = j + 1;
    end
    ValueAnd(i) = sum(data_1) / 30;%记录每次循环产生的数的平均值
end
in = min(ValueAnd);ax = max(ValueAnd);group = ceil((ax - in) / 0.1);
counts_2=mapping(ValueAnd,in,ax,group,'r');%%绘制频数直方图
%%%第四问
mu = sum(ValueAnd) / 1000;
sigma_square = sum((ValueAnd - ones(1,1000) * mu) .^ 2) / 1000;

counts_2 =judge_3(counts_2);

function OutPut(x,y)%%绘制表
fprintf("------------------------------------------------------容量为1000的样本" + ...
    "---------------------------------------------- \n");
fprintf("---------------------------------------------------------------------" + ...
    "---------------------------------------------- \n 质点数 k");
for i = min(x):max(x)
    fprintf("%8d",i);
end
fprintf("\n-------------------------------------------------------------------" + ...
    "------------------------------------------------ \n 观察数 n");
for i = min(x) + 1:max(x) + 1
    fprintf("%8d",y(i));
end
fprintf("\n-------------------------------------------------------------------" + ...
    "------------------------------------------------ \n ");
k = sum(x .* y);n = sum(y);
fprintf("sum(k*n) = %d     sum(n) = %d\n",k,n);
end
%%%合并10-13列，并将11-13列制空
function [a] = ntsum(a)
a(10) = a(10) + a(11) + a(12) + a(13);a(13) = [];a(12) = [];a(11) = [];
end
%%%绘制表
function  [l] = fitting(x,y,p,t)
fprintf("      序号     质点数    观测数    概率估计 期望观测数  (ni-np)^2/np\n");
for j = 1:10
    l(j,1) = x(j) + 1;l(j,2) = x(j);l(j,3) = y(j);l(j,4) = p(j);l(j,5) = sum(y) * p(j);l(j,6) = t(j);
end
disp(l);
end
%%绘图
function [counts] = mapping(x,in,ax,group,c)%%x为基础数据，in为x中最小值,ax为x中最大值,group为h将x分割的组数,c为绘图颜色
y=linspace(in,ax,group);
[counts] = hist(x,y);
b = bar(y,counts,0.6,c);%%默认宽度为0.6
for i = 1:length(y)
    text(y(i),counts(i),num2str(counts(i)),'HorizontalAlignment',...
        'center','VerticalAlignment','bottom');%水平对齐，居中；垂直排列,底部
end
end

function [x]=judge_3(x)
for i = 1:length(x)
    i=1;
    if x(i)< 3
        x(i)=x(i)+x(i+1);
        for j = i+1:length(x)-1
            x(j)=x(j+1);
        end
        x(length(x))=[];
    else
        break
        x=x;
    end
end
for i=length(x):-1:1
    i=length(x);
    if x(i)< 3
        x(i-1)=x(i)+x(i-1);
        x(length(x))=[];
    else
        break
        x=x;
    end
end
end

