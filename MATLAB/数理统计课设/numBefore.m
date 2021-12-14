clc;clear;
format short;%%%����̸�ʽ��С�������4λ��
%%%��һ��
data = importdata('data.txt');%%%��������
in = min(data); ax = max(data); group = ax - in + 1;
x = linspace(in,ax,group);
mapping(data,in,ax,group,'g');%%��ͼ
%%%%%%%%%%%%%%%%%%%%%%%%�ڶ���
q = randperm(10000,1000);%����1000���������Ϊ�±�����
data_1 = [];i = 1;
while i <= 1000    %����������ȡdata�е���
    data_1 = [data(q(i)),data_1];    i = i + 1;
end
counts_1 = mapping(data_1,in,ax,group,'g')%��ͼ������counts_1������Ϊ�����۲���
%%%%Matlab���ú�������
lambda = poissfit(data_1);%���ڲ��ɷֲ���MLE�����㲴�ɷֲ�����lambda
fprintf("���ɷֲ��ĸ��ʹ���ֵΪ%s",num2str(lambda));
pd = fitdist(x','Poisson','Frequency',counts_1');
expCounts = 1000 * pdf(pd,x);
[h,p_1,st] = chi2gof(x,'Ctrs',x,...
                        'Frequency',counts_1, ...
                        'Expected',expCounts,...
                        'NParams',1,'Alpha',0.05)%%%%%%%%%%%%sbMatlab���ú�����ô��ô�ࣿ��Ҳ�����ú�����������������ccccccfuck
if h==0
    disp("���Ӳ��ɷֲ�");
else
    disp("�����Ӳ��ɷֲ�");
end
%%%���������м���
OutPut(x,counts_1);%���Ʊ��
fP = @(x) (lambda ^ x) * exp(-lambda) / factorial(x);%%���ɷֲ����ʹ���ֵ����
for i = 1:13     %%���ɷֲ����ʹ���ֵ
    p(i) = fP(i - 1);
end
p=poisspdf(x,lambda);
for i = 1:13     %(ni-np)^2/np
    tjl(i) = (counts_1(i) - 1000 * p(i)) ^ 2 / (1000 * p(i));
end
p = ntsum(p);
counts_1 = ntsum(counts_1);%%�ϲ����۲���Ϊ9-12����ֵ
tjl = ntsum(tjl);tjl(10) = (counts_1(10) - 1000 * p(10)) ^ 2 / (1000 * p(10));
l = fitting(x,counts_1,p,tjl);%%���
Tj = sum(tjl);fprintf("��������ͳ����ֵΪ%s",num2str(Tj));
if    Tj < chi2inv(0.95,8)      %%%�ж��Ƿ���Ӳ��ɷֲ�
    fprintf("�Ԧ� = 0.05��������Ϊ���Ӳ���Ϊ%s�Ĳ��ɷֲ�",num2str(lambda));
else
    fprintf("�Ԧ� = 0.05����������Ϊ���Ӳ���Ϊ%s�Ĳ��ɷֲ�",num2str(lambda));
end
TJF = chi2cdf(Tj,8);fprintf("�˴������pֵΪ%s",num2str(TJF));%%��������pֵ
%%%%%%������
i = 1;
for i=1:1000     %%ѭ��1000��
    q = [];q = randperm(10000,30);%����30���������Ϊ�±�
    data_1 = [];j = 1;
    while j <= 30     %%�����±�����data�е���������30����
        data_1 = [data(q(j)),data_1];    j = j + 1;
    end
    ValueAnd(i) = sum(data_1) / 30;%��¼ÿ��ѭ������������ƽ��ֵ
end
in = min(ValueAnd);ax = max(ValueAnd);group = ceil((ax - in) / 0.1);
counts_2=mapping(ValueAnd,in,ax,group,'r');%%����Ƶ��ֱ��ͼ
%%%������
mu = sum(ValueAnd) / 1000;
sigma_square = sum((ValueAnd - ones(1,1000) * mu) .^ 2) / 1000;

counts_2 =judge_3(counts_2);

function OutPut(x,y)%%���Ʊ�
fprintf("------------------------------------------------------����Ϊ1000������" + ...
    "---------------------------------------------- \n");
fprintf("---------------------------------------------------------------------" + ...
    "---------------------------------------------- \n �ʵ��� k");
for i = min(x):max(x)
    fprintf("%8d",i);
end
fprintf("\n-------------------------------------------------------------------" + ...
    "------------------------------------------------ \n �۲��� n");
for i = min(x) + 1:max(x) + 1
    fprintf("%8d",y(i));
end
fprintf("\n-------------------------------------------------------------------" + ...
    "------------------------------------------------ \n ");
k = sum(x .* y);n = sum(y);
fprintf("sum(k*n) = %d     sum(n) = %d\n",k,n);
end
%%%�ϲ�10-13�У�����11-13���ƿ�
function [a] = ntsum(a)
a(10) = a(10) + a(11) + a(12) + a(13);a(13) = [];a(12) = [];a(11) = [];
end
%%%���Ʊ�
function  [l] = fitting(x,y,p,t)
fprintf("      ���     �ʵ���    �۲���    ���ʹ��� �����۲���  (ni-np)^2/np\n");
for j = 1:10
    l(j,1) = x(j) + 1;l(j,2) = x(j);l(j,3) = y(j);l(j,4) = p(j);l(j,5) = sum(y) * p(j);l(j,6) = t(j);
end
disp(l);
end
%%��ͼ
function [counts] = mapping(x,in,ax,group,c)%%xΪ�������ݣ�inΪx����Сֵ,axΪx�����ֵ,groupΪh��x�ָ������,cΪ��ͼ��ɫ
y=linspace(in,ax,group);
[counts] = hist(x,y);
b = bar(y,counts,0.6,c);%%Ĭ�Ͽ��Ϊ0.6
for i = 1:length(y)
    text(y(i),counts(i),num2str(counts(i)),'HorizontalAlignment',...
        'center','VerticalAlignment','bottom');%ˮƽ���룬���У���ֱ����,�ײ�
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

