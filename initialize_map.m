%Load the map shapefile
ohio=shaperead('ODOT_County_Boundaries');
tic
%Load the dataset for all the counties for S,I and R values
%Display the map
%figure (1)
%mapshow(S);
%give a unique identifier to each county
for i=1:88
   ohio(i).index=i ; 
end
%define the limits of lat and long that you need
    min_X=-86;
    max_X=-79.5;
    min_Y=38;
    max_Y=43;
    grid_size=50;
    limits=[min_X, max_X, min_Y, max_Y]; 

    %% read cases
    %Load the dataset for all the counties infections and deaths values

    uscounties=readtable('us-counties.csv');  
    test= uscounties;
    count=0;
    counties=unique(uscounties.county(1:8384));
    counties = cellstr(counties); 

    count=1;
    row=0;
    for i=2:height(uscounties)
        
        if strcmp(counties(count),cellstr(uscounties.county(i)))
            row=row+1;
            Table{count}(row,1)=uscounties.casesCumulative(i);
            Table{count}(row,2)=uscounties.deathsCumulative(i);
           
        else
            count=count+1;
            Table{count}(1,1)=uscounties.casesCumulative(i);
            Table{count}(1,2)=uscounties.deathsCumulative(i);
            row=1;
        
        end
    end
%Calculate the recoveries for the dataset
 r=10;
 r_rate=0.75;
    for i=1:89
    Table{i}(:,4)=0;
    for n=r+1:length(Table{i})
        Table{i}(n,3)=r_rate*(Table{i}(n-r,1)-Table{i}(n,2)-Table{i}(n-1,4));
        if Table{i}(n,3)<0
            Table{i}(n,3)=0;
        end
        Table{i}(n,4)=sum(Table{i}(1:n,3));
    
    end 
    end
    
for i=1:89   
Table{i}(1,5)=0;
count3{i}=counties{i}(1:3);
end 
count3=upper(count3);
del=0;
%make new table sorted in the order of S
for i=1:88  
    counter=0;
    for j=1:89
 %Match the dataset with the shapefile which contains the population for each county       
        if strcmp(ohio(i).COUNTY_CD,count3{j})
            Cases_Table{i}=Table{j};
            counter=1;
            count3{j}=[];
        end
    end
    if counter==0
        del=del+1;
        unmatch_S(del)=i;
    end
end
  %Manual Matching since there is some mismatch of the county name in the dataset and the shapefile
           
  %Montgomery
  Cases_Table{15}=Table{57};
  %Ashland
  Cases_Table{24}=Table{3};
  %Jefferson
  Cases_Table{26}=Table{41};
  %Champaign
  Cases_Table{36}=Table{11}; 
  %POMEROY/MEIGS
  Cases_Table{50}=Table{53};        
  %Woodsfield/Monero
  Cases_Table{51}=Table{56};    
  %MOUNT GILEAD/Morgan
  Cases_Table{52}=Table{58};   
  %MOUNT GILEAD/Morrow
  Cases_Table{53}=Table{59};     
  %MOUNT GILEAD/Morrow
  Cases_Table{86}=Table{34};     
 
  %Cumulative suspectible
for i=1:88
     Cases_Table{i}(1,5)=ohio(i).POP_2010;
    if Cases_Table{i}(1,5)~=0
        for j=2:length(Cases_Table{i})
            Cases_Table{i}(j,5)=Cases_Table{i}(1,5)-Cases_Table{i}(j,1)-Cases_Table{i}(j,4);
            
        end
    end
end


%generate the environment mesh 
[env,S_T_loop,I_T_loop]=generate_env(ohio, grid_size,limits,Cases_Table); 

% save('env_1','env','Cases_Table','S_T_loop','I_T_loop');
% 
% for day= 2:60
%     for i= 1:length(Cases_Table)
%         Cases_Table{i} = Cases_Table{i}(2:end, :);
%     end
%     [env,S_T_loop,I_T_loop]=generate_env(ohio, grid_size,limits,Cases_Table);
%     saveFilename = sprintf('env_%d', day);
%     save(saveFilename,'env','Cases_Table','S_T_loop','I_T_loop');
% end
% toc
% beep