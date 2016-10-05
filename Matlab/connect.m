function nedge=connect(nedge,y,x,low)       %connection situation
    neighbour=[-1 -1;-1 0;-1 1;0 -1;0 1;1 -1;1 0;1 1];  %search eight points next to this point
    [m n]=size(nedge);
    for k=1:8
        yy=y+neighbour(k,1);
        xx=x+neighbour(k,2);
        if yy>=1 &&yy<=m &&xx>=1 && xx<=n  
            if nedge(yy,xx)>=low && nedge(yy,xx)~=255  
                nedge(yy,xx)=255;
                nedge=connect(nedge,yy,xx,low);
            end
        end        
    end 

end