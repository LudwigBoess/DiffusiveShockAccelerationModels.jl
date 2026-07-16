"""
    Gupta2024_t(X_cr::T=0.05) where T

Efficiency model by Gupta2024_t, Caprioli & Spitkovsky 2024: MNRAS, 478, 4, 5278–5295, https://arxiv.org/pdf/1805.00128.pdf

## Values 
- `X_cr`: P_cr / P_th defined in model for re-acceleration. Basis for interpolation between acceleration and re-acceleration efficiency.
"""
struct Gupta2024_t{T} <: AbstractShockAccelerationEfficiency
    X_cr::T
    Gupta2024_t(X_cr::T = 0.05) where {T} = new{T}(X_cr)
end

"""
    η_B(η_model::Gupta2024_t, θ_B::Real, θ_crit::Real)

Calculate B angle dependent efficiency component following Pais et. al. 2018, eq. 7, https://arxiv.org/pdf/1805.00128.pdf
"""
@inline function η_B(η_model::Gupta2024_t, θ_B::Real, θ_crit::Real)
    (tanh((θ_crit - θ_B) / π / 18) + 1) / 2
end

"""
    ηB_acc_p(η_model::Gupta2024_t, θ_B::Real)

Magnetic field geometry dependent efficiency for protons at initial acceleration.
"""
function ηB_acc_p(η_model::Gupta2024_t, θ_B::Real)
    η_B(η_model, θ_B, π / 3.5)
end

"""
    ηB_reacc_p(η_model::Gupta2024_t, θ_B::Real)

Magnetic field geometry dependent efficiency for protons at reacceleration.
"""
ηB_reacc_p(η_model::Gupta2024_t, θ_B::Real) = ηB_acc_p(η_model, θ_B)

"""
    ηB_acc_e(η_model::Gupta2024_t, θ_B::Real)

Magnetic field geometry dependent efficiency for electrons at initial acceleration.
"""
ηB_acc_e(η_model::Gupta2024_t, θ_B::Real) = ηB_acc_p(η_model, θ_B)

"""
    ηB_reacc_e(η_model::Gupta2024_t, θ_B::Real)

Magnetic field geometry dependent efficiency for electrons at reacceleration.
"""
ηB_reacc_e(η_model::Gupta2024_t, θ_B::Real) = ηB_acc_p(η_model, θ_B)