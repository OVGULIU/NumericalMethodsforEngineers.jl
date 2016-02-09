using NMfE

a = Float64[10 1 -5; -20 3 20; 5 3 5]
b = Float64[1; 2; 6]
x0 = Float64[1; 1; 1]

(iters, converged, r1) = NMfE.bicgstab(a, b, x0, trace=true)
println()
println(r1)
println()

N = 10
a = float(rand(1:10 * N, N, N))
x = float(rand(1:10, N))
b = a * x
x0 = ones(N)

println()

println()
(iters, converged, r2) = NMfE.bicgstab(a, b, x0, limit=1000)
println()
@time NMfE.bicgstab(a, b, x0, limit=1000)
println()
@time NMfE.bicgstab(a, b, x0, tol=1.0e-8, limit=1000, trace=true)

println()
@show a \ b

