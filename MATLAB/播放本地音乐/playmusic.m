oldFolder = cd('C:\Users\86138\');

musicList = dir('music/*.mp3');

cd('./music');

for i = 1:length(musicList)
    musicName = musicList(i).name;
    [y, Fs] = audioread(musicName);
    sound(y, Fs);
end
% [y, Fs] = audioread("��ѩ��.mp3");
% 
% sound(y, Fs);