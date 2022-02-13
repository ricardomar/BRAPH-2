%% ¡header!
PlotPropMeasureEnsembleGlobalMultilayer < PlotPropScalar (pr, plot global measure ensemble mp) represents the nodal measure ensemble mp.

%%% ¡description!
PlotPropMeasureEnsembleGlobalMultilayer represents the global measure ensemble mp.

%%% ¡seealso!
GUI, PlotElement, PlotPropString, AnalyzeEnsemble, MeasureEnsemble.

%% ¡properties!
p
edit_value
slider
slider_text
extra_slider
extra_text

%% ¡methods!
function h_panel = draw(pr, varargin)
    %DRAW draws a table with the global measure.
    %
    % DRAW(PR) draws the property panel a table with the structural data of 
    %  a subject.
    %
    % H = DRAW(PR) returns a handle to the property panel.
    %
    % DRAW(PR, 'Property', VALUE, ...) sets the properties of the panel 
    %  with custom Name-Value pairs.
    %  All standard plot properties of uipanel can be used.
    %
    % It is possible to access the properties of the various graphical
    %  objects from the handle H of the panel.
    %
    % See also update, redraw, settings, uipanel.
    
    pr.p = draw@PlotPropScalar(pr, varargin{:});

    % retrieves the handle of the table
    children = get(pr.p, 'Children');
    for i = 1:1:length(children)
        if check_graphics(children(i), 'edit')
            pr.edit_value = children(i);
        end
    end
    
    el = pr.get('EL');
    prop = pr.get('PROP');
    value = el.getr(prop);
    L = size(value, 1);
    label = 'Layer';
    graph = el.get('A').get('G_DICT').getItem(1);
    check = graph.getPropNumber() > 9;
    
    if check
        n = length(el.get('G').get(10)); % 10 is densities or thresholds
        L = size(value, 1) / n;
        label = el.get('G').getPropTag(10);
    end
   
    % set on first layer
    pr.slider = uicontrol( ...
        'Parent', pr.p, ...
        'Style', 'slider', ...
        'Units', 'characters', ...
        'Visible', 'off', ...
        'Value', 1, ...
        'Min', 1, ...
        'Max', L, ...
        'SliderStep', [1 1], ...
        'Callback', {@cb_slider} ...
        );
    pr.slider_text = uicontrol(...
        'Parent', pr.p, ...
        'Style', 'text', ...
        'Units', 'characters', ...
        'HorizontalAlignment', 'center', ...
        'Visible', 'off', ...
        'FontUnits', BRAPH2.FONTUNITS, ...
        'FontSize', BRAPH2.FONTSIZE, ...
        'FontWeight', 'bold', ...
        'String', ['Layer ' num2str(round(get(pr.slider, 'Value')))], ...
        'BackgroundColor', pr.get('BKGCOLOR') ...
        );
    
    function cb_slider(~, ~)
        pr.update()
    end

    if check
        pr.extra_slider = uicontrol( ...
            'Parent', pr.p, ...
            'Style', 'slider', ...
            'Units', 'characters', ...
            'Visible', 'off', ...
            'Value', 1, ...
            'Min', 1, ...
            'Max', n, ...
            'SliderStep', [1 1], ...
            'Callback', {@cb_slider_layer} ...
            );
        pr.extra_text = uicontrol(...
            'Parent', pr.p, ...
            'Style', 'text', ...
            'Units', 'characters', ...
            'HorizontalAlignment', 'center', ...
            'Visible', 'off', ...
            'FontUnits', BRAPH2.FONTUNITS, ...
            'FontSize', BRAPH2.FONTSIZE, ...
            'FontWeight', 'bold', ...
            'String', [label ' ' num2str(round(get(pr.layer_slider, 'Value')))], ...
            'BackgroundColor', pr.get('BKGCOLOR') ...
            );
    end

        function cb_slider_layer(~, ~)
            pr.update()
        end

    % output
    if nargout > 0
        h_panel = pr.p;
    end
end
function update(pr)
    %UPDATE updates the content of the property panel and its graphical objects.
    %
    % UPDATE(PR) updates the content of the property panel and its graphical objects.
    %
    % Important note:
    % 1. UPDATE() is typically called internally by PlotElement and does not need 
    %  to be explicitly called in children of PlotProp.
    %
    % See also draw, redraw, PlotElement.

    update@PlotProp(pr)
    
    el = pr.get('EL');
    prop = pr.get('PROP');
    value = el.getr(prop);
    label = 'Layer';
    graph = el.get('A').get('G_DICT').getItem(1);
    check = graph.getPropNumber() > 9;
    
    if check
        n = length(el.get('G').get(10)); % 10 is densities or thresholds
        L = size(value, 1) / n;
        label = el.get('G').getPropTag(10);
    end
    
    if isa(value, 'NoValue')
        set(pr.slider_text, ...
            'String', [num2str(round(get(pr.slider, 'Value')))]);
        set(pr.edit_value, ...
            'String', 'No Value', ...
            'Enable', pr.get('ENABLE') ...
            )
    else
        set(pr.slider_text, ...
            'String', ['Layer ' num2str(round(get(pr.slider, 'Value')))]);
        
        if check
            
            set(pr.extra_text, ...
                'String', [label ' ' num2str(round(get(pr.extra_slider, 'Value')))]);
            
            % get the correct index
            l = round(get(pr.slider, 'Value')); % layer
            d = round(get(pr.extra_slider, 'Value')); % threshold or ddensity
            
            correct_i =  (d * L)- L + l ;
            
            set(pr.edit_value, ...
                'String', value{correct_i}, ...
                'Enable', pr.get('ENABLE') ...
                )
        else % wu
            set(pr.edit_value, ...
                'String', value{round(get(pr.slider, 'Value'))}, ...
                'Enable', pr.get('ENABLE') ...
                )
        end
    end
