clc;
clear all;
close all;
%a1=0:1:63;
%b=dec2bin(a1);
%COL=[];
%for i=1:1:64
%COL=[COL ; (str2num(b(i,1))2-1)-j(str2num(b(i,2))*2-1) ...
    %(str2num(b(i,3))2-1)-j(str2num(b(i,4))*2-1)...
    %(str2num(b(i,5))2-1)-j(str2num(b(i,6))*2-1) ];
%end
%COL=COL/sqrt(2);

load DIS00;
A=reshape(DIS00(:,1),64,100);

%INPUTMAT=[COL ones(size(COL,1),1)];

P=A(:,1:1:50); Q=A(:,51:1:100);
hiddensize=50;


%%%%AUTOENCODER 1
%%%model training
autoenc_real = trainAutoencoder(real(P), hiddensize ,...
     'MaxEpochs', 10000, ...
     'DecoderTransferFunction', 'purelin');
%%%encoding
AE_real=encode(autoenc_real, real(Q));
%%decoding
decomp_real= decode(autoenc_real,AE_real);


%%%%AUTOENCODER 2
%%%model training
autoenc_imag = trainAutoencoder(imag(P), hiddensize, ...
     'MaxEpochs', 10000, ...
     'DecoderTransferFunction', 'purelin');
%%%encoding
AE_imag = encode(autoenc_imag, imag(Q));
%%decoding
decomp_imag=decode(autoenc_imag,AE_imag);

%%%combining
P_predict=complex(decomp_real,decomp_imag);

%%%plot 
figure(1)
%subplot(2,1,1)
stem(real(Q(:,1))); hold on;
%subplot(2,1,2)
stem(decomp_real(:,1),'r');
legend('ACTUAL', 'RECONSTRUCTED');

figure(2)
%subplot(2,1,1)
stem(imag(Q(:,1))); hold on;
%subplot(2,1,2)
stem(decomp_imag(:,1),'r');
legend('ACTUAL', 'RECONSTRUCTED');