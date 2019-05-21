clear all;clc;
time = 20;

N = 2000;
Pp = 0.05;
Pn = 0.05;
P_circle = 0.25;

%人群分片
count_p = floor(N*Pp);
count_p_in = floor(count_p*P_circle);
count_p_out = count_p-count_p_in;

count_n = floor(N*Pn);
count_n_in = floor(count_n*P_circle);
count_n_out = count_n-count_n_in; 

count_f = N-count_p-count_n;

%初始化人群的观点程度
xp_in = unifrnd(0.375,0.5,1,count_p_in);
xp_out = unifrnd(0,0.375,1,count_p_out);
xn_in = unifrnd(-0.5,-0.375,1,count_n_in);
xn_out = unifrnd(-0.375,0,1,count_n_out);

xf1 = normrnd(0,0.16,[1,3000]);
xf2 = xf1(xf1>-0.5 & xf1<0.5);
xf = xf2(1:count_f);

%初始化follower的活跃度
G = rand(1,count_f);
G(G>0.5)=1;
G(G<0.5)=0;

%follower的跟随比例
alaph = 0.4;
beta = 0.4;

%不同人群的置信区间
elta_p_in = 0.1;
elta_p_out = 0.25;
elta_n_in = 0.1;
elta_n_out = 0.25;
elta_f = rand(1,count_f)*0.5;

d = 0.5;
g = -0.5;
w_in = 0.5;
w_out = 0.15;
z_in = 0.5;
z_out = 0.15;

matrix_f = [xf];
matrix_p = [xp_in xp_out];
matrix_n = [xn_in xn_out];

for i = 1:time
    
   temp_xf = xf;
   xp = matrix_p(i,:);
   xn = matrix_n(i,:);
   for j = 1:count_f
      temp_f = abs(xf-xf(j))<=elta_f(j).*G;
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
      
      temp_xf(j) = (1-alaph-beta)*result_f + alaph*result_p + beta*result_n;
   end
   
   temp_resp_in = xp_in;
   for m = 1:count_p_in
      temp_xp = abs(xp-xp_in(m))<=elta_p_in;
      if sum(temp_xp)==0
          temp_resp_in(m) = w_in*d;
      else
          temp_resp_in(m) = (1-w_in)*sum(xp.*temp_xp)/sum(temp_xp)+w_in*d;
      end
        
   end
   temp_resp_out = xp_out;
   for m = 1:count_p_out
      temp_xp = abs(xp-xp_out(m))<=elta_p_out;
      if sum(temp_xp)==0
          temp_resp_out(m) = w_in*d;
      else
          temp_resp_out(m) = (1-w_out)*sum(xp.*temp_xp)/sum(temp_xp)+w_out*d;
      end
   end
   
   temp_resn_in = xn_in;
   for m = 1:count_n_in
      temp_xn = abs(xn-xn_in(m))<=elta_n_in;
      if sum(temp_xn)==0
          temp_resn_in(m) = z_in*g;
      else
          temp_resn_in(m) = (1-z_in)*sum(xn.*temp_xn)/sum(temp_xn)+z_in*g;
      end
      
   end
   temp_resn_out = xn_out;
   for m = 1:count_n_out
      temp_xn = abs(xn-xn_out(m))<=elta_n_out;
      if sum(temp_xn)==0
          temp_resn_out(m) = z_out*g;
      else
          temp_resn_out(m) = (1-z_out)*sum(xn.*temp_xn)/sum(temp_xn)+z_out*g;
      end
      
   end
   
   matrix_f = [matrix_f;temp_xf];
   matrix_p = [matrix_p;[temp_resp_in temp_resp_out]];
   matrix_n = [matrix_n;[temp_resn_in temp_resn_out]];
   xf = temp_xf;
   xp_in = temp_resp_in;
   xp_out = temp_resp_out;
   xn_in = temp_resn_in;
   xn_out = temp_resn_out;
    
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

axis([0 20 -0.6 0.6])




