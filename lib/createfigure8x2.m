function createfigure8x2(X1, Y1, X2, Y2, Y3, Y4, Y5, Y6, Y7, Y8, Y9, Y10, Y11, Y12, Y13, Y14, Y15, Y16, Y17, Y18, Y19, Y20, Y21, Y22, Y23, Y24, Y25, Y26, Y27, Y28, Y29, Y30, Y31, Y32)

%  Auto-generated by MATLAB on 11-Jul-2021 18:10:32

% Create figure
figure1 = figure('Color',[1 1 1]);

% Create axes
axes1 = axes('Parent',figure1,'Position',[0.1 0.895625 0.39 0.089375]);
hold(axes1,'on');
% Create plot
plot(X1,Y1,'Parent',axes1,'LineWidth',1.2,'LineStyle','-.','Color',[0 0 0]);
% Create plot
plot(X2,Y2,'Parent',axes1,'LineWidth',1.2,'Color',[0 0 0]);
% Create text
text('Parent',axes1,'FontSize',12,'String','A',...
    'Position',[0.06 2.10231791135798 0]);
% Create ylabel
ylabel('S(f) (m^2/Hz)','FontName','arial');
% Set the remaining axes properties
set(axes1,'FontName','arial','FontSize',12,'LineWidth',0.9,'TickLength',...
    [0.02 0.02],'XMinorTick','on','XTick',[0.1 0.2 0.3 0.4 0.5],'XTickLabel',{},...
    'YMinorTick','on');
xlim([0.045 0.5]);

% Create axes
axes2 = axes('Parent',figure1,'Position',[0.59 0.895625 0.39 0.089375]);
hold(axes2,'on');
% Create plot
plot(X1,Y3,'Parent',axes2,'LineWidth',1.2,'LineStyle','-.','Color',[0 0 0]);
% Create plot
plot(X2,Y4,'Parent',axes2,'LineWidth',1.2,'Color',[0 0 0]);
% Create text
text('Parent',axes2,'FontSize',12,'String','B',...
    'Position',[0.06 0.923384515349719 0]);
% Set the remaining axes properties
set(axes2,'FontName','arial','FontSize',12,'LineWidth',0.9,'TickLength',...
    [0.02 0.02],'XMinorTick','on','XTick',[0.1 0.2 0.3 0.4 0.5],'XTickLabel',{},...
    'YMinorTick','on');
xlim([0.045 0.5]);

% Create axes
axes3 = axes('Parent',figure1,'Position',[0.1 0.77625 0.39 0.089375]);
hold(axes3,'on');
% Create plot
plot(X1,Y5,'Parent',axes3,'LineWidth',1.2,'LineStyle','-.','Color',[0 0 0]);
% Create plot
plot(X2,Y6,'Parent',axes3,'LineWidth',1.2,'Color',[0 0 0]);
% Create ylabel
ylabel('D(f) (^o)','FontName','arial');
% Set the remaining axes properties
set(axes3,'FontName','arial','FontSize',12,'LineWidth',0.9,'TickLength',...
    [0.02 0.02],'XMinorTick','on','XTick',[0.1 0.2 0.3 0.4 0.5],'XTickLabel',{},...
    'YMinorTick','on');
xlim([0.045 0.5]);

% Create axes
axes4 = axes('Parent',figure1,'Position',[0.59 0.77625 0.39 0.089375]);
hold(axes4,'on');
% Create plot
plot(X1,Y7,'Parent',axes4,'LineWidth',1.2,'LineStyle','-.','Color',[0 0 0]);
% Create plot
plot(X2,Y8,'Parent',axes4,'LineWidth',1.2,'Color',[0 0 0]);
% Set the remaining axes properties
set(axes4,'FontName','arial','FontSize',12,'LineWidth',0.9,'TickLength',...
    [0.02 0.02],'XMinorTick','on','XTick',[0.1 0.2 0.3 0.4 0.5],'XTickLabel',{},...
    'YMinorTick','on');
xlim([0.045 0.5]);

% Create axes
axes5 = axes('Parent',figure1,'Position',[0.1 0.656875 0.39 0.089375]);
hold(axes5,'on');
% Create plot
plot(X1,Y9,'Parent',axes5,'LineWidth',1.2,'LineStyle','-.','Color',[0 0 0]);
% Create plot
plot(X2,Y10,'Parent',axes5,'LineWidth',1.2,'Color',[0 0 0]);
% Create text
text('Parent',axes5,'FontSize',12,'String','C',...
    'Position',[0.06 1.27665627272666 0]);
% Create ylabel
ylabel('S(f) (m^2/Hz)','FontName','arial');
% Set the remaining axes properties
set(axes5,'FontName','arial','FontSize',12,'LineWidth',0.9,'TickLength',...
    [0.02 0.02],'XMinorTick','on','XTick',[0.1 0.2 0.3 0.4 0.5],'XTickLabel',{},...
    'YMinorTick','on');
