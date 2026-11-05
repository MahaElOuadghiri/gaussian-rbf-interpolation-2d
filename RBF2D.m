%% RBF 2D
clear; clc; close all;
% --- Target function ---
f = @(x,y) sin(2*pi*x) .* cos(2*pi*y);
% --- Scattered data points ---
N = 100;
rng(42);
x_data = rand(N,1);
y_data = rand(N,1);
f_data = f(x_data, y_data);
% --- Shape parameter ---
epsilon = 3;
% --- RBF function (Gaussian) ---
phi = @(r) exp(-(epsilon*r).^2);
% --- Building matrix A ---
A = zeros(N, N);
for i = 1:N
for j = 1:N
        r = sqrt((x_data(i)-x_data(j))^2 + (y_data(i)-y_data(j))^2);
        A(i,j) = phi(r);
end
end
% --- Solving ---
w = A \ f_data;
% --- Evaluation grid ---
[Xg, Yg] = meshgrid(linspace(0,1,80), linspace(0,1,80));
x_eval = Xg(:);
y_eval = Yg(:);
f_rbf = zeros(size(x_eval));
for i = 1:N
    r = sqrt((x_eval - x_data(i)).^2 + (y_eval - y_data(i)).^2);
    f_rbf = f_rbf + w(i) * phi(r);
end
F_rbf = reshape(f_rbf, size(Xg));
% --- Display ---
figure;
subplot(1,2,1);
surf(Xg, Yg, f(Xg,Yg)); title('Exact function'); shading interp; colorbar;
xlabel('x'); ylabel('y'); zlabel('f');
subplot(1,2,2);
surf(Xg, Yg, F_rbf); title('2D interpolated RBF'); shading interp; colorbar;
xlabel('x'); ylabel('y'); zlabel('f');
sgtitle('2D RBF - Surface interpolation');
