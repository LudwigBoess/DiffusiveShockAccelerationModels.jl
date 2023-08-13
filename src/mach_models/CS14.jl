"""

Taken from Vazza et. al. (2016): doi:10.1093/mnras/stw584

They assume Caprioli+Spitkovsky (2014) efficiency is roughly half of Kang&Ryu (2013)

We account for angle dependent efficiency independently.
"""
const vazza_factor = 1//2

"""
        CS14(X_cr::T=0.05, η_max::T=0.5*0.2055) where T

Efficiency model by Caprioli&Spitkovsky 2014 efficiency.

## Values 
- `X_cr`: P_cr / P_th defined in model for re-acceleration. Basis for interpolation between acceleration and re-acceleration efficiency.
- `η_max`: Maximum efficiency defined in the model
"""
struct CS14{T} <: AbstractShockAccelerationEfficiency
    X_cr::T
    η_max::T

    CS14(X_cr::T = 0.05, η_max::T = 0.5 * 0.2055) where {T} = new{T}(X_cr, η_max)
end

"""
    η_Ms_acc(η_model::CS14, M::T) where T

Efficiency from Caprioli&Spitkovsky 2015, doi: 10.1088/0004-637x/783/2/91
Same simplified approach as Vazza+16 -> is roughly half the efficiency of Kang&Ryu 2013.
"""
function η_Ms_acc(η_model::CS14, M::Real)
    return vazza_factor * η_Ms_acc(KR13(), M)
end

"""
    η_Ms_reacc(η_model::CS14, M::T) where T

Efficiency from Caprioli&Spitkovsky 2015, doi: 10.1088/0004-637x/783/2/91
Same simplified approach as Vazza+16 -> is roughly half the efficiency of Kang&Ryu 2013.
"""
function η_Ms_reacc(η_model::CS14, M::Real)
    return vazza_factor * η_Ms_reacc(KR13(), M)
end