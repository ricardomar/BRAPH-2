%% ¡header!
PlotPropString < PlotProp (pl, plot property string) is a plot of a property string.

%%% ¡description!
PlotProp plots a property string of an element in a panel.

%%% ¡seealso!
GUI, PlotElement, PlotProp

%% ¡properties!
edit_value

%% ¡methods!
function h_panel = draw(pl, varargin)
    %DRAW draws the string property graphical panel.
    %
    % DRAW(PL) draws the string property graphical panel.
    %
    % H = DRAW(PL) returns a handle to the string property graphical panel.
    %
    % DRAW(PL, 'Property', VALUE, ...) sets the properties of the graphical
    %  panel with custom property-value couples.
    %  All standard plot properties of uipanel can be used.
    %
    % It is possible to access the properties of the various graphical
    %  objects from the handle to the brain surface graphical panel H.
    %
    % see also resize, settings, uipanel, isgraphics.

    el = pl.get('EL');
    prop = pl.get('PROP');
    
    pp = draw@PlotProp(pl, varargin{:});

    % auxiliary functions
    function r = x0(h)
        r = PlotElement.x0(h);
    end
    function r = y0(h)
        r = PlotElement.y0(h);
    end
    function r = w(h)
        r = PlotElement.w(h);
    end
    function r = h(h)
        r = PlotElement.h(h);
    end

    % output
    if nargout > 0
        h_panel = pp;
    end
end