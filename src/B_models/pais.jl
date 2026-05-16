const δθ = π / 18
const π_third = π / 3
const π_fourth = π / 4
const π_sixth = π / 6


"""
    Pais2018_t(X_cr::T=0.05) where T

Efficiency model by Pais et al. 2018: MNRAS, 478, 4, 5278–5295, https://arxiv.org/pdf/1805.00128.pdf

## Values 
- `X_cr`: P_cr / P_th defined in model for re-acceleration. Basis for interpolation between acceleration and re-acceleration efficiency.
"""
struct Pais2018_t{T} <: AbstractShockAccelerationEfficiency
    X_cr::T
    Pais2018_t(X_cr::T = 0.05) where {T} = new{T}(X_cr)
end


"""
    η_B(θ_B::Real, θ_crit::Real)

Calculate B angle dependent efficiency component following Pais et. al. 2018, eq. 7, https://arxiv.org/pdf/1805.00128.pdf
"""
@inline function η_B(η_model::Pais2018_t, θ_B::Real, θ_crit::Real)
    (tanh((θ_crit - θ_B) / δθ) + 1) / 2
end

"""
    ηB_acc_p(θ_B::Real)

Magnetic field geometry dependent efficiency for protons at initial acceleration.
"""
function ηB_acc_p(η_model::Pais2018_t, θ_B::Real)
    η_B(η_model, θ_B, π_fourth)
end

"""
    ηB_reacc_p(θ_B::Real)

Magnetic field geometry dependent efficiency for protons at reacceleration.
"""
function ηB_reacc_p(η_model::Pais2018_t, θ_B::Real)
    η_B(η_model, θ_B, π_third)
end

"""
    ηB_acc_e(θ_B::Real)

Magnetic field geometry dependent efficiency for electrons at initial acceleration.
"""
function ηB_acc_e(η_model::Pais2018_t, θ_B::Real)
    1 - η_B(η_model, θ_B, π_fourth)
end

"""
    ηB_reacc_e(θ_B::Real)

Magnetic field geometry dependent efficiency for electrons at reacceleration.
"""
function ηB_reacc_e(η_model::Pais2018_t, θ_B::Real)
    1 - η_B(η_model, θ_B, π_sixth)
end