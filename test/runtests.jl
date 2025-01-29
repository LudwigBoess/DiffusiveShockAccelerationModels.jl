using Test, DiffusiveShockAccelerationModels

function read_dsa_data(filename)
    f = open(filename, "r")
    N_mach = read(f, Int64)
    M = read!(f, Vector{Float64}(undef, N_mach))
    η = read!(f, Vector{Float64}(undef, N_mach))
    η_r = read!(f, Vector{Float64}(undef, N_mach))
    close(f)

    return N_mach, M, η, η_r
end

@testset "DiffusiveShockAccelerationModels" begin

    @testset "Mach Models" begin

        @testset "Kang et. al. 2007" begin
            η_model = Kang07()
            N_mach, M, η, η_r = read_dsa_data("Kang07.dat")

            @testset "η" begin

                @test η_Ms(η_model, 0.5, 0.0) == 0.0

                for i = 1:N_mach
                    @test η_Ms(η_model, M[i], 0.0) ≈ η[i]
                end
            end

            @testset "η_r" begin
                @test η_Ms(η_model, 0.5, 1.0) == 0.0

                for i = 1:N_mach
                    @test η_Ms(η_model, M[i], 1.0) ≈ η_r[i]
                end
            end

        end

        @testset "Kang & Ryu 2013" begin
            η_model = KR13()
            N_mach, M, η, η_r = read_dsa_data("KR13.dat")

            @testset "η" begin
                for i = 1:N_mach
                    @test η_Ms(η_model, M[i], 0.0) ≈ η[i]
                end
            end

            @testset "η_r" begin
                for i = 1:N_mach
                    @test η_Ms(η_model, M[i], 1.0) ≈ η_r[i]
                end
            end

        end

        @testset "Caprioli & Spitkovsky 2014" begin
            η_model = CS14()
            N_mach, M, η, η_r = read_dsa_data("CS14.dat")

            @testset "η" begin
                for i = 1:N_mach
                    @test η_Ms(η_model, M[i], 0.0) ≈ η[i]
                end
            end

            @testset "η_r" begin
                for i = 1:N_mach
                    @test η_Ms(η_model, M[i], 1.0) ≈ η_r[i]
                end
            end

        end

        @testset "Ryu et. al. 2019" begin
            η_model = Ryu19()
            N_mach, M, η, η_r = read_dsa_data("Ryu19.dat")

            @testset "η" begin
                for i = 1:N_mach
                    @test η_Ms(η_model, M[i], 0.0) ≈ η[i]
                end
            end

            @testset "η_r" begin
                for i = 1:N_mach
                    @test η_Ms(η_model, M[i], 1.0) ≈ η_r[i]
                end
            end

        end

        @testset "Kang 2024" begin
            η_model = Kang24_p()
            N_mach, M, η, η_r = read_dsa_data("Kang2024_p.dat")

            @testset "protons" begin
                for i = 1:N_mach
                    @test η_Ms(η_model, M[i], 0.0) ≈ η[i]
                end
            end

            η_model = Kang24_e()
            N_mach, M, η, η_r = read_dsa_data("Kang2024_e.dat")

            @testset "electrons" begin
                for i = 1:N_mach
                    @test η_Ms(η_model, M[i], 0.0) ≈ η_r[i]
                end
            end

        end

        @testset "Pfrommer et. al. 2016" begin
            η_model = P16()

            @test η_Ms(η_model, 10.0, 0.0) == 0.5
            @test η_Ms(η_model, 10.0, 1.0) == 0.5
        end
    end

    @testset "B-field Models" begin

        @testset "Electrons" begin
            # read reference data
            N_θ, θ_B, η, η_r = read_dsa_data("theta_B_e.dat")

            @testset "η" begin
                for i = 1:N_θ
                    @test ηB_acc_e(θ_B[i]) ≈ η[i]
                end
            end
            @testset "η_r" begin
                for i = 1:N_θ
                    @test ηB_reacc_e(θ_B[i]) ≈ η_r[i]
                end
            end
        end

        @testset "Protons" begin
            # read reference data
            N_θ, θ_B, η, η_r = read_dsa_data("theta_B_p.dat")

            @testset "η" begin
                for i = 1:N_θ
                    @test ηB_acc_p(θ_B[i]) ≈ η[i]
                end
            end
            @testset "η_r" begin
                for i = 1:N_θ
                    @test ηB_reacc_p(θ_B[i]) ≈ η_r[i]
                end
            end
        end
    end

end