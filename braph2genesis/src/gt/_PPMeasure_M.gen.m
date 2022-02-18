%% ¡header!
PPMeasure_M < PlotProp (pr, plot property M of measure) is a plot of property M of measure.

%%% ¡description!
PPMeasure_M plots a Measure result.

%%% ¡seealso!
GUI, PlotElement, PlotProp, MultigraphBUD, MultigraphBUT.

%% ¡properties!
p
f_br
br_type

%% ¡methods!
function h_panel = draw(pr, varargin)
    %DRAW draws the idict for group ensemble property graphical panel.
    %
    % DRAW(PR) draws the idict property graphical panel.
    %
    % H = DRAW(PR) returns a handle to the idict property graphical panel.
    %
    % DRAW(PR, 'Property', VALUE, ...) sets the properties of the graphical
    %  panel with custom property-value couples.
    %  All standard plot properties of uipanel can be used.
    %
    % It is possible to access the properties of the various graphical
    %  objects from the handle to the brain surface graphical panel H.
    %
    % see also update, redraw, refresh, settings, uipanel, isgraphics.

    % create panel with slider
    el = pr.get('EL');
    prop = pr.get('PROP');
    
    if Measure.is_global(el) && el.get('G').getGraphType()==2
        pr.p = PlotPropMeasureGlobal( ...
            'EL', el, ...
            'PROP', prop, ...
            'ID', 'm', ...
            'TITLE', 'M', ...
            'BKGCOLOR', [0.8 0.5 0.2]).draw(varargin{:});
    elseif Measure.is_nodal(el) && el.get('G').getGraphType()==2
        pr.p = PlotPropMeasureNodal( ...
            'EL', el, ...
            'PROP', prop, ...
            'ID', 'm', ...
            'TITLE', 'M', ...
            'BKGCOLOR', [0.8 0.5 0.2]).draw(varargin{:});
    elseif Measure.is_binodal(el) && el.get('G').getGraphType()==2 % binodal
        pr.p = PlotPropMeasureBinodal( ...
            'EL', el, ...
            'PROP', prop, ...
            'ID', 'm', ...
            'TITLE', 'M', ...
            'BKGCOLOR', [0.8 0.5 0.2]).draw(varargin{:});
    elseif Measure.is_global(el) && el.get('G').getGraphType()==4
        pr.p = PlotPropMeasureGlobalMultilayer( ...
            'EL', el, ...
            'PROP', prop, ...
            'ID', 'm', ...
            'TITLE', 'M', ...
            'BKGCOLOR', [0.8 0.5 0.2]).draw(varargin{:});
    elseif Measure.is_nodal(el) && el.get('G').getGraphType()==4
         pr.p = PlotPropMeasureNodalMultilayer( ...
            'EL', el, ...
            'PROP', prop, ...
            'ID', 'm', ...
            'TITLE', 'M', ...
            'BKGCOLOR', [0.8 0.5 0.2]).draw(varargin{:});
    else % binodal multilayer
         pr.p = PlotPropMeasureBinodalMultilayer( ...
            'EL', el, ...
            'PROP', prop, ...
            'ID', 'm', ...
            'TITLE', 'M', ...
            'BKGCOLOR', [0.8 0.5 0.2]).draw(varargin{:});
    end
    
    ui_brain_view = uicontrol('Parent', pr.p, ...
        'Style', 'pushbutton', ...
        'Units', 'normalized', ...
        'Visible', 'on', ...
        'TooltipString', 'Open the measure in a Brain View plot.', ...
        'String', 'Plot Brain View', ...
        'Position', [.02 .92 .3 .06], ...
        'Callback', {@cb_brainview});
        
    function cb_brainview (~, ~)
        pr.cb_brain_view_fig();
    end

    % output
    if nargout > 0
        h_panel = pr.p;
    end
end
function update(pr)
    %UPDATE updates the content of the property graphical panel.
    %
    % UPDATE(PR) updates the content of the property graphical panel.
    %
    % See also draw, redraw, refresh.
    
    get(pr.p, 'UserData').update()
end
function redraw(pr, varargin)
    %REDRAW redraws the element graphical panel.
    %
    % REDRAW(PR) redraws the plot PR.
    %
    % REDRAW(PR, 'Height', HEIGHT) sets the height of PR (by default HEIGHT=3.3).
    %
    % See also draw, update, refresh.

    get(pr.p, 'UserData').redraw('Height', 6, varargin{:})    
end
function cb_brain_view_fig(pr)
    f_pg = ancestor(pr.p, 'Figure');
    f_ba_x = Plot.x0(f_pg, 'pixels');
    f_ba_y = Plot.y0(f_pg, 'pixels');
    f_ba_w = Plot.w(f_pg, 'pixels');
    f_ba_h = Plot.h(f_pg, 'pixels');

    screen_x = Plot.x0(0, 'pixels');
    screen_y = Plot.y0(0, 'pixels');
    screen_w = Plot.w(0, 'pixels');
    screen_h = Plot.h(0, 'pixels');

    x = f_ba_x + f_ba_w;
    h = f_ba_h / 1.5;
    y = f_ba_y + f_ba_h - h;
    w = screen_w - x;
    
    if isempty(pr.f_br) || ~check_graphics(pr.f_br, 'figure')
        pr.f_br = figure( ...
            'NumberTitle', 'off', ...
            'Units', 'normalized', ...
            'MenuBar', 'none', ...
            'Toolbar', 'figure', ...
            'DockControls', 'off', ...
            'Position', [x/screen_w y/screen_h w/screen_w h/screen_h], ...
            'CloseRequestFcn', {@cb_f_br_close} ...
            );
        set_braph2_icon(pr.f_br)
        menu_about = BRAPH2.add_menu_about(pr.f_br);
        
        ui_toolbar = findall(pr.f_br, 'Tag', 'FigureToolBar');
        delete(findall(ui_toolbar, 'Tag', 'Standard.NewFigure'))
        delete(findall(ui_toolbar, 'Tag', 'Standard.FileOpen'))
        
        el = pr.get('EL');
        prop = pr.get('PROP');
        
        graph = el.get('G');
        
        if isequal(graph.getClass(), 'MultigraphBUD')
            type = 'Densities';
        elseif isequal(graph.getClass(), 'MultigraphBUT')
            type = 'Thresholds';
        else
            type = 'Weighted';
        end
        
        pbv = PlotBrainView('ME', el, ...
            'Atlas', graph.get('BRAINATLAS'), ...
            'Type', type);

        
        pbv.draw('Parent', pr.f_br );
        f_settings = pbv.settings();
        set(f_settings, 'Position', [x/screen_w f_ba_y/screen_h w/screen_w (f_ba_h-h)/screen_h])
        f_settings.OuterPosition(4) = (f_ba_h-h)/screen_h;
        f_settings.OuterPosition(2) = f_ba_y/screen_h;
    else
        gui = get(pr.f_br, 'UserData');
        gui.cb_bring_to_front()
    end
    
    function cb_f_br_close(~, ~)
        delete(pr.f_br);
        pr.update()
    end

    pr.update()
end