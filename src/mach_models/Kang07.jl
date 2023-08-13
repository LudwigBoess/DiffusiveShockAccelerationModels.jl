"""
    Kang07(X_cr::T=0.05, η_max::T=0.0348) where T

Efficiency model by Kang, Ryu, Cen, Ostriker 2007, http://arxiv.org/abs/0704.1521v1

## Values 
- `X_cr`: P_cr / P_th defined in model for re-acceleration. Basis for interpolation between acceleration and re-acceleration efficiency.
- `η_max`: Maximum efficiency defined in the model
"""
struct Kang07{T} <: AbstractShockAccelerationEfficiency
    X_cr::T
    η_max::T

    Kang07(X_cr::T = 0.3, η_max::T = 0.57) where {T} = new{T}(X_cr, η_max)
end


"""
    η_Ms_acc(η_model::Kang07, M::Real)

Initial acceleration efficiency for model from Kang, Ryu, Cen, Ostriker 2007, http://arxiv.org/abs/0704.1521v1
"""
function η_Ms_acc(η_model::Kang07, M::Real)
    if M < 1
        return 0
    elseif M <= 2
        return 1.96e-3 * (M^2 - 1)             # eq. A3
    else
        return kr_fitting_function(M, 5.46, -9.78, 4.17, -0.334, 0.57)
    end
end

"""
    η_Ms_reacc(η_model::Kang07, M::Real)

Reacceleration efficiency for model from Kang, Ryu, Cen, Ostriker 2007, http://arxiv.org/abs/0704.1521v1
"""
function η_Ms_reacc(η_model::Kang07, M::Real)
    if M <= 1.5
        # adiabatic index of gas
        γ = 5 / 3
        m2 = M^2
        # analytic compression ratio
        xs = (γ + 1) / (γ - 1 + 2 / m2)
        δ0 = 2 * ((2γ * m2 - γ + 1.0) / (γ + 1) - (xs^γ)) /
                (γ * (γ - 1) * m2 * xs)

        return 1.025 * δ0
    else
        return kr_fitting_function(M, 0.24, -1.56, 2.8, 0.512, 0.557)
    end
end
