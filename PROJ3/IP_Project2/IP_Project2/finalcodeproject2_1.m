location = input('Enter image dataset location.\n', 's'); %C:\Users\ykocoglu\Desktop\Image Processing\HW2
ds = imageDatastore(location);

while hasdata(ds)
    
input('Enter a keyboard input.\n','s');
Img = read(ds);
figure, imshow(Img),title('Input image');
BIm = im2bw(Img);
FBIm = imfill(BIm,'holes');
[L,n]= bwlabel(BIm);
Crd = regionprops(L,'Area','Orientation');
[Card_Area, idx] = max([Crd.Area]); 
Card_Orientation = Crd(idx).Orientation;
RBIm=imrotate(FBIm,(90-Card_Orientation)); 
RIm=imrotate(Img,(90-Card_Orientation));
[M,n1]= bwlabel(RBIm);
CrdR = regionprops(M,'Area','BoundingBox');
m=1;
maxim=CrdR(1).Area;
for i=1 : length(CrdR)
    if CrdR(i).Area>=maxim
        m=i;
        maxim=CrdR(i).Area;
    end
end

t=CrdR(m,1);
x1=ceil(t.BoundingBox(1));
x2=x1 + t.BoundingBox(3) - 1;
y1=ceil(t.BoundingBox(2));
y2=y1 + t.BoundingBox(4) - 1;
BCrp_Im = RIm(y1:y2,x1:x2);
figure, imshow(BCrp_Im),title('Output Image – aligned and cropped');

end
