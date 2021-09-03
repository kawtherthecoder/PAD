% photoAnalysis.m
% Panel selection and analysis for paired photos-turbidity (stored in paired_data.mat). paired_data is updated every time this script is run
% more photos are analyzed. For detailed running instructions, see main README file.

% load paired data
load('paired_data.mat');
panel_colors={'pink', 'grey', 'black', 'yellow', 'white', 'red'};

%% iterate through and checking whether photo has been checked via
% panelsel_flag
% = 1 when checked and panels/water successfully selected
% = -1 when checked and not selected (photo not usable)
% = 0 when not yet checked
ind = 1:length(paired_data);
ind = ind(randperm(length(ind))); % to shuffle photos
for i = ind
    if paired_data(i).panelsel_flag == 0 && ~isnan(paired_data(i).tu)
        % display photo
        RGN=imread(paired_data(i).photoname);
        if day(paired_data(i).photodate) == 12 % adjusting exposure of the image as it's displayed -- depending on the day due to varying cloud coverage
            bright = 0.015;
        else
            bright = 0.04;
        end
        for x = 1:3
            RGN_stretch(:,:,x)=imadjust(RGN(:,:,x),[0,bright]); % displaying the stretched image for easy viewing
        end
        h=imshow(RGN_stretch);
        zoom on
        
        % is photo ready to be checked? or throw out?
        disp(datestr(paired_data(i).photodate))
        disp('Continue to panel selection?')
        disp('PRESS 1 TO CONTINUE');
        disp('PRESS 2 TO SKIP THIS PHOTO')
        disp('PRESS 0 TO EXIT PHOTO ANALYSIS')
        in = input('>');
        zoom off
        close
        
        if in == 2 % skip photo
            paired_data(i).panelsel_flag = -1;
            disp(strcat('Panel selection skipped for: ',paired_data(i).photoname,'.'));
            continue
        elseif in == 1
            paired_data(i).panelsel_flag = 1;
        else
            break;
        end
        
        if paired_data(i).panelsel_flag == 1 % continue to panel/water selection...     
            % save corners of panels/water and their average DN values in
            % struct
            paired_data(i).panel_info = select_panels(RGN, panel_colors, bright);
            if isempty(paired_data(i).panel_info)
                paired_data(i).panelsel_flag = -1;
                disp('PHOTO INFO NOT SAVED AND PHOTO WAS SKIPPED');
            end
        end
        
%         disp('Continue to next photo?');
%         disp('PRESS 1 TO CONTINUE');
%         disp('PRESS 2 TO EXIT PHOTO ANALYSIS AND SAVE PROGESS');
%         in = input('>');
%         if in == 2
%             break % exit photo analysis
%         end
    end
end

%% update for newly analyzed data
save('paired_data.mat','paired_data','-v7.3');
disp('PROGRESS SAVED. THANK YOU.');
