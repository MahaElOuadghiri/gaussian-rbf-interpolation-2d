%% RBF 2D
clear; clc; close all;

% --- Fonction cible ---
f = @(x,y) sin(2*pi*x) .* cos(2*pi*y);

% --- Points de données dispersés ---
N = 100;
rng(42);
x_data = rand(N,1);
y_data = rand(N,1);
f_data = f(x_data, y_data);

% --- Paramètre de forme ---
epsilon = 3;

% --- Fonction RBF (Gaussienne) ---
phi = @(r) exp(-(epsilon*r).^2);

% --- Construction de la matrice A ---
A = zeros(N, N);
for i = 1:N
    for j = 1:N
        r = sqrt((x_data(i)-x_data(j))^2 + (y_data(i)-y_data(j))^2);
        A(i,j) = phi(r);
    end
end

% --- Résolution ---
w = A \ f_data;

% --- Grille d'évaluation ---
[Xg, Yg] = meshgrid(linspace(0,1,80), linspace(0,1,80));
x_eval = Xg(:);
y_eval = Yg(:);

f_rbf = zeros(size(x_eval));
for i = 1:N
    r = sqrt((x_eval - x_data(i)).^2 + (y_eval - y_data(i)).^2);
    f_rbf = f_rbf + w(i) * phi(r);
end
F_rbf = reshape(f_rbf, size(Xg));

% --- Affichage ---
figure;
subplot(1,2,1);
surf(Xg, Yg, f(Xg,Yg)); title('Fonction exacte'); shading interp; colorbar;
xlabel('x'); ylabel('y'); zlabel('f');

subplot(1,2,2);
surf(Xg, Yg, F_rbf); title('RBF 2D interpolée'); shading interp; colorbar;
xlabel('x'); ylabel('y'); zlabel('f');
sgtitle('RBF 2D - Interpolation de surface');