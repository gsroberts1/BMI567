image = imread('liver.jpeg'); 
theta = pi/6;
dims = size(image);
[X,Y] = meshgrid(1:dims(1),1:dims(2));
old_coords = [X(:), Y(:), ones(length(X(:)),1)]';
S1 = [1 0 -(dims(1)+1)/2; 0 1 -(dims(2)+1)/2; 0 0 1];
R = [cos(theta) sin(theta) 0; -sin(theta) cos(theta) 0; 0 0 1;];
new_coords = R*S1*old_coords;
mins = floor(min(new_coords,[],2));
S2 = [1 0 -mins(1)+1; 0 1 -mins(2)+1; 0 0 1];
new_coords = uint16( S2*new_coords );
for i=1:length(X(:))
    rotated(new_coords(1,i),new_coords(2,i)) = image(old_coords(1,i),old_coords(2,i));
end 
figure; imshow(image,[]); 
figure; imshow(rotated,[]);

