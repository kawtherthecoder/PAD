% plotTuDN.m
% Plots e^(N/R) vs. Turbidity for all processed photos saved in paired_data
function plotTuDN(paired_data)
ind = 1;
n = 0;
total = 0;
for i = 1:length(paired_data)
    if paired_data(i).panelsel_flag == 1
        metric(ind,1) = exp(paired_data(i).panel_info(1).meanValueN / paired_data(i).panel_info(1).meanValueR);
        tu(ind,1) = paired_data(i).tu;
        if day(paired_data(i).photodate) == 13
            c(ind,1) = 1;
        else
            c(ind,1) = 0;
        end
        ind = ind+1;
        n = n+1;
    end
    if paired_data(i).panelsel_flag ~= 0
        total = total+1;
    end
end

figure;
scatter(tu,metric,[],c,'filled')
colormap jet
xlabel('Turbidity (NTU)'); ylabel('exp(NIR/R)');
disp(sprintf('n = %d',n));
disp(sprintf('total photos seen = %d',total));
