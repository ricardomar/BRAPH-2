classdef DataPanel < handle & matlab.mixin.Copyable
    properties
        h_panel  
        subject
    end
    methods
        function dt_pnl = DataPanel(subject, varargin)         
            dt_pnl.setSubject(subject);
        end
    end
    methods  % basic functions
        function str = tostring(dt_pnl)
            str = [class(dt_pnl) ': ' dt_pnl.subject];
        end
        function disp(dt_pnl)
            disp(['<a href="matlab:help ' class(dt_pnl) '">' class(dt_pnl) '</a>'])
        end
    end
    methods  % set
        function setSubject(dt_pnl, subject)
            dt_pnl.subject = subject; 
        end
    end
    methods
        function h = getDataPanel(dt_pnl, varargin)           
            parent = varargin{1}; 
            data_codes = dt_pnl.subject.getDataCodes();
            data_list = dt_pnl.subject.getDataList();
            
            atlases = dt_pnl.subject.getBrainAtlases();
            atlas = atlases{1};  
            atlas_br = atlas.getBrainRegions();
            
            age_obj = dt_pnl.subject.getData(data_codes{2});
            data_obj = dt_pnl.subject.getData(data_codes{1});
            data = data_obj.getValue();
            
            if isempty(dt_pnl.h_panel) || ~ishandle(dt_pnl.h_panel)
                dt_pnl.h_panel = uitable('Parent', parent);
                set(dt_pnl.h_panel, 'Units', 'normalized')
                set(dt_pnl.h_panel, 'Position', [0 0 1 1])
                set(dt_pnl.h_panel, 'ColumnFormat', {'numeric'})
                set(dt_pnl.h_panel, 'ColumnEditable', true)
                
                % columns and rows names
                ColumnName = cell(1, atlas_br.length());
                for n = 1:1:atlas_br.length()
                    ColumnName{n} = atlas_br.getValue(n).getID();
                end
                set(dt_pnl.h_panel, 'ColumnName', ColumnName)
                
                if isequal(data_list(data_codes{1}), 'DataStructural')
                    RowName = cell(1, size(data, 2));
                    set(dt_pnl.h_panel, 'Data', data')
                else
                    RowName = cell(1, size(data, 1));
                    set(dt_pnl.h_panel, 'Data', data)
                end
                
                for j = 1:1:length(RowName)
                    RowName{j} = j;
                end
                
                set(dt_pnl.h_panel, 'RowName', RowName)               
                
            end
           
             % output if needed
            if nargout > 0
                h = dt_pnl.h_panel;
            end            
        end
        function hold_on(dt_pnl)
            hold(dt_pnl.h_panel, 'on')
        end
        function hold_off(dt_pnl)
            hold(dt_pnl.h_panel, 'off')
        end
        function panel_on(dt_pnl)
            if ~isempty(dt_pnl.h_panel)
                set(dt_pnl.h_panel, 'Visible', 'on')
            end
        end
        function panel_off(dt_pnl)
            if ~isempty(dt_pnl.h_panel)
                set(dt_pnl.h_panel, 'Visible', 'off')
            end
        end
    end
end