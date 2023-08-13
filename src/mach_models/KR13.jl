"""
    KR13(X_cr::T=0.05, η_max::T=0.0348) where T

Efficiency model by Kang&Ryu 2013: ApJ, 764, 95.

## Values 
- `X_cr`: P_cr / P_th defined in model for re-acceleration. Basis for interpolation between acceleration and re-acceleration efficiency.
- `η_max`: Maximum efficiency defined in the model
"""
struct KR13{T} <: AbstractShockAccelerationEfficiency
    X_cr::T
    η_max::T

    KR13(X_cr::T = 0.05, η_max::T = 0.2055) where {T} = new{T}(X_cr, η_max)
end


"""
    η_Ms_acc(η_model::KR13, M::T) where T

Efficiency model from Kang&Ryu 2013, doi:10.1088/0004-637X/764/1/95
"""
function η_Ms_acc(η_model::KR13, M::Real)

    if M < 2
        return 0.0
    elseif 2 <= M <= 5
        return -0.0005950569221922047 + 1.880258286365841e-5 * M^5.334076006529829
    elseif 5 < M <= 15
        return kr_fitting_function(M, -2.8696966498579606, 9.667563166507879,
            -8.877138312318019, 1.938386688261113, 0.1806112438315771)
    else
        return 0.21152
    end
end

"""
    η_Ms_reacc(η_model::KR13, M::T) where T

Efficiency model from Kang&Ryu 2013, doi:10.1088/0004-637X/764/1/95
"""
function η_Ms_reacc(η_model::KR13, M::Real)

    if M < 2
        return 0.0
    elseif M <= 17.7
        return kr_fitting_function(M, -0.722, 2.7307, -3.2854, 1.3428, 0.1901)
    else
        return 0.2055
    end
end
