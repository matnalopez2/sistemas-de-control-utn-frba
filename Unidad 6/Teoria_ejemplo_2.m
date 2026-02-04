clc; clear; close all;

K=40;
G=tf(1, poly([0 -2]));
G1 = K*G;

margin(G1)