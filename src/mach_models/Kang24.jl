"""
    Kang24_p(X_cr::T=1.0, η_max::T=0.03) where T

Efficiency model for protons by Kang (2024).

## Values 
- `X_cr`: P_cr / P_th defined in model for re-acceleration. Basis for interpolation between acceleration and re-acceleration efficiency.
- `η_max`: Maximum efficiency defined in the model
"""
struct Kang24_p{T} <: AbstractShockAccelerationEfficiency
    X_cr::T
    η_max::T

    Kang24_p(X_cr::T = 1.0, η_max::T = 0.03) where {T} = new{T}(X_cr, η_max)
end

"""
    η_Ms_acc(η_model::Kang24_p, M::Real)

Initial acceleration efficiency model for protons by Kang (2024).
"""
function η_Ms_acc(η_model::Kang24_p, M::Real)
    if M < 1
        return 0
    elseif M < 2.3
        return 0.01 * (M/2.3)^4.88
    elseif 2.3 <= M < 3.5
        return kr_fitting_function(M, 4.03, -8.8, 6.11, -1.44, 0.171)
    else
        return η_model.η_max
    end
end

"""
    η_Ms_reacc(η_model::Kang24_p, M::Real)

Reacceleration efficiency for model by Kang (2024), identical to acceleration efficiency.
"""
function η_Ms_reacc(η_model::Kang24_p, M::Real)
    η_Ms_acc(η_model, M)
end



"""
    Kang24_e(X_cr::T=1.0, η_max::T=0.0004871685) where T

Efficiency model for electrons by Kang (2024).

## Values 
- `X_cr`: P_cr / P_th defined in model for re-acceleration. Basis for interpolation between acceleration and re-acceleration efficiency.
- `η_max`: Maximum efficiency defined in the model
"""
struct Kang24_e{T} <: AbstractShockAccelerationEfficiency
    X_cr::T
    η_max::T

    Kang24_e(X_cr::T = 1.0, η_max::T = 0.0004871685) where {T} = new{T}(X_cr, η_max)
end


"""
    η_Ms_acc(η_model::Kang24_e, M::Real)

Initial acceleration efficiency model for electrons by Kang (2024).
"""
function η_Ms_acc(η_model::Kang24_e, M::Real)
    if M < 2.3
        return 8.36e-6 * (M/2.3)^14.1
    elseif 2.3 <= M < 10.0
        return kr_fitting_function(M, -2.85e-3, 1.12e-2, -1.32e-2, 4.37e-3, 4.05e-4)
    else
        return η_model.η_max
    end
end

"""
    η_Ms_reacc(η_model::Kang24_e, M::Real)

Reacceleration efficiency for model by Kang (2024), identical to acceleration efficiency.
"""
function η_Ms_reacc(η_model::Kang24_e, M::Real)
    η_Ms_acc(η_model, M)
end
