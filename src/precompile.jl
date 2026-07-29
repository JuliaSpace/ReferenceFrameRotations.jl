## Description #############################################################################
#
# Precompilation workload to reduce the time-to-first-call of the most common operations.
#
############################################################################################

@setup_workload begin
    @compile_workload begin
        for T in (Float32, Float64)
            θ₁ = T(0.1)
            θ₂ = T(0.2)
            θ₃ = T(0.3)
            w  = T[0.1, 0.2, 0.3]

            # == Conversions from Euler angles =============================================

            D = angle_to_dcm(θ₁, θ₂, θ₃, :ZYX)
            q = angle_to_quat(θ₁, θ₂, θ₃, :ZYX)
            angle_to_angleaxis(θ₁, θ₂, θ₃, :ZYX)
            angle_to_crp(θ₁, θ₂, θ₃, :ZYX)
            angle_to_mrp(θ₁, θ₂, θ₃, :ZYX)
            angle_to_angle(θ₁, θ₂, θ₃, :ZYX, :XYZ)
            angle_to_dcm(θ₁, :X)
            angle_to_dcm(θ₁, θ₂, :XY)
            angle_to_rot(θ₁, θ₂, θ₃, :ZYX)
            smallangle_to_dcm(θ₁, θ₂, θ₃)
            smallangle_to_quat(θ₁, θ₂, θ₃)
            smallangle_to_rot(θ₁, θ₂, θ₃)

            # == Conversions from the other representations ================================

            av = dcm_to_angleaxis(D)
            c  = dcm_to_crp(D)
            m  = dcm_to_mrp(D)

            dcm_to_angle(D, :ZYX)
            dcm_to_quat(D)

            quat_to_angle(q, :ZYX)
            quat_to_angleaxis(q)
            quat_to_crp(q)
            quat_to_dcm(q)
            quat_to_mrp(q)

            angleaxis_to_angle(av, :ZYX)
            angleaxis_to_crp(av)
            angleaxis_to_dcm(av)
            angleaxis_to_mrp(av)
            angleaxis_to_quat(av)

            crp_to_angle(c, :ZYX)
            crp_to_angleaxis(c)
            crp_to_dcm(c)
            crp_to_mrp(c)
            crp_to_quat(c)

            mrp_to_angle(m, :ZYX)
            mrp_to_angleaxis(m)
            mrp_to_crp(m)
            mrp_to_dcm(m)
            mrp_to_quat(m)

            # == Functions and operations ==================================================

            orthonormalize(D)
            ddcm(D, w)
            dquat(q, w)
            dcrp(c, w)
            dmrp(m, w)
            shadow_rotation(m)

            compose_rotation(D, D)
            compose_rotation(q, q)
            inv_rotation(D)
            inv_rotation(q)
            inv_rotation(av)

            # == IO ========================================================================

            io = IOBuffer()
            for r in (D, q, av, c, m, EulerAngles(θ₁, θ₂, θ₃, :ZYX))
                show(io, r)
                show(io, MIME"text/plain"(), r)
            end
        end
    end
end
