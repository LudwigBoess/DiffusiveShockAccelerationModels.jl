"""
        Ryu19(X_cr::T=0.05, η_max::T=0.0348) where T 

Efficiency model by Ryu et al. 2019: https://arxiv.org/pdf/1905.04476v2.pdf.

## Values 
- `X_cr`: P_cr / P_th defined in model for re-acceleration. Basis for interpolation between acceleration and re-acceleration efficiency.
- `η_max`: Maximum efficiency defined in the model
"""
struct Ryu19{T} <: AbstractShockAccelerationEfficiency
    X_cr::T
    η_max::T

    Ryu19(X_cr::T = 0.05, η_max::T = 0.0348) where {T} = new{T}(X_cr, η_max)
end


"""
    η_Ms_acc(η_model::Ryu19, M::T) where T

Efficiency model from Ryu et al. 2019, https://arxiv.org/abs/1905.04476
Values for 2.25 < M <= 5.0 extrapolated to entire range
"""
function η_Ms_acc(η_model::Ryu19, M::Real)

    if M < 2.25
        return 0.0
    elseif M <= 34
        return kr_fitting_function(M, -1.5255, 2.4026, -1.2534, 0.2215, 0.0336)
    else
        return 0.0348
    end
end


"""
    η_Ms_reacc(η_model::Ryu19, M::T) where T

Efficiency model from Ryu et al. 2019, https://arxiv.org/abs/1905.04476
Values for 2.25 < M <= 5.0 extrapolated to entire range
"""
function η_Ms_reacc(η_model::Ryu19, M::Real)

    if M < 2.25
        return 0.0
    elseif M <= 34
        return kr_fitting_function(M, 0.3965, -0.21898, -0.2074, 0.1319, 0.0351)
    else
        return 0.0348
    end
end