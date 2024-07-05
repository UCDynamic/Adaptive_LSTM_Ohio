function [S_loop, I_loop, R_loop, L_loop]=solve_loop_opt_LSTM(env, params,iter,ca)  
counter=0
for i=1:50
    for j=1:50
        if env(j,i).boundry==1
           counter=counter+1;
           bound(counter,1)=i;
           bound(counter,2)=j;
            
        end
    end
end

for g=1:length(bound)
  i=bound(g,1);
  j=bound(g,2);
  for x = max(i-2,1):i+2 
    for y = j-2:j+2 
      if(x ~= i || y ~= j)
        if env(y,x).in_map==1 && env(y,x).boundry==0
            cell(g,1)=x;
            cell(g,2)=y;
            
        end
      end
    end
  end
end

    for i= 1:50
           for j=1:50
               for T=1:iter+1
                       S_loop{j,i}(T)=0;
                       I_loop{j,i}(T)=0;
                       R_loop{j,i}(T)=0;
                       L_loop{j,i}(T)=0;
                   if T==1
                       S_loop{j,i}(T)=env(j,i).S;
                       I_loop{j,i}(T)=env(j,i).I;
                       R_loop{j,i}(T)=env(j,i).R;  
                end
               end
           end
    end
u_2=1;
for T=1
%     param= chromosome(params(T,:));
    for i= 2:50-1
       for j=2:50-1
          if (env(j,i).in_map==1)
              if T>15
                   if ca==2
                  u_2=(1/1000);
                   end
                  if ca==3
                      ratio=[I_loop{j,i}(T)/(I_loop{j,i}(T)+ S_loop{j,i}(T)+L_loop{j,i}(T)+R_loop{j,i}(T)), I_loop{j,i}(T-1)/(I_loop{j,i}(T-1)+L_loop{j,i}(T-1)+ S_loop{j,i}(T-1)+R_loop{j,i}(T-1))];
                  if (ratio(1)-ratio(2))/ratio(2)>0.0003
                      u_2=(1/1000);
                  else
                      u_2=1;
                  end
                  end
              end

               %Latency
          latency=0;
          if T<=15
              for k =1:50   
                 for l=1:50
                     if (env(k,l).in_map==1&&env(k,l).boundry==0)
                     fa=(1/(sqrt(4*pi*params(T,10))))*exp(-((i-l)^2+(j-k)^2)/(4*params(T,10)));
                     latency=latency+(env(l,k).I*env(l,k).S*fa*0.63^2);
                     end
                 end
              end 
          else
             for k =1:50   
                 for l=1:50
                     if (env(k,l).in_map==1&&env(k,l).boundry==0)
                      fa=(1/(sqrt(4*pi*params(T,10))))*exp(-((i-l)^2+(j-k)^2)/(4*params(T,10)));
                     latency=latency+(I_loop{l,k}(T-15)*S_loop{l,k}(T-15)*fa*0.63^2)
                     
                     end
                 end
             end
          end
        
                 I_loop{j,i}(T+1) = params(T,5).*(I_loop{j,i-1}(T) + I_loop{j,i+1}(T) + I_loop{j-1,i}(T) + I_loop{j+1,i}(T)) + (1 - 4.*params(T,5) - params(T,6))*I_loop{j,i}(T) +u_2.*params(T,9).*(params(T,4)/1).*latency;
                 S_loop{j,i}(T+1) = 1*params(T,1) + params(T,2).*(S_loop{j,i-1}(T) + S_loop{j,i+1}(T) + S_loop{j-1,i}(T) + S_loop{j+1,i}(T)) + (1 - 4.*params(T,2) - params(T,3) - u_2.*(params(T,4)/1).*I_loop{j,i}(T)).*S_loop{j,i}(T);
                 R_loop{j,i}(T+1) = params(T,7).*(R_loop{j,i-1}(T) + R_loop{j,i+1}(T) + R_loop{j-1,i}(T) + R_loop{j+1,i}(T)) + (1 - 4.*params(T,7) - params(T,3))*R_loop{j,i}(T) + params(T,8).*I_loop{j,i}(T);
                 L_loop{j,i}(T+1) =(u_2.*params(T,4)/1).*(I_loop{j,i}(T).*S_loop{j,i}(T)-params(T,9).*latency)+L_loop{j,i}(T);
          end
        end
    end
    for d =1: length(bound)
        if (cell(d,1)~=0)
        S_loop{cell(d,2),cell(d,1)}(T+1)= S_loop{cell(d,2),cell(d,1)}(T+1)+ S_loop{bound(d,2),bound(d,1)}(T+1)-S_loop{bound(d,2),bound(d,1)}(T);
        S_loop{bound(d,2),bound(d,1)}(T+1)=S_loop{bound(d,2),bound(d,1)}(T);
        
        L_loop{cell(d,2),cell(d,1)}(T+1)= L_loop{cell(d,2),cell(d,1)}(T+1)+ L_loop{bound(d,2),bound(d,1)}(T+1)-L_loop{bound(d,2),bound(d,1)}(T);
        L_loop{bound(d,2),bound(d,1)}(T+1)=L_loop{bound(d,2),bound(d,1)}(T);
        
        I_loop{cell(d,2),cell(d,1)}(T+1)= I_loop{cell(d,2),cell(d,1)}(T+1)+ I_loop{bound(d,2),bound(d,1)}(T+1)-I_loop{bound(d,2),bound(d,1)}(T);
        I_loop{bound(d,2),bound(d,1)}(T+1)=I_loop{bound(d,2),bound(d,1)}(T);

        R_loop{cell(d,2),cell(d,1)}(T+1)= R_loop{cell(d,2),cell(d,1)}(T+1)+ R_loop{bound(d,2),bound(d,1)}(T+1)-R_loop{bound(d,2),bound(d,1)}(T);
        R_loop{bound(d,2),bound(d,1)}(T+1)=R_loop{bound(d,2),bound(d,1)}(T);    
        
        end
    end
end
end