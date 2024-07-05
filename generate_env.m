%Generate grid_size with zipcodes
function [env,S_T_loop,I_T_loop]=generate_env(ohio, grid_size,limits,Cases_Table)
%map the coordinates for each cell in the environment
    min_X=-86
    max_X=-79.5;
    min_Y=38;
    max_Y=43;
    limits=[min_X, max_X, min_Y, max_Y];  
    for i=1:88
    poly(i)=polyshape(ohio(i).X,ohio(i).Y);
    end
    unite=union(poly(:));
    Y_diff=limits(4)-limits(3);
    X_diff=limits(2)-limits(1);
    for i=1:grid_size
        for j=1:grid_size
            env(j,i).X_lim=[limits(1)+(X_diff/grid_size)*(i-1),limits(1)+(X_diff/grid_size)*(i)];
            env(j,i).Y_lim=[limits(4)-(Y_diff/grid_size)*(j-1),limits(4)-(Y_diff/grid_size)*(j)];
        end
    end    
    %Identify for each cell if it is in the map, on boundry or outside the boundary
    for i=1:grid_size
        for j=1:grid_size
            count=0;
            for s=1:88
                xq=[env(j,i).X_lim(1),env(j,i).X_lim(2),env(j,i).X_lim(2),env(j,i).X_lim(1)];
                yq=[env(j,i).Y_lim(2),env(j,i).Y_lim(2),env(j,i).Y_lim(1),env(j,i).Y_lim(1)];
                [in, on]=inpolygon(xq,yq,ohio(s).X,ohio(s).Y);
                if (in(1)||in(2)||in(2)||in(3)==1)
                    count=1;
                    env(j,i).county=ohio(s).COUNTY_SEA;
                    env(j,i).index=ohio(s).index;
                    
                end
            end
            if count==1
                env(j,i).in_map=true;
            else
                env(j,i).in_map=false;
                env(j,i).index=0;
            end
            
            [in]=inpolygon(xq,yq,unite.Vertices(:,1),unite.Vertices(:,2));
            if (in(1)&& in(2)&& in(3)&& in(4))==0 && (in(1)|| in(2)|| in(3)|| in(4))==1
            env(j,i).boundry=true;
            else
            env(j,i).boundry=false;
            end
        end
    end
    for i=1:grid_size
    for j=1:grid_size
        Mat_idx(j,i)=env(j,i).index;
    end
    end    
for i=1:grid_size
        for j=1:grid_size
    env(j,i).S=0;
    env(j,i).I=0;
    env(j,i).R=0;
        end
end
    
for i= 1:grid_size
   for j=1:grid_size
       for T=1:16
           S_T_loop{j,i}(T)=0;
           I_T_loop{j,i}(T)=0;
          
       end
   end
end

%Assign the initial values of S,I and R to each cell using the dataset as the starting point
    for i=1:88
        i;
        row=[];
        col=[];
        IDX=i; %county index of interest
        
         [row, col]=find(Mat_idx==IDX); %find row and column numbers of the environment with that county
         t_cells=length(row); %total number of cells
         
         population=Cases_Table{IDX}(16,5)/t_cells;   %pop per cell in a county
         initial_inf=Cases_Table{IDX}(16,1)/t_cells;
         initial_r=Cases_Table{IDX}(16,4)/t_cells;
         for j=1:t_cells
             env(row(j),col(j)).S=population;
             env(row(j),col(j)).I=initial_inf;
             env(row(j),col(j)).R=initial_r;
               for g=1:16
                   %Assign values for S and I on which latency can be calculated for the initial 15 days of the simulation
                     S_T_loop{row(j),col(j)}(g)=Cases_Table{IDX}(g,5)/t_cells;
                     I_T_loop{row(j),col(j)}(g)=Cases_Table{IDX}(g,1)/t_cells;
               end
         end     
    end
end