function [ c, cont ] = contourf( self, vectorA, vectorB, data, varargin )
% CONTOURF, used with a carpet plot object, will transform the contour
% to the a/b coordinate system.
%
% CONTOURF(obj,a,b,z,v) draws a filled contour using a and b to
% determine the a and b limits. All further variables will be
% handed to the contourf function.
%
% Example:
%
%   a =[1;2;3;1;2;3];
%   b =[10;10;10;30;30;30];
%   x = b-a.^3;
%   y = a.*b;
%
%   plotObject = CarpetPlot(a,b,x,y);
%
%   contourf(plotObject,1:0.1:3,10:1:30,peaks(21));
%
% See also: CarpetPlot.plot, CarpetPlot.hatchedline

% Keep hold functionality
if ishold == 0
    self.holding = 0;
    hold on
else
    self.holding = 1;
end

% Check input
if ~isvector(vectorA) || ~isvector(vectorB)
    error('Input must be vectors')
else
    vectorA = vectorA(:)';
    vectorB = vectorB(:)';
end

% Get the mask to cut the edges of the contour
[~,maskPlot] = getConstrMask(self,[]);
maskPlot(maskPlot==0) = NaN;

%Extend matrix to contour resolution
[inputDataX,inputDataY] = meshgrid(vectorA,vectorB);
vectorA = interp1( ...
    1:size(self.axis{1}.interval(:),1), ...
    self.axis{1}.interval, ...
    1:(size(self.axis{1}.interval(:),1)-1) ...
    /self.CONTOUR_RESOLUTION:size(self.axis{1}.interval(:),1));
vectorB = interp1( ...
    1:size(self.axis{2}.interval(:),1), ...
    self.axis{2}.interval, ...
    1:(size(self.axis{2}.interval(:),1)-1) ...
    /self.CONTOUR_RESOLUTION:size(self.axis{2}.interval(:),1));
[aaa,bbb] = meshgrid(vectorA,vectorB);

%Interpolate the data points to the contour resolution
[dataX,dataY] = meshgrid(vectorA,vectorB);
data = interp2(inputDataX,inputDataY,data,dataX,dataY,self.dataFitting);
xxx = interp2( ...
    self.inputMatrixA, ...
    self.inputMatrixB, ...
    self.inputMatrixX, ...
    aaa, bbb, self.dataFitting);
yyy = interp2( ...
    self.inputMatrixA, ...
    self.inputMatrixB, ...
    self.inputMatrixY, ...
    aaa, bbb, self.dataFitting);

nxqq = min(xxx(:)):(max(xxx(:))-min(xxx(:))) ...
    /self.CONTOUR_RESOLUTION:(max(xxx(:)));
nyqq = min(yyy(:)):(max(yyy(:))-min(yyy(:))) ...
    /self.CONTOUR_RESOLUTION:(max(yyy(:)));
[xqq,yqq] = meshgrid(nxqq,nyqq);

a1 = griddata(xxx,yyy,data,xqq,yqq);

% Multiply the matrix with the contour mask
a1 = a1.*maskPlot;
%Plot Contourf
if ~isempty(varargin)
    [c,cont] = contourf(nxqq,nyqq,a1,varargin);
else
    [c,cont] = contourf(nxqq,nyqq,a1);
end

set(cont,'edgecolor','none');

% Restore Hold Functionality
if self.holding == 0
    hold off
end
end
