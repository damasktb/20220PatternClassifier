% **********************************************************************
% Christian Wolf, http://liris.chrs.fr/christian.wolf
%
% Permission is granted for anyone to copy, use, modify, or distribute this
% program and accompanying programs and documents for any purpose, provided
% this copyright notice is retained and prominently displayed, along with
% a note saying that the original programs are available from my web page.
%
% The programs and documents are distributed without any warranty, express 
% or implied.  As the programs were written for research purposes only, they 
% have not been tested to the degree that would be advisable in any 
% important application.  
% All use of these programs is entirely at the user's own risk.
%
% **********************************************************************

% ---- Test whether there is any difference in reconstructing with 
% ---- a full basis or a non redundant basis
% ---- There shouldn't be one, of course.


imsize=40;

%load runningman.mat
% size(runningman)
% m=runningman(11:11+imsize-1,11:11+imsize-1);
% m=centersquare(m,imsize);
% m=uint8(m);
m = logical(imread(['Star007.gif']));
m=centersquare(m,imsize);
zs1=zernike_bf(imsize,4,1);
zs0=zernike_bf(imsize,4,0);
zs10=zernike_bf(imsize,9);
v01=zernike_mom(m,zs0)
v11=zernike_mom(m,zs1)

v110=zernike_mom(m,zs10)

m = logical(imread(['Star026.gif']));
m=centersquare(m,imsize);
v210=zernike_mom(m,zs10)

m = logical(imread(['elephant05.jpg']));
m=centersquare(m,imsize);
v310=zernike_mom(m,zs10)

m = logical(imread(['elephant06.jpg']));
m=centersquare(m,imsize);
v410=zernike_mom(m,zs10)

size(v410)
length(v410)

hold on;
plot(abs(v110),'r');
plot(abs(v210));
plot(abs(v310),'g');
plot(abs(v410),'k');
hold off;