using Symata

@sym begin
  ClearAll(f, y0, a, l, x)
  y0(x_) := (e*x)*(l^3 - 2*l*x^2 + x^3)
  
  # Stodola-Vianello method, e.g. see Den Hartog, Advanced Strength of Materials, pg 268
  f(maxiters_, y0_) := Module([i, yder, res=Table(Table( 0.0 , [i,6]), [j,maxiters])],
    (
      # Initialize the first row of the res matrix
      res[1,2] = y0(x),
      For(i=1, i<=4, Increment(i),
        [
          yder(x_) = Simplify(D(y0, x, i))
          res[1, 2+i] = yder(x)
        ]
      ),
      Println("N[res[1, 1]]: ", res[1,1]),
      # Start the loop to improve accuracy stored in subsequent rows,
      # res[i, 1] contains the Euler ratio.
      For(i=2, i<=maxiters, Increment(i),
        [
          res[i, 6] = Simplify(w/(EI)*((x-l)*res[i-1,4] + res[i-1,3]))
          # Above the basic Euler equation for a pinned-pinned flagpole
          ClearAll(K1, K11, tmpy5, tmpy4, tmp)
          tmpy5(x_) = Simplify(Integrate(res[i,6], x) + K1)
          tmpy4(x_) = Simplify(Integrate(tmpy5(x), x))
          # First pinned constraint
          K11 = Solve(-tmpy4(l), K1)
          res[i,5] = Simplify( tmpy5(x) ./ (K1 => K11[1, 1, 2]) )
          res[i,4] = Simplify( tmpy4(x) ./ (K1 => K11[1, 1, 2]) )
          ClearAll(K1, K11, tmpy3, tmpy2, tmp)
          tmpy3(x_) = Simplify(Integrate(res[i,4], x) + K1)
          tmpy2(x_) = Simplify(Integrate(tmpy3(x), x))
          # Second pinned constraint
          K11 = Solve(-tmpy2(l), K1)
          res[i,3] = Simplify( tmpy3(x) ./ (K1 => K11[1, 1, 2]) )
          res[i,2] = Simplify( tmpy2(x) ./ (K1 => K11[1, 1, 2]) )
          tmp = Simplify( (((l^3)*w)/EI)*(res[i-1,3]/res[i, 3]) )
          res[i,1] = N(Simplify(ReplaceAll(tmp, x => l)))
          Println("N[res[",i,", 1]]: ", res[i,1])
        ]
      ),
      Return(res)
    )
  )
  r = f(9, y0(x))
  Println(Transpose(r))
  # Mathematica results (for 9 iterations): 
  # {0, 22.703, 19.110, 18.669, 18.589, 18.573, 18.570, 18.569}
end
