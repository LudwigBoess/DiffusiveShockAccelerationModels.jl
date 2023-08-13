module DiffusiveShockAccelerationModels


export AbstractShockAccelerationEfficiency,
    # efficiency models
    Kang07, KR13, CS14, Ryu19, P16,
    # mach nummber dependent efficiency 
    η_Ms, η_Ms_acc, η_Ms_reacc,
    # B-field dependent efficiency
    η_B,
    ηB_acc_e, ηB_acc_p, ηB_reacc_e, ηB_reacc_p


"""
    AbstractShockAccelerationEfficiency

Abstract type for shock acceleration efficiencies
"""
abstract type AbstractShockAccelerationEfficiency end


"""
    Helper functions
"""
# power functions
@inline p2(x::T) where {T} = x * x
@inline p3(x::T) where {T} = x * x * x

"""
    kr_fitting_function(x::Real, a0::Real, a1::Real, a2::Real, a3::Real, a4::Real)

Helper function to use the fitting function from KR07.
"""
@inline function kr_fitting_function(x::Real,
    a0::Real, a1::Real, a2::Real, a3::Real, a4::Real)
    mm = x - 1
    return (a0 + a1 * mm + a2 * p2(mm) + a3 * p3(mm) + a4 * p2(p2(mm))) / p2(p2(x))
end

"""
    η_Ms(η_model::AbstractShockAccelerationEfficiency, M::T, X_cr::T) where {T<:Real}

Calculates the sonic Mach Number dependent η_model as a linear interpolation between acceleration and reacceleration.
"""
function η_Ms(η_model::AbstractShockAccelerationEfficiency, M::T, X_cr::T) where {T<:Real}

    # check if pressure ratio is greater than the target ratio
    if X_cr > η_model.X_cr
        X_cr = η_model.X_cr
    end

    # initial acceleration
    η1 = η_Ms_acc(η_model, M)
    X1::T = 0

    # reacceleration
    η2 = η_Ms_reacc(η_model, M)
    X2 = η_model.X_cr

    # linear interpolation between the two cases:
    η_tot::T = η1 + (X_cr - X1) * (η2 - η1) / (X2 - X1)

    # check if η_tot is smaller than the maximum η_model
    if η_tot > η_model.η_max
        return η_model.η_max
    else
        if η_tot < 0
            return T(0)
        else
            return η_tot
        end
    end

end



include("mach_models/Kang07.jl")
include("mach_models/KR13.jl")
include("mach_models/CS14.jl")
include("mach_models/Ryu19.jl")
include("mach_models/Pfrommer16.jl")

include("B_models/pais.jl")

using PrecompileTools    # this is a small dependency

@setup_workload begin
    # Putting some things in `setup` can reduce the size of the
    # precompile file and potentially make loading faster.
    η_models = [Kang07(), KR13(), CS14(), Ryu19()]

    @compile_workload begin
        # all calls in this block will be precompiled, regardless of whether
        # they belong to your package or not (on Julia 1.8 and higher)

        # loop over models
        for η ∈ η_models
            # loop over Mach numbers
            for M ∈ [1.0, 1.5, 3.0, 10.0]
                η_Ms_acc(η, M)
                η_Ms_reacc(η, M)
                # loop over seed populations
                for Xcr ∈ [0.0, 0.05]
                    η_Ms(η, M, Xcr)
                end
            end
        end

        ηB_acc_p(1.0)
        ηB_reacc_p(1.0)
        ηB_acc_e(1.0)
        ηB_reacc_e(1.0)
    end
end


end # module
