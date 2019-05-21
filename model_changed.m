clear all;clc;
time = 20;

N = 2000;
Pp = 0.05;
Pn = 0.05;

count_p = floor(N*Pp);
count_n = floor(N*Pn);
count_f = N-count_p-count_n;

%意见领袖置信度
xp = unifrnd(0.2,1,1,count_p);
xn = unifrnd(-1,-0.2,1,count_n);

%追随者置信度正态分布
xf1 = normrnd(0,0.16,[1,3000]);
xf2 = xf1(xf1>-1 & xf1<1);
xf = xf2(1:count_f);

%是否活跃

G = rand(1,count_f);
G(G>0.5)=1;
G(G<0.5)=0;

alaph = 0.4;
beta = 0.4;

%positive和negative内外圈不同取值
elta_p1 = 0.1;
elta_p2 = 0.25;
elta_n1 = 0.1;
elta_n2 = 0.25;
elta_f = rand(1,count_f)*0.5;

d = 0.5;
g = -0.5;
w = 0.5;
z = 0.5;

matrix_f = [xf];
matrix_p = [xp];
matrix_n = [xn];

for i = 1:time
   for j = 1:count_f
      temp_f = (abs(xf-xf(j))<=elta_f(j)).*G; %增加是否活跃的判定
      temp_p = abs(xp-xf(j))<=elta_f(j);
      temp_n = abs(xn-xf(j))<=elta_f(j);
      if sum(temp_f)==0
          result_f = 0;
      else
          result_f = sum(temp_f.*xf)/sum(temp_f);
      end
          
      if sum(temp_p)==0
          result_p = 0;
      else
          result_p = sum(temp_p.*xp)/sum(temp_p);
      end
          
      if sum(temp_n)==0
          result_n = 0;
      else
          result_n = sum(temp_n.*xn)/sum(temp_n);
      end
      
      xf(j) = (1-alaph-beta)*result_f + alaph*result_p + beta*result_n;
   end
    
   for m = 1:count_p
      temp_xp1 = abs(xp-xp(m))<=elta_p1;
      temp_xp2 = (abs(xp-xp(m))<=elta_p2);
      temp_xp2 = (abs(temp_xp2-xp(m))>elta_p1);
      
      if sum(temp_xp1)==0
          result_xp1 = 0;
      else
          result_xp1 = sum(temp_xp1.*xp)/sum(temp_xp1);
      end
      
      if sum(temp_xp2)==0
          result_xp2 = 0;
      else
          result_xp2 = sum(temp_xp2.*xp)/sum(temp_xp2);
      end
      
      xp(m) = ((1-w)*result_xp1+w*d)*0.5+((1-w)*result_xp2+w*d)*0.5; %假设内外圈各占50的计算结果
   end
   
   for n = 1:count_n
      temp_xn1 = abs(xn-xn(n))<=elta_n1;
      temp_xn2 = (abs(xn-xn(n))<=elta_n2);
      temp_xn2 = (abs(temp_xn2-xn(n))>elta_n1);
      
       if sum(temp_xn1)==0
          result_xn1 = 0;
      else
          result_xn1 = sum(temp_xn1.*xn)/sum(temp_xn1);
      end
      
      if sum(temp_xn2)==0
          result_xn2 = 0;
      else
          result_xn2 = sum(temp_xn2.*xn)/sum(temp_xn2);
      end
      
      xn(n) = ((1-z)*result_xn1+z*g)*0.5+((1-z)*result_xn2+z*g)*0.5; %假设内外圈各占50的计算结果
   end
   matrix_f = [matrix_f;xf];
   matrix_p = [matrix_p;xp];
   matrix_n = [matrix_n;xn];
    
end
for i = 1:count_f
   plot(0:20,matrix_f(:,i)','-b')
   hold on
end

for i = 1:count_p
   plot(0:20,matrix_p(:,i)','-r')
   hold on
end

for i = 1:count_n
   plot(0:20,matrix_n(:,i)','-k')
   hold on
end
grid on

axis([0 20 -1 1])




