clear all;clc;
time = 20;

N = 2000;
Pp = 0.05;
Pn = 0.05;

count_p = floor(N*Pp);
count_n = floor(N*Pn);
count_f = N-count_p-count_n;

xp = rand(1,count_p)-0.5;
xn = rand(1,count_n)-0.5;
xf = rand(1,count_f)-0.5;

alaph = 0.4;
beta = 0.4;

elta_p = 0.25;
elta_n = 0.25;
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
      temp_f = abs(xf-xf(j))<=elta_f(j);
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
      temp_xp = abs(xp-xp(m))<=elta_p;
      xp(m) = (1-w)*sum(xp.*temp_xp)/sum(temp_xp)+w*d;
   end
   
   for n = 1:count_n
      temp_xn = abs(xn-xn(n))<=elta_n;
      xn(n) = (1-z)*sum(xn.*temp_xn)/sum(temp_xn)+z*g;
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

axis([0 20 -0.75 0.75])




