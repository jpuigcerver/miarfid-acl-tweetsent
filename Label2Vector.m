function Yo = Label2Vector(Yi)
min_y = min(Yi);
max_y = max(Yi);
Nclasses = max_y - min_y + 1;
Yo = zeros(size(Yi,1), Nclasses);
for i=1:Nclasses
    Yo(:,i) = double(Yi == i);
end
end