%function [tu,metric,red,nir] = plotTuNormRefBW(paired_data)
ind = 1;
n = 0;
total = 0;
load('bwref.mat');
load('paired_data.mat');
bwref = [whiteref,blackref];
figure;
hold on
inbt = 0;

for i = 1:length(paired_data)
    if paired_data(i).panelsel_flag == 1
        rwater = paired_data(i).panel_info(1).meanValueR/0.2126;
        gwater = paired_data(i).panel_info(1).meanValueG/0.7152;
        nwater = paired_data(i).panel_info(1).meanValueN/0.0722;
        
        rdn = extractfield(paired_data(i).panel_info,'meanValueR');
        bwrdn = [rdn(6),rdn(4)]/0.2126;
        gdn = extractfield(paired_data(i).panel_info,'meanValueG');
        bwgdn = [gdn(6),gdn(4)]/0.7152;
        ndn = extractfield(paired_data(i).panel_info,'meanValueN');
        bwndn = [ndn(6),ndn(4)]/0.0722;

        rp = polyfit(bwrdn,bwref,1); % finding line of best fit in each band
        rf = @(x)rp(1).*x+rp(2);
        gp = polyfit(bwgdn,bwref,1);
        gf = @(x)gp(1).*x+gp(2);
        np = polyfit(bwndn,bwref,1);
        nf = @(x)np(1).*x+np(2);
        
        scatter(bwndn,bwref,'m'); % plotting dn vs estimated reflectance
        tt = 0:max(bwndn)+10;
        plot(tt,nf(tt),'m');
        scatter(nwater,nf(nwater),'k*');
        
        if ~(min(bwref) > gf(gwater))
            inbt = inbt + 1;
        end
        
        refwaterR = rf(rwater);
        refwaterG = gf(gwater);
        refwaterN = nf(nwater);
        
        metric(ind,1) = refwaterN/refwaterR;
        red(ind,1) = refwaterR;
        nir(ind,1) = refwaterN;
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
xlabel('DN'); ylabel('Estimated reflectance');

tu = log(tu);
figure;
scatter(tu,metric,[],c,'filled')
colormap jet
xlabel('Turbidity (NTU)'); ylabel('ln(NIR/R)');
hold on
tt = 1:.1:5.5;
b = polyfit(tu,metric,1);
bf = @(x)b(1)*x+b(2);
plot(tt,bf(tt),'g');
est = bf(tu);
Rsq = 1 - sum((metric - est).^2)/sum((metric - mean(metric)).^2);
disp(sprintf('n = %d',n));
disp(sprintf('total photos seen = %d',total));
disp(sprintf('R^2 = %d',Rsq));
inbt