function varargout = Derivative(varargin)
%Calculates the derivative of y with respect to x and gives an averaged
%vector xx in order to plot dy/dx vs. x. Both dy/dx and the averaged vector
%xx have the same length as x or y minus 1.

if(nargin<2)
    msgbox('Not enough input variables');
elseif(nargin==2)
    x = varargin{1};
    y = varargin{2};
    order = 1;
elseif(nargin==3)
    x = varargin{1};
    y = varargin{2};
    order = varargin{3};
end

for n=1:order
    for i=1:length(y)-1
        der(i) = (y(i)-y(i+1))/(x(i)-x(i+1));
        xx(i) = mean([x(i),x(i+1)]);
    end
    y = der;
    x = xx;
end

varargout = {xx,der};