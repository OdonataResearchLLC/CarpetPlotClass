function legend( varargin )
% LEGEND plots legends for one or multiple carpet plots.
%
% Legend([obj1 obj2 ...],'Name1','Name2',...) The syntax is similar to
% matlab's legend() function. Altough it is not possibly to make a
% legend of carpet plots and other graphic objects so far.
%

%hb = [obj.alinehandles(:) ; obj.blinehandles(:)];

if nargin > 1
    labels = cell(1,size(varargin{1}(:),1));
    for n=1:size(varargin{1}(:),1)
        labels{n} = 'CarpetPlot';
    end
    for n=2:nargin
        labels{n-1} = varargin{n};
    end
end

handles = zeros(1,size(varargin{1}(:),1));
for n=1:size(varargin{1}(:),1)
    if ishandle(varargin{n})
        handles(n) = varargin{n};
        set(handles(n),'Displayname',labels{n});
    else
        hg = hggroup;
        hb = [varargin{1}(n).lines(:); varargin{1}(n).lines(:)];
        set(hb,'Parent',hg);
        set(hg,'Displayname',labels{n})
        handles(n) = hg;
    end
end

legend(handles);

end
