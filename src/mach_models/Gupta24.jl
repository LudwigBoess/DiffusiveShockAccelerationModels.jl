"""
    Gupta24_p(X_cr::T=1.0, η_max::T=0.03) where T

Efficiency model for protons by Gupta, Caprioli & Sptikovsky (2024)

## Values 
- `X_cr`: P_cr / P_th defined in model for re-acceleration. Basis for interpolation between acceleration and re-acceleration efficiency.
- `η_max`: Maximum efficiency defined in the model
"""
struct Gupta24_p{T} <: AbstractShockAccelerationEfficiency
    X_cr::T
    η_max::T

    Gupta24_p(X_cr::T = 1.0, η_max::T = 0.1) where {T} = new{T}(X_cr, η_max)
end

"""
    η_Ms_acc(η_model::Gupta24_p, M::Real)

Initial acceleration efficiency model for protons by Gupta, Caprioli & Sptikovsky (2024)
"""
function η_Ms_acc(η_model::Gupta24_p, M::Real)
    if M < 2.0
        return 0
    else
        return η_model.η_max
    end
end

"""
    η_Ms_reacc(η_model::Gupta24_p, M::Real)

Reacceleration efficiency for model by Kang (2024), identical to acceleration efficiency.
"""
function η_Ms_reacc(η_model::Gupta24_p, M::Real)
    η_Ms_acc(η_model, M)
end



"""
    Gupta24_e(X_cr::T=1.0, η_max::T=0.0004871685) where T

Efficiency model for electrons by Gupta, Caprioli & Sptikovsky (2024)

## Values 
- `X_cr`: P_cr / P_th defined in model for re-acceleration. Basis for interpolation between acceleration and re-acceleration efficiency.
- `η_max`: Maximum efficiency defined in the model
"""
struct Gupta24_e{T} <: AbstractShockAccelerationEfficiency
    X_cr::T
    η_max::T

    Gupta24_e(X_cr::T = 1.0, η_max::T = 0.06) where {T} = new{T}(X_cr, η_max)
end


"""
    η_Ms_acc(η_model::Gupta24_e, M::Real)

Initial acceleration efficiency model for electrons by Gupta, Caprioli & Sptikovsky (2024)
"""
function η_Ms_acc(η_model::Gupta24_e, M::Real)
    if M < 2.0
        return 0
    else
        p = [19.301588195907662, -0.6544505664085758, 30053.623240151297, -2.420544376432326, 0.0024391157810159103]
        return p[1] * M^p[2] / (1 + p[3] * M^p[4]) + p[5]
    end
end

"""
    η_Ms_reacc(η_model::Gupta24_e, M::Real)

Reacceleration efficiency for model by Kang (2024), identical to acceleration efficiency.
"""
function η_Ms_reacc(η_model::Gupta24_e, M::Real)
    η_Ms_acc(η_model, M)
end
