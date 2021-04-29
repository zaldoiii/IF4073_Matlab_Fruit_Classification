%%% Dataset Training
% menetapkan lokasi folder data latih
folder_training_pisang = 'Images\Training\Pisang';
nama_file_training_pisang = dir(fullfile(folder_training_pisang,'*.jpg'));
jumlah_file_training_pisang = numel(nama_file_training_pisang);

folder_training_apel = 'Images\Training\Apel';
nama_file_training_apel = dir(fullfile(folder_training_apel,'*.jpg'));
jumlah_file_training_apel = numel(nama_file_training_apel);

disp("Jumlah data training pisang:")
disp(jumlah_file_training_pisang)
disp("Jumlah data training apel:")
disp(jumlah_file_training_apel)

ciri_h = zeros(jumlah_file_training_pisang+jumlah_file_training_apel,1);
ciri_s = zeros(jumlah_file_training_pisang+jumlah_file_training_apel,1);
kelas_buah = cell(jumlah_file_training_pisang+jumlah_file_training_apel,1);

for n = 1:jumlah_file_training_pisang
    Img = imread(fullfile(folder_training_pisang,nama_file_training_pisang(n).name));
    cform = makecform('srgb2lab');
    lab = applycform(Img,cform);
    b = lab(:,:,2);
    bw = b>140;
    bw = imfill(bw,'holes');
    hsv = rgb2hsv(Img);
    h = hsv(:,:,1);
    s = hsv(:,:,2);
    h(~bw) = 0;
    s(~bw) = 0;
    ciri_h(n) = mean(mean(h));
    ciri_s(n) = mean(mean(s));
end

for n = 1:jumlah_file_training_apel
    Img = imread(fullfile(folder_training_apel,nama_file_training_apel(n).name));
    cform = makecform('srgb2lab');
    lab = applycform(Img,cform);
    b = lab(:,:,2);
    bw = b>140;
    bw = imfill(bw,'holes');
    hsv = rgb2hsv(Img);
    h = hsv(:,:,1);
    s = hsv(:,:,2);
    h(~bw) = 0;
    s(~bw) = 0;
    ciri_h(n+jumlah_file_training_pisang) = mean(mean(h));
    ciri_s(n+jumlah_file_training_pisang) = mean(mean(s));
end
 
% menetapkan kelas target latih
kelas_buah(1:jumlah_file_training_pisang,:) = {'pisang'};
kelas_buah(jumlah_file_training_pisang+1:jumlah_file_training_pisang+jumlah_file_training_apel) = {'apel'};

% -----------------------------------------------------------------------------------------------
%%% Dataset Testing
% menetapkan lokasi folder data latih
folder_testing_pisang = 'I:\KULYAH\SEM7\Citra\IF4073_Matlab_Fruit_Classification\Images\Test\Pisang';
nama_file_testing_pisang = dir(fullfile(folder_testing_pisang,'*.jpg'));
jumlah_file_testing_pisang = numel(nama_file_testing_pisang);

folder_testing_apel = 'I:\KULYAH\SEM7\Citra\IF4073_Matlab_Fruit_Classification\Images\Test\Apel';
nama_file_testing_apel = dir(fullfile(folder_testing_apel,'*.jpg'));
jumlah_file_testing_apel = numel(nama_file_testing_apel);

disp("Jumlah data testing pisang:")
disp(jumlah_file_testing_pisang)
disp("Jumlah data testing apel:")
disp(jumlah_file_testing_apel)

ciri_h_test = zeros(jumlah_file_testing_pisang+jumlah_file_testing_apel,1);
ciri_s_test = zeros(jumlah_file_testing_pisang+jumlah_file_testing_apel,1);
%kelas_buah = cell(jumlah_file_training_pisang+jumlah_testing_apel,1);

for n = 1:jumlah_file_testing_pisang
    Img = imread(fullfile(folder_testing_pisang,nama_file_testing_pisang(n).name));
    cform = makecform('srgb2lab');
    lab = applycform(Img,cform);
    b = lab(:,:,2);
    bw = b>140;
    bw = imfill(bw,'holes');
    hsv = rgb2hsv(Img);
    h = hsv(:,:,1);
    s = hsv(:,:,2);
    h(~bw) = 0;
    s(~bw) = 0;
    ciri_h_test(n) = mean(mean(h));
    ciri_s_test(n) = mean(mean(s));
end

for n = 1:jumlah_file_testing_apel
    Img = imread(fullfile(folder_testing_apel,nama_file_testing_apel(n).name));
    cform = makecform('srgb2lab');
    lab = applycform(Img,cform);
    b = lab(:,:,2);
    bw = b>140;
    bw = imfill(bw,'holes');
    hsv = rgb2hsv(Img);
    h = hsv(:,:,1);
    s = hsv(:,:,2);
    h(~bw) = 0;
    s(~bw) = 0;
    ciri_h_test(n+jumlah_file_testing_pisang) = mean(mean(h));
    ciri_s_test(n+jumlah_file_testing_pisang) = mean(mean(s));
end

% -----------------------------------------------------------------------------------------------

% menampilkan sebaran data latih
%{
figure;
h1 = gscatter(ciri_h,ciri_s,kelas_buah,'rgbk','.',15);
set(h1,'LineWidth',2)
axis([0 0.6 0 0.6])
xlabel('hue')
ylabel('saturation')
legend('pisang (latih)','apel (latih)','Location','SE')
title('{\bf Sebaran data latih}')
%}

training = [ciri_h ciri_s];
sample = [ciri_h_test ciri_s_test];

disp(size(training))
disp(size(sample))
c = fitcknn(training, kelas_buah,'NumNeighbors',1,'Standardize',1);

%%Save model
saveLearnerForCoder(c,'model_1');

%{
Class = predict(c,sample);
figure,
gscatter(ciri_h,ciri_s,kelas_buah,'rgbk','.',15);
set(h1,'LineWidth',2)
axis([0 0.6 0 0.6])
xlabel('hue')
ylabel('saturation')
grid on
hold on
gscatter(ciri_h_test',ciri_s_test',Class,[1 1 0; 1 0 1; 0 1 1; .5 .5 .5],'x',15);
legend('pisang (train)','apel (train)','pisang (test)','apel (test)','Location','SE')
hold off
%}