import Base: full, ==, copy

type BandedMatrix{Tv}
    m::Int                      # Number of rows
    n::Int                      # Number of columns
    hbw::Int                     # Bandwidth bw = 1 + 2*hbw
    mat::Matrix{Tv}             # Banded matrix
end

==(a::BandedMatrix, b::BandedMatrix) = a.n==b.n
copy(a::BandedMatrix) = BandedMatrix(a.m, a.n, a.hbw, a.mat)

function BandedMatrix(mat::Matrix, hbw::Int)
  n = m = size(mat, 1)
  # hbw = (bw - 1)÷2
  b = zeros(eltype(mat), n, hbw+1)
  for i in 1:n
    b[i, hbw+1] = mat[i, i]
    for j in 1:hbw
      if i - hbw + j > 1
        b[i, j] = mat[i, i - hbw + j - 1]
      end
    end
  end
  BandedMatrix{eltype(mat)}(m, n, hbw, b)
end

function full(bmat::BandedMatrix)
  n = size(bmat.mat, 1)
  b = zeros(eltype(bmat.mat), n, n)
  hbw = bmat.hbw
  for i in n:-1:1
    b[i, i] = bmat.mat[i, hbw+1]
    for j in hbw:-1:1
      if i-hbw+j-1 >0 && abs(bmat.mat[i, j]) > eps()
        b[i, i-hbw+j-1] = bmat.mat[i, j]
        b[i-hbw+j-1, i] = bmat.mat[i, j]
      end
    end
  end
  b
end

#=
function tobandedmatrix(a::Matrix, hbw::Int64)
  n = size(a, 1)
  b = zeros(eltype(a), n, hbw+1)
  for i in 1:n
    b[i, hbw+1] = a[i, i]
    for j in 1:hbw
      if i - hbw + j > 1
        b[i, j] = a[i, i - hbw + j - 1]
      end
    end
  end
  b
end
=#