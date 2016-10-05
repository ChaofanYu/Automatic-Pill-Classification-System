img=imread('Epzicom_01.jpg');
imshow(img);
[m n]=size(img);
img=double(img);


%%Gaussian Filter
w=fspecial('gaussian',[5 5]); %set filter operator
img=imfilter(img,w,'replicate'); %realize linear filter
figure;
imshow(uint8(img))

%%sobel edge detection
w=fspecial('sobel');
img_w=imfilter(img,w,'replicate');      %horizontal edge
w=w';
img_h=imfilter(img,w,'replicate');      %vertical edge
img=sqrt(img_w.^2+img_h.^2);      
figure;
imshow(uint8(img))

%%non-maximum restraining
new_edge=zeros(m,n);
for i=2:m-1
    for j=2:n-1
        Mx=img_w(i,j);
        My=img_h(i,j);
        
        if My~=0
            o=atan(Mx/My);      %normal radian on the edge
        elseif My==0 && Mx>0
            o=pi/2;
        else
            o=-pi/2;            
        end
        
        %interpolation
        adds=get_coords(o);            
        M1=My*img(i+adds(2),j+adds(1))+(Mx-My)*img(i+adds(4),j+adds(3));  
        adds=get_coords(o+pi); 
        M2=My*img(i+adds(2),j+adds(1))+(Mx-My)*img(i+adds(4),j+adds(3)); 
        
        isbigger=(Mx*img(i,j)>M1)*(Mx*img(i,j)>=M2)+(Mx*img(i,j)<M1)*(Mx*img(i,j)<=M2);
        
        if isbigger
           new_edge(i,j)=img(i,j); 
        end        
    end
end
figure;
imshow(uint8(new_edge))

%%set threshold value
up=120;     %upper threshold value
low=30;    %lower threshold value
set(0,'RecursionLimit',10000);  %set iteration depth
for i=1:m
    for j=1:n
      if new_edge(i,j)>up && new_edge(i,j)~=255  %upper threshold value
            new_edge(i,j)=255;
            new_edge=connect(new_edge,i,j,low);
      end
    end
end
figure;
imshow(new_edge==255)