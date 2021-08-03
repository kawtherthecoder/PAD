%% create struct containing cross normalized reflectances
norm_ref = struct([]);
i = 1;
for c = [10,12,2,7,1,9]
    norm_ref(i).name = lower(labs{c});
    norm_ref(i).valsR = spect(:,c);
    norm_ref(i).valsR = norm_ref(i).valsR(wl >= 661 & wl <= 669);
    norm_ref(i).valsG = spect(:,c);
    norm_ref(i).valsG = norm_ref(i).valsG(wl >= 543 & wl <= 551);
    norm_ref(i).valsN = spect(:,c);
    norm_ref(i).valsN = norm_ref(i).valsN(wl >= 843 & wl <= 853);
    norm_ref(i).meanR = mean(norm_ref(i).valsR);
    norm_ref(i).meanG = mean(norm_ref(i).valsG);
    norm_ref(i).meanN = mean(norm_ref(i).valsN);
    i = i + 1;
end
save('norm_ref.mat','norm_ref');