% **********************************************************************
% CS=centersquare(I)
% CS=centersquare(I,OPTSIZE)
%
% Take an image window and place it in a squared window such that it's
% size is maximized without distortion.
%
% I ......... The input image
% OPTSIZE ... If given, than the desired size from parameters.m is
%             overridden
%
% Christian Wolf, christian.wolf@liris.cnrs.fr
% **********************************************************************

% **********************************************************************
% Change log:
% 22.12.2009 cw: -Begin
% **********************************************************************

function CS=centersquare(I,OPTSIZE)
    
    if nargin<2
        OPTSIZE=SQUARE_IMG_SIZE;
    end
    
    osz=size(I);
    ms=max(osz);
    
    % ---- First create a square of size max(width,height)
    % ---- and put the original image into the center
    sqim=zeros(ms);    
    y=floor((ms-osz(1))/2);
    x=floor((ms-osz(2))/2);
    sqim(1+y:y+osz(1),1+x:x+osz(2))=I;    
       
    % ---- Resize the square image to a size smaller then the 
    % ---- desired size in order to take into account the spherical
    % ---- nature (disk!) of the Zernike moments.
    smallersize=floor(OPTSIZE/1.3);
    tmp=imresize(sqim,smallersize*ones(1,2),'nearest');

    % ---- Now create a black square of the desired size and put
    % ---- the created image into its center
    CS=zeros(OPTSIZE,OPTSIZE);
    offset=floor((OPTSIZE-smallersize)/2);
    range=1+offset:offset+smallersize;
    CS(range,range)=tmp;
    
    
    
    
    
        
    