xlim([0.045 0.5]);

% Create axes
axes6 = axes('Parent',figure1,'Position',[0.59 0.656875 0.39 0.089375]);
hold(axes6,'on');
% Create plot
plot(X1,Y11,'Parent',axes6,'LineWidth',1.2,'LineStyle','-.','Color',[0 0 0]);
% Create plot
plot(X2,Y12,'Parent',axes6,'LineWidth',1.2,'Color',[0 0 0]);
% Create text
text('Parent',axes6,'FontSize',12,'String','D',...
    'Position',[0.06 1.72735474096297 0]);
% Set the remaining axes properties
set(axes6,'FontName','arial','FontSize',12,'LineWidth',0.9,'TickLength',...
    [0.02 0.02],'XMinorTick','on','XTick',[0.1 0.2 0.3 0.4 0.5],'XTickLabel',{},...
    'YMinorTick','on');
xlim([0.045 0.5]);

% Create axes
axes7 = axes('Parent',figure1,'Position',[0.1 0.5375 0.39 0.089375]);
hold(axes7,'on');
% Create plot
plot(X1,Y13,'Parent',axes7,'LineWidth',1.2,'LineStyle','-.','Color',[0 0 0]);
% Create plot
plot(X2,Y14,'Parent',axes7,'LineWidth',1.2,'Color',[0 0 0]);
% Create ylabel
ylabel('D(f) (^o)','FontName','arial');
% Set the remaining axes properties
set(axes7,'FontName','arial','FontSize',12,'LineWidth',0.9,'TickLength',...
    [0.02 0.02],'XMinorTick','on','XTick',[0.1 0.2 0.3 0.4 0.5],'XTickLabel',{},...
    'YMinorTick','on');
xlim([0.045 0.5]);


% Create axes
axes8 = axes('Parent',figure1,'Position',[0.59 0.5375 0.39 0.089375]);
hold(axes8,'on');
% Create plot
plot(X1,Y15,'Parent',axes8,'LineWidth',1.2,'LineStyle','-.','Color',[0 0 0]);
% Create plot
plot(X2,Y16,'Parent',axes8,'LineWidth',1.2,'Color',[0 0 0]);
% ylim(axes8,[0 360]);
% Set the remaining axes properties
set(axes8,'FontName','arial','FontSize',12,'LineWidth',0.9,'TickLength',...
    [0.02 0.02],'XMinorTick','on','XTick',[0.1 0.2 0.3 0.4 0.5],'XTickLabel',{},...
    'YMinorTick','on');
xlim([0.045 0.5]);


% Create axes
axes9 = axes('Parent',figure1,'Position',[0.1 0.418125 0.39 0.089375]);
hold(axes9,'on');
% Create plot
plot(X1,Y17,'Parent',axes9,'LineWidth',1.2,'LineStyle','-.','Color',[0 0 0]);
% Create plot
plot(X2,Y18,'Parent',axes9,'LineWidth',1.2,'Color',[0 0 0]);
% Create text
text('Parent',axes9,'FontSize',12,'String','E',...
    'Position',[0.06 0.88329099424994 0]);
% Create ylabel
ylabel('S(f) (m^2/Hz)','FontName','arial');
% Set the remaining axes properties
set(axes9,'FontName','arial','FontSize',12,'LineWidth',0.9,'TickLength',...
    [0.02 0.02],'XMinorTick','on','XTick',[0.1 0.2 0.3 0.4 0.5],'XTickLabel',{},...
    'YMinorTick','on');
xlim([0.045 0.5]);


% Create axes
axes10 = axes('Parent',figure1,'Position',[0.59 0.418125 0.39 0.089375]);
hold(axes10,'on');

% Create plot
plot(X1,Y19,'Parent',axes10,'LineWidth',1.2,'LineStyle','-.',...
    'Color',[0 0 0]);
% Create plot
plot(X2,Y20,'Parent',axes10,'LineWidth',1.2,'Color',[0 0 0]);
% Create text
text('Parent',axes10,'FontSize',12,'String','F',...
    'Position',[0.06 3.95194557988765 0]);
% Set the remaining axes properties
set(axes10,'FontName','arial','FontSize',12,'LineWidth',0.9,'TickLength',...
    [0.02 0.02],'XMinorTick','on','XTick',[0.1 0.2 0.3 0.4 0.5],'XTickLabel',{},...
    'YMinorTick','on');
xlim([0.045 0.5]);


% Create axes
axes11 = axes('Parent',figure1,...
    'Position',[0.1 0.29875 0.39 0.0893750000000001]);
hold(axes11,'on');
% Create plot
plot(X1,Y21,'Parent',axes11,'LineWidth',1.2,'LineStyle','-.',...
    'Color',[0 0 0]);
% Create plot
plot(X2,Y22,'Parent',axes11,'LineWidth',1.2,'Color',[0 0 0]);
% Create ylabel
ylabel('D(f) (^o)','FontName','arial');
% Set the remaining axes properties
set(axes11,'FontName','arial','FontSize',12,'LineWidth',0.9,'TickLength',...
    [0.02 0.02],'XMinorTick','on','XTick',[0.1 0.2 0.3 0.4 0.5],'XTickLabel',{},...
    'YMinorTick','on');
xlim([0.045 0.5]);


% Create axes
axes12 = axes('Parent',figure1,...
    'Position',[0.59 0.29875 0.39 0.0893750000000001]);
hold(axes12,'on');
% Create plot
plot(X1,Y23,'Parent',axes12,'LineWidth',1.2,'LineStyle','-.',...
    'Color',[0 0 0]);
% Create plot
plot(X2,Y24,'Parent',axes12,'LineWidth',1.2,'Color',[0 0 0]);
% Set the remaining axes properties
set(axes12,'FontName','arial','FontSize',12,'LineWidth',0.9,'TickLength',...
    [0.02 0.02],'XMinorTick','on','XTick',[0.1 0.2 0.3 0.4 0.5],'XTickLabel',{},...
    'YMinorTick','on');
xlim([0.045 0.5]);


% Create axes
axes13 = axes('Parent',figure1,'Position',[0.1 0.179375 0.39 0.089375]);
hold(axes13,'on');
% Create plot
plot(X1,Y25,'Parent',axes13,'LineWidth',1.2,'LineStyle','-.',...
    'Color',[0 0 0]);
% Create plot
plot(X2,Y26,'Parent',axes13,'LineWidth',1.2,'Color',[0 0 0]);
% Create text
text('Parent',axes13,'FontSize',12,'String','G',...
    'Position',[0.06 5.5844051120917 0]);
% Create ylabel
ylabel('S(f) (m^2/Hz)','FontName','arial');
% Set the remaining axes properties
set(axes13,'FontName','arial','FontSize',12,'LineWidth',0.9,'TickLength',...
    [0.02 0.02],'XMinorTick','on','XTick',[0.1 0.2 0.3 0.4 0.5],'XTickLabel',{},...
    'YMinorTick','on');
xlim([0.045 0.5]);


% Create axes
axes14 = axes('Parent',figure1,'Position',[0.59 0.179375 0.39 0.089375]);
hold(axes14,'on');
% Create plot
plot(X1,Y27,'Parent',axes14,'LineWidth',1.2,'LineStyle','-.',...
    'Color',[0 0 0]);
% Create plot
plot(X2,Y28,'Parent',axes14,'LineWidth',1.2,'Color',[0 0 0]);
% Create text
text('Parent',axes14,'FontSize',12,'String','H',...
    'Position',[0.06 5.30818144371057 0]);
% Set the remaining axes properties
set(axes14,'FontName','arial','FontSize',12,'LineWidth',0.9,'TickLength',...
    [0.02 0.02],'XMinorTick','on','XTick',[0.1 0.2 0.3 0.4 0.5],'XTickLabel',{},...
    'YMinorTick','on');
xlim([0.045 0.5]);


% Create axes
axes15 = axes('Parent',figure1,...
    'Position',[0.1 0.0599999999999999 0.39 0.089375]);
hold(axes15,'on');
% Create plot
plot(X1,Y29,'Parent',axes15,'LineWidth',1.2,'LineStyle','-.',...
    'Color',[0 0 0]);
% Create plot
plot(X2,Y30,'Parent',axes15,'LineWidth',1.2,'Color',[0 0 0]);
% Create ylabel
ylabel('D(f) (^o)','FontName','arial');
% Create xlabel
xlabel('f (Hz)','FontName','arial');
% Set the remaining axes properties
set(axes15,'FontName','arial','FontSize',12,'LineWidth',0.9,'TickLength',...
    [0.02 0.02],'XMinorTick','on','XTick',[0.1 0.2 0.3 0.4 0.5],'XTickLabel',...
    {'0.1','0.2','0.3','0.4','0.5'},'YMinorTick','on');
xlim([0.045 0.5]);


% Create axes
axes16 = axes('Parent',figure1,...
    'Position',[0.59 0.0599999999999999 0.39 0.089375]);
hold(axes16,'on');
% Create plot
plot(X1,Y31,'Parent',axes16,'LineWidth',1.2,'LineStyle','-.',...
    'Color',[0 0 0]);
% Create plot
plot(X2,Y32,'Parent',axes16,'LineWidth',1.2,'Color',[0 0 0]);
% Create xlabel
xlabel('f (Hz)','FontName','arial');
set(axes16,'FontName','arial','FontSize',12,'LineWidth',0.9,'TickLength',...
    [0.02 0.02],'XMinorTick','on','XTick',[0.1 0.2 0.3 0.4 0.5],'XTickLabel',...
    {'0.1','0.2','0.3','0.4','0.5'},'YMinorTick','on');
xlim([0.045 0.5]);
