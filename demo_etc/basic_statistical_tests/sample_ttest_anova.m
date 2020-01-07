close all;

%% (1) T-TEST (nGroup == 2)

% Prepare sample dataset
dat_x = [ 1 3 2 1 3 5 ];      % Condition 1
dat_y = [ 4 8 9 15 2 3 2 10 10 ]; % Condition 2

% Visualization
figure(1);
errorbar([1, 2], [mean(dat_x), mean(dat_y)], [std(dat_x), std(dat_y)], 'ko-');
set(gca, 'XTick', [1, 2], 'XTickLabel', {'Cond 1', 'Cond 2' });
xlim([0 3]);

% TTEST-2 (parametric)
[h,p,ci,stats] = ttest2( dat_x, dat_y );
disp(['Stat for ttest.. t(' num2str(stats.df) ') = ' num2str(stats.tstat) ', p = ' num2str(p) ])

% Ranksum test (non-parametric)
[p, h, stats] = ranksum( dat_x, dat_y );
disp(['Stat for ttest.. Ranksum = ' num2str(stats.ranksum) ', p = ' num2str(p) ])

title(['T-TEST DEMO']);

%% (2) ANOVA (nGroup > 2)

% Prepare sample dataset: 
dat_x = [ 1 3 2 1 3 5 ];      % Condition 1
dat_y = [ 4 8 9 15 2 3 2 10 10]; % Condition 2
dat_z = [ 5 4 8 1 9 1 5 1 1 1 2 1 ]; % Condition 3

dat_cat = [ dat_x'; dat_y'; dat_z' ];
cond_cat = [...
    ones([1,length(dat_x)])'*1; ...
    ones([1,length(dat_y)])'*2; ...
    ones([1,length(dat_z)])'*3; ...
    ];

% Visualization
figure(2);
errorbar([1, 2, 3], [mean(dat_x), mean(dat_y), mean(dat_z)], ...
    [std(dat_x), std(dat_y), std(dat_z)], 'ko-');
set(gca, 'XTick', [1, 2, 3], 'XTickLabel', {'Cond 1', 'Cond 2', 'Cond 3'});
xlim([0 4]);


% ANOVA, MUTCOMPARE (parametric)
[p,anovatab,stats]= anova1( dat_cat, cond_cat,'off' );
% clc; 
disp(['P value for anova = ' num2str(p) ])
[comparison,means,h,gnames] = multcompare( stats, 'ctype', 'bonferroni', 'Display','off');

% Kruskal-Wallis (non-parametric)
[p,krutab,stats]= kruskalwallis( dat_cat, cond_cat,'off' );
% clc; 
disp(['P value for Kruskal wallis ANOVA = ' num2str(p) ])
[comparison,means,h,gnames] = multcompare( stats, 'ctype', 'bonferroni', 'Display','off');


title(['ANOVA DEMO']);

