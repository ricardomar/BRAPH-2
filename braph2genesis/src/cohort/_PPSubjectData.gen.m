%% ¡header!
PPSubjectData < PlotProp (pl, plot property of subject data) is a plot of a subject data.

%%% ¡description!
PPSubjectData plots an adequate representation of the Subject data.

%%% ¡seealso!
GUI, PlotElement, PlotProp, Subejct, SubjectST, SubjectFUN, SubjectCON.

%% ¡properties!
pp
table_values

%% ¡methods!
function h_panel = draw(pl, varargin)
    %DRAW draws the idict for brain atlas property graphical panel.
    %
    % DRAW(PL) draws the idict property graphical panel.
    %
    % H = DRAW(PL) returns a handle to the idict property graphical panel.
    %
    % DRAW(PL, 'Property', VALUE, ...) sets the properties of the graphical
    %  panel with custom property-value couples.
    %  All standard plot properties of uipanel can be used.
    %
    % It is possible to access the properties of the various graphical
    %  objects from the handle to the brain surface graphical panel H.
    %
    % see also update, redraw, refresh, settings, uipanel, isgraphics.

    el = pl.get('EL');
    prop = pl.get('PROP');
    sub_data = el.get(prop);
    sub_br_dict = el.get('BA').get('BR_DICT');

    pl.pp = draw@PlotProp(pl, varargin{:});
    
    if isequal(upper(el.getPropTag(prop)), 'ST')
        sub_data = sub_data';
    end

    if isempty(pl.table_values) || ~isgraphics(pl.table_values, 'uitable')
        % construct a data holder
        
        pl.table_values = uitable();
        set( pl.table_values, ...
            'Parent', pl.pp, ...
            'Units', 'normalized', ...
            'Position', [.02 .1 .96 .8], ...
            'ColumnFormat', {'numeric'}, ...
            'Tooltip', [num2str(el.getPropProp(prop)) ' ' el.getPropDescription(prop)], ...
            'ColumnEditable', true, ...
            'CellEditCallback', {@cb_table_values} ...
            );
        
        if ~isempty(sub_data) && ~isa(sub_data, 'NoValue')
            brs_labels = cellfun(@(x) x.get('ID'), sub_br_dict.getItems(), 'UniformOutput', false);
            set(pl.table_values, 'ColumnName', brs_labels)
            set(pl.table_values, 'Data', sub_data);
            set(pl.table_values, 'ColumnWidth', 'auto')
        end
    end

    % callbacks
        function cb_table_values(~, event)
            el = pl.get('EL');
            m = event.Indices(1);
            col = event.Indices(2);
            sub_data(m, col) = event.NewData;
            if isequal(el.getPropFormat(prop), 'nc')
                el.set(prop, sub_data');
            else
                el.set(prop, sub_data);
            end
            pl.update()
        end        

    % output
    if nargout > 0
        h_panel = pl.pp;
    end
end
function update(pl)
    %UPDATE updates the content of the property graphical panel.
    %
    % UPDATE(PL) updates the content of the property graphical panel.
    %
    % See also draw, redraw, refresh.

    update@PlotProp(pl)

    el = pl.get('EL');
    prop = pl.get('PROP');

    value = el.getr(prop);
    
    if isequal(upper(el.getPropTag(prop)), 'ST')
        value = value';
    end

    if el.getPropCategory(prop) == Category.RESULT && isa(value, 'NoValue')
        %
    else
        if isempty(pl.table_values)
            pl.table_values = cell(size(value, 1), size(value, 2));
        end
        
        if ~isempty(value) && ~isa(value, 'NoValue')
            set(pl.table_values, ...
                'Data', value, ...
                'Tooltip', [num2str(el.getPropProp(prop)) ' ' el.getPropDescription(prop)] ...
                )
        end
    end
end
function redraw(pl, varargin)
    %REDRAW redraws the element graphical panel.
    %
    % REDRAW(PL) redraws the plot PL.
    %
    % REDRAW(PL, 'Height', HEIGHT) sets the height of PL (by default HEIGHT=3.3).
    %
    % See also draw, update, refresh.
    
    el = pl.get('EL');
    prop = pl.get('PROP');    
    value = el.getr(prop);
    if el.getPropCategory(prop) == Category.RESULT && isa(value, 'NoValue')
        pl.redraw@PlotProp('Height', 1.8, varargin{:})
    else
        base = 5;
        if isempty(pl.table_values)
            pl.redraw@PlotProp('Height', base, varargin{:})
        elseif ~isempty(value) && ~isa(value, 'NoValue')
            tmp_data = get(pl.table_values, 'Data');
            tmp_h = size(tmp_data, 1); % 1.1 per row
            f_h = (tmp_h * 1.1) + base + 2;
            if f_h < 25
                pl.redraw@PlotProp('Height', f_h, varargin{:})
            else
                pl.redraw@PlotProp('Height', 25, varargin{:})
            end
        end
    end
end
function selected = getSelected(pl)
    selected = pl.selected;
end