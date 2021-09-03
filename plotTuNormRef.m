% plotTuNormRef.m
% Estimating water reflectance using six colored calibration panel known reflectances and their adjusted DN values
% Outputs (automatically saved in .mat file):
% refRGNTu -- structure containing estimated R, G, and N water reflectances of each processed photo, plus the paired turbidity value
function plotTuNormRef()
ind = 1;
n = 0;
total = 0;
load('norm_ref.mat');
load('paired_data.mat');
rref = extractfield(norm_ref,'meanR'); % known panel reflectances (from spectrometer)
gref = extractfield(norm_ref,'meanG');
nref = extractfield(norm_ref,'meanN');

refRGNTu = struct([]);

total = 0;
figure;
hold on

for i = 1:length(paired_data)
    if paired_data(i).panelsel_flag == 1
        rwater = paired_data(i).panel_info(1).meanValueR/0.2126; % adjusting for spectral response of the camera (via MAPIR site: https://drive.google.com/file/d/1mxGQsYdyPKBpMT4hnnt8uT6aGa6LvRLa/view)
        gwater = paired_data(i).panel_info(1).meanValueG/0.7152;
        nwater = paired_data(i).panel_info(1).meanValueN/0.0722;
        
        rdn = extractfield(paired_data(i).panel_info,'meanValueR');
        rdn = rdn(2:7)/0.2126;
        gdn = extractfield(paired_data(i).panel_info,'meanValueG');
        gdn = gdn(2:7)/0.7152;
        ndn = extractfield(paired_data(i).panel_info,'meanValueN');
        ndn = ndn(2:7)/0.0722;
        
%         rp = polyfit(rdn,rref,4); % finding line of best fit in each band
%         rf = @(x)rp(1).*x.^4+rp(2).*x.^3+rp(3).*x.^2+rp(4).*x+rp(5);
%         gp = polyfit(gdn,gref,4);
%         gf = @(x)gp(1).*x.^4+gp(2).*x.^3+gp(3).*x.^2+gp(4).*x+rp(5);
%         np = polyfit(ndn,nref,4);
%         nf = @(x)np(1).*x.^4+np(2).*x.^3+np(3).*x.^2+np(4).*x+np(5);
        
%         rp = polyfit(rdn,rref,3); % finding line of best fit in each band
%         rf = @(x)rp(1).*x.^3+rp(2).*x.^2+rp(3).*x+rp(4);
%         gp = polyfit(gdn,gref,3);
%         gf = @(x)gp(1).*x.^3+gp(2).*x.^2+gp(3).*x+rp(4);
%         np = polyfit(ndn,nref,3);
%         nf = @(x)np(1).*x.^3+np(2).*x.^2+np(3).*x+np(4);

        rp = polyfit(rdn,rref,1); % finding line of best fit in each band
        rf = @(x)rp(1).*x+rp(2);
        gp = polyfit(gdn,gref,1);
        gf = @(x)gp(1).*x+gp(2);
        np = polyfit(ndn,nref,1);
        nf = @(x)np(1).*x+np(2);
        
%         scatter(rdn,rref,'r'); % plotting dn vs estimated reflectance
%         tt = min(rdn)-10:max(rdn)+10;
%         plot(tt,rf(tt),'r');
%         scatter(rwater,rf(rwater),'k*');
        
        if n == 30 % 3 calibration plots for each band
            assignin('base','photoname',paired_data(i).photoname);
            assignin('base','panel_info',paired_data(i).panel_info);
            scatter(rdn,rref,60,'r','filled','MarkerEdgeColor','k'); % plotting dn vs estimated reflectance
            tt = min(rdn)-10:max(rdn)+10;
            plot(tt,rf(tt),'k');
            scatter(rwater,rf(rwater),60,'b*');
            %xlabel('Adjusted DN'); ylabel('Estimated Reflectance');
            figure;
            hold on
            scatter(gdn,gref,60,'g','filled','MarkerEdgeColor','k'); % plotting dn vs estimated reflectance
            tt = min(gdn)-10:max(gdn)+10;
            plot(tt,gf(tt),'k');
            scatter(gwater,gf(gwater),60,'b*');
            %xlabel('Adjusted DN'); ylabel('Estimated Reflectance');
            figure;
            hold on
            scatter(ndn,nref,60,'m','filled','MarkerEdgeColor','k'); % plotting dn vs estimated reflectance
            tt = nwater:max(ndn)+10;
            plot(tt,nf(tt),'k');
            scatter(nwater,nf(nwater),60,'b*');
            axis([0,14000,0,1.02]);
            %xlabel('Adjusted DN'); ylabel('Estimated Reflectance');
        end
        
        refwaterR = rf(rwater); % estimating water ref in each band
        refwaterG = gf(gwater);
        refwaterN = nf(nwater);
        
        refRGNTu(ind).refR = refwaterR; % save info in refRGNTu
        refRGNTu(ind).refG = refwaterG;
        refRGNTu(ind).refN = refwaterN;
        refRGNTu(ind).tu = paired_data(i).tu;
        refRGNTu(ind).photodate = paired_data(i).photodate;
        
        metric(ind,1) = refwaterR;
%         red(ind,1) = refwaterR;
%         nir(ind,1) = refwaterN;
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
%xlabel('DN'); ylabel('Estimated reflectance');
%tu = log(tu); % convert to log

figure;
scatter(tu,metric,[],c,'filled')
colormap jet
xlabel('Turbidity (NTU)'); ylabel('R');
hold on
tt = 1:.1:160;
b = polyfit(tu,metric,1);
bf = @(x)b(1)*x+b(2);
est = bf(tu);
Rsq = 1 - sum((metric - est).^2)/sum((metric - mean(metric)).^2);
hold on
plot(tt,bf(tt),'g');
disp(sprintf('n = %d',n));
disp(sprintf('total photos seen = %d',total));
disp(sprintf('R^2 = %d',Rsq));
corrcoef(tu,metric)
save('refRGNTu.mat','refRGNTu','-v7.3');
