function test_m(mat)

% test_m
%==========================================================================
%
% USAGE:
%  test_m(mat)

%
% DESCRIPTION:
%  Give a general look into the structure of matrix
%
% INPUT:
%
%  mat - input 2-D matrix
%  c_sym - variable to specify using symmetric colormap (1) or not (0)
%
% OUTPUT:
%
%  contour figure of the matrix
%
% AUTHOR:
%  September 17 2018. Zhihua Zheng                       [ zhihua@uw.edu ]
%


contourf(mat,'LineStyle','none')

cmocean('balance')
c_max = max(max(abs(mat)));
caxis([-c_max c_max]);

colorbar


end

