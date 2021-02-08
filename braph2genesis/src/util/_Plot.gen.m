%% ¡header!
Plot < Element (pl, plot) is a plot.

%%% ¡description!
Plot is the basic element to manage graphical representations of elements.
It is an empty graphical panel, which should be filled by derived element.
To generate the plot, call pl.draw() and to open the setting GUI call pl.settings().

%%% ¡seealso!
uipanel, ishandle, isgraphics

%% ¡properties!
h_panel % panel graphical handle
f_settings % setting figure handle 

%% ¡props!

%%% ¡prop!
BKGCOLOR (metadata, rvector) is background color of the setting interface.
%%%% ¡check_prop!
check = (length(value) == 3) && all(value >= 0 & value <= 1);
%%%% ¡default!
[.95 .95 .95]

%%% ¡prop!
SETPOS (metadata, rvector) is the normalized position of the setting interface on the screen.
%%%% ¡check_prop!
check = (length(value) == 4) && all(value >= 0 & value <= 1);
%%%% ¡default!
[.70 .50 .40 .20]

%%% ¡prop!
SETNAME (metadata, string) is the name of the setting interface.
%%%% ¡default!
'Plot Settings'

%% ¡methods!
function h_panel = draw(pl, varargin)
    %DRAW draws the graphical panel.
    %
    % DRAW(PL) draws the graphical panel.
    %
    % H = DRAW(PL) returns a handle to the graphical panel.
    %
    % DRAW(PL, 'Property', VALUE, ...) sets the properties of the graphical
    %  panel with custom property-value couples.
    %  All standard plot properties of uipanel can be used.
    %
    % see also settings, uipanel, isgraphics.

    if isempty(pl.h_panel) || ~isgraphics(pl.h_panel, 'uipanel')
        pl.h_panel = uipanel();
    end
    h = pl.h_panel;
    set(h, 'DeleteFcn', {@close_f_settings}, ...
        varargin{:})

    function close_f_settings(~, ~) % (src, event)
        if ~isempty(pl.f_settings) && isgraphics(pl.f_settings, 'figure')
            close(pl.f_settings)
        end
    end
    
    if nargout > 0
        h_panel = h;
    end
end
function f_settings = settings(pl, varargin)
    %SETTINGS opens the property editor GUI.
    %
    % SETTINGS(PL) allows the user to specify the properties of the plot
    %  by opening a GUI property editor.
    %
    % F = SETTINGS(PL) returns a handle to the property editor GUI.
    %
    % SETTINGS(PL, 'Property', VALUE, ...) sets the properties of the
    %  property editor GUI with custom property-value couples. 
    %  All standard plot properties of figure can be used.
    %
    % See also draw, figure, isgraphics.

    % create a figure
    if isempty(pl.f_settings) || ~isgraphics(pl.f_settings, 'figure')
        pl.f_settings = figure();
    end
    f = pl.f_settings;
    set(f, 'units', 'normalized', ...
        'Position', pl.get('SETPOS'), ... 
        'Color', pl.get('BKGCOLOR'), ...
        'Name', pl.get('SETNAME'), ...
        'MenuBar', 'none', ...
        'Toolbar', 'none', ...
        'NumberTitle', 'off', ...
        'DockControls', 'off', ...
        varargin{:})
    
    if nargout > 0
        f_settings = pl.f_settings;
    end
end

%% ¡tests!

%%% ¡test!
%%%% ¡name!
Basics
%%%% ¡code!
fig = figure();

pl1 = Plot();
pl1.draw()
pl1.settings()

pl2 = Plot();
h2 = pl2.draw('Units', 'normalized', 'Position', [.25 .25 .50 .50]);
f2 = pl2.settings();

close(fig)