end
function redraw(pr, varargin)
    %REDRAW resizes the property panel and repositions its graphical objects.
    %
    % REDRAW(PR) resizes the property panel and repositions its
    %   graphical objects. 
    % 
    % Important notes:
    % 1. REDRAW() sets the units 'characters' for panel and all its graphical objects. 
    % 2. REDRAW() is typically called internally by PlotElement and does not need 
    %  to be explicitly called in children of PlotProp.
    %
    % REDRAW(PR, 'X0', X0, 'Y0', Y0, 'Width', WIDTH, 'Height', HEIGHT)
    %  repositions the property panel. It is possible to use a
    %  subset of the Name-Value pairs.
    %  By default:
    %  - X0 does not change
    %  - Y0 does not change
    %  - WIDTH does not change
    %  - HEIGHT=1.4 characters.
    %
    % See also draw, update, PlotElement.
    
    [h, varargin] = get_and_remove_from_varargin(1.8, 'Height', varargin);
    [Sh, varargin] = get_and_remove_from_varargin(1.8, 'SHeight', varargin);
    [Th, varargin] = get_and_remove_from_varargin(1.8, 'THeight', varargin);
    [Dh, varargin] = get_and_remove_from_varargin(18, 'DHeight', varargin);
    
    el = pr.get('EL');
    prop = pr.get('PROP');
    value = el.get(prop);
    L = size(value, 1);
    n = 0;
    graph = el.get('A').get('G_DICT').getItem(1);
    check = graph.getPropNumber() > 9;
    if check
        n = length(el.get('G').get(10)); % 10 is densities or thresholds
    end
    
    if n > 1
        pr.redraw@PlotPropScalar('Height', h + Sh + Sh + Th + Th + Dh, varargin{:});
        set(pr.slider, ...
            'Units', 'normalized', ...
            'Visible', 'on', ...
            'Position', [.01 (Sh+Th+Dh+h)/(h+Sh+Sh+Th+Th+Dh) .97 (Th/(h+Sh+Sh+Th+Th+Dh)-.02)] ...
            );
        
        set(pr.slider_text, ...
            'Units', 'normalized', ...
            'Visible', 'on', ...
            'Position', [.01 (Sh+Th+Th+Dh+h)/(h+Sh+Sh+Th+Th+Dh) .97 (Th/(h+Sh+Sh+Th+Th+Dh)-.02)] ...
            );
        
        set(pr.extra_slider, ...
            'Units', 'normalized', ...
            'Visible', 'on', ...
            'Position', [.01 (Dh+h)/(h+Sh+Sh+Th+Th+Dh) .97 (Th/(h+Sh+Sh+Th+Th+Dh)-.02)] ...
            );
        
        set(pr.extra_text, ...
            'Units', 'normalized', ...
            'Visible', 'on', ...
            'Position', [.01 (Dh+Th+h)/(h+Sh+Sh+Th+Th+Dh) .97 (Th/(h+Sh+Sh+Th+Th+Dh)-.02)] ...
            );
        
        set(pr.edit_value, ...
            'Visible', 'on', ...
            'Units', 'normalized', ...
            'Position', [.01 .02 .97 ((Dh+h)/(h+Sh+Sh+Th+Th+Dh)-.02)] ...
            )
    else
        pr.redraw@PlotPropScalar('Height', h + Sh + Th + Dh, varargin{:});
        set(pr.slider, ...
            'Units', 'normalized', ...
            'Visible', 'on', ...
            'Position', [.01 (Dh+h)/(h+Sh+Th+Dh) .97 (Th/(h+Sh+Th+Dh)-.02)] ...
            );
        
        set(pr.slider_text, ...
            'Units', 'normalized', ...
            'Visible', 'on', ...
            'Position', [.01 (Th+Dh+h)/(h+Sh+Th+Dh) .97 (Th/(h+Sh+Th+Dh)-.02)] ...
            );
        
        set(pr.edit_value, ...
            'Visible', 'on', ...
            'Units', 'normalized', ...
            'Position', [.01 .02 .97 ((Dh+h)/(h+Sh+Th+Dh)-.02)] ...
            )
    end
end