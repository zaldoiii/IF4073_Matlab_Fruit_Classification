%%% Dataset Training
% menetapkan lokasi folder data latih
folder_training_jeruk = 'Images\Training\Jeruk';
nama_file_training_jeruk = dir(fullfile(folder_training_jeruk,'*.jpg'));
jumlah_file_training_jeruk = numel(nama_file_training_jeruk);

folder_training_apel = 'Images\Training\Apel';
nama_file_training_apel = dir(fullfile(folder_training_apel,'*.jpg'));
jumlah_file_training_apel = numel(nama_file_training_apel);

disp("Jumlah data training Jeruk:")
disp(jumlah_file_training_jeruk)
disp("Jumlah data training apel:")
disp(jumlah_file_training_apel)

ciri_h = zeros(jumlah_file_training_jeruk+jumlah_file_training_apel,1);
ciri_s = zeros(jumlah_file_training_jeruk+jumlah_file_training_apel,1);
kelas_buah = cell(jumlah_file_training_jeruk+jumlah_file_training_apel,1);

for n = 1:jumlah_file_training_jeruk
    Img = imread(fullfile(folder_training_jeruk,nama_file_training_jeruk(n).name));
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
    ciri_h(n+jumlah_file_training_jeruk) = mean(mean(h));
    ciri_s(n+jumlah_file_training_jeruk) = mean(mean(s));
end
 
% menetapkan kelas target latih
kelas_buah(1:jumlah_file_training_jeruk,:) = {'jeruk'};
kelas_buah(jumlah_file_training_jeruk+1:jumlah_file_training_jeruk+jumlah_file_training_apel) = {'apel'};

% -----------------------------------------------------------------------------------------------
%%% Dataset Testing
% menetapkan lokasi folder data latih
folder_testing_jeruk = 'I:\KULYAH\SEM7\Citra\IF4073_Matlab_Fruit_Classification\Images\Test\Jeruk';
nama_file_testing_jeruk = dir(fullfile(folder_testing_jeruk,'*.jpg'));
jumlah_file_testing_jeruk = numel(nama_file_testing_jeruk);

folder_testing_apel = 'I:\KULYAH\SEM7\Citra\IF4073_Matlab_Fruit_Classification\Images\Test\Apel';
nama_file_testing_apel = dir(fullfile(folder_testing_apel,'*.jpg'));
jumlah_file_testing_apel = numel(nama_file_testing_apel);

disp("Jumlah data testing jeruk:")
disp(jumlah_file_testing_jeruk)
disp("Jumlah data testing apel:")
disp(jumlah_file_testing_apel)

ciri_h_test = zeros(jumlah_file_testing_jeruk+jumlah_file_testing_apel,1);
ciri_s_test = zeros(jumlah_file_testing_jeruk+jumlah_file_testing_apel,1);
%kelas_buah = cell(jumlah_file_training_jeruk+jumlah_testing_apel,1);

for n = 1:jumlah_file_testing_jeruk
    Img = imread(fullfile(folder_testing_jeruk,nama_file_testing_jeruk(n).name));
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
    ciri_h_test(n+jumlah_file_testing_jeruk) = mean(mean(h));
    ciri_s_test(n+jumlah_file_testing_jeruk) = mean(mean(s));
end

% -----------------------------------------------------------------------------------------------

% menampilkan sebaran data latih
figure;
h1 = gscatter(ciri_h,ciri_s,kelas_buah,'rgbk','.',15);
set(h1,'LineWidth',2)
axis([0 0.6 0 0.6])
xlabel('hue')
ylabel('saturation')
legend('jeruk (latih)','apel (latih)','Location','SE')
title('{\bf Sebaran data latih}')

training = [ciri_h ciri_s];
sample = [ciri_h_test ciri_s_test];

disp(size(training))
disp(size(sample))
c = fitcknn(training, kelas_buah,'NumNeighbors',1,'Standardize',1);

%%Save model
saveLearnerForCoder(c,'model_classification');