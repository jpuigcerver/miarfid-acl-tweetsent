function [T, V] = LoadCrossValidationData()
train=[
    'corpus/train_full.5l.train00';
    'corpus/train_full.5l.train01';
    'corpus/train_full.5l.train02';
    'corpus/train_full.5l.train03';
    'corpus/train_full.5l.train04'
    ];
valid=[
    'corpus/train_full.5l.valid00';
    'corpus/train_full.5l.valid01';
    'corpus/train_full.5l.valid02';
    'corpus/train_full.5l.valid03';
    'corpus/train_full.5l.valid04'
    ];
T=cell(size(train,1),1);
V=cell(size(train,1),1);
for i=1:size(train,1)
    tr_fname=train(i,:);
    va_fname=valid(i,:);
    [tr_x, tr_y] = LoadSVMFile(tr_fname);
    [va_x, va_y] = LoadSVMFile(va_fname);
    tr_y = Label2Vector(tr_y);
    va_y = Label2Vector(va_y);
    tr_x = BinarizeBagOfWords(tr_x);
    va_x = BinarizeBagOfWords(va_x);
    T{i}.x = tr_x;
    T{i}.y = tr_y;
    V{i}.x = va_x;
    V{i}.y = va_y;
end
end