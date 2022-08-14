
# Utilização de pacotes/módulos:
using DelimitedFiles, Statistics, LsqFit, PyPlot

# Os dois primeiros fazem parte da biblioteca padrão de Julia 1.0, os quais devem ser evocados para serem utilizados
# nesta nova versão. DelimitedFiles será necessário para leitura dos dados experimentais contidos no arquivo de 
# texto dados.txt. Statistics será necessário para o cálculo da média do espaço amostral das posições angulares.
# LsqFit é o pacote a ser utilizado para ajustar a solução analítica aos dados experimentais do pêndulo físico.
# PyPlot é um módulo do Python utilizado para plotagem de gráficos.

# Leitura dos dados experimentais:
dados = readdlm("dados.txt")

# Amostra de instantes de tempo corrigidos conforme FPS ("frames per second") da câmera utilizada:
texp = dados[:,1]/4

# Amostra de posições angulares em radianos:
θexp = dados[:,2]*(pi/180)

# Eliminação do componente de polariação CC ("DC bias"):
X = copy(θexp)
for i=1:2351
    X[i] = θexp[i] - mean(θexp)
end
θexp = X

# Posição angular inicial:
θexp0 = maximum(θexp)

#Plotagem dos pontos experimentais:
close("all")
figure(1)
    plot(texp, θexp, "r.")
    title("Pêndulo físico: pontos experimentais")
    xlabel(L"$t_\mathrm{exp}$ (s)")
    ylabel(L"$\theta_\mathrm{exp}$ (rad)")
    grid()

# Solução do modelo teórico em termos do tempo e os parâmetros constantes amplitude angular, p[1], frequência
# angular, p[2], e ângulo de fase, p[3] (conforme descrito na seção "Introdução"):
modelo(x, p) = p[1].*sin.(p[2].*x.+p[3])

# Especulação incial para os parâmetros:
p0 = [θexp0, 4.1, 0]

# Aplicação do ajuste da solução do modelo teórico aos dados experimentais tomando como especulação incial para os
# parâmetros p0[1], p0[2] e p0[3] acima definidos:
fit = curve_fit(modelo, texp, θexp, p0)

# Redefinição dos parâmetros conforme o ajuste:
k = fit.param

# Definição do domínio de tempo analítico como igual ao experimental (formalidade dispensável):
t = texp

# Solução analítica ajustada aos dados experimentais:
θ = k[1].*sin.(k[2].*t.+k[3])

# Pontos experimentais e solução analítica ajustada:
figure(2)
    plot(texp, θexp,"r.", label="Pontos experimentais")
    plot(t, θ, label="Curva ajustada")
    title("Pêndulo físico: pontos experimentais e solução analítica ajustada")
    xlabel("tempo (s)")
    ylabel("posição angular (rad)")
    legend()
    grid()


