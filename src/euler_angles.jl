# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                 Euler Angles
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

#==#
#
# @brief Create a rotation matrix that rotates a coordinate system about a
# specified axis.
#
# @param [in] angle Angle.
# @param [in] axis Axis, must be 'x', 'X', 'y', 'Y', 'z', and 'Z'.
#
# @return The rotation matrix that rotates the coordinate frame about 'axis'.
#
#==#

function create_rotation_matrix{T}(angle::T, axis::Char)
    cos_angle = cos(angle)
    sin_angle = sin(angle)

    if (axis == 'x') || (axis == 'X')

        matrix = [1      0         0    ;
                  0  cos_angle sin_angle;
                  0 -sin_angle cos_angle;];

    elseif (axis == 'y') || (axis == 'Y')

        matrix = [ cos_angle 0 -sin_angle;
                       0     1      0;
                   sin_angle 0  cos_angle;];

    elseif (axis == 'z') || (axis == 'Z')

        matrix = [  cos_angle sin_angle 0;
                   -sin_angle cos_angle 0;
                        0         0     1;];
    
    else
        error("axis must be X, Y, or Z");
    end

    return matrix
end

#==#
# 
# @brief Convert Euler angles to a direction cosine matrix.
# 
# @param [in] angle_r1 Angle of the first rotation.
# @param [in] angle_r2 Angle of the second rotation.
# @param [in] angle_r3 Angle of the third rotation.
# @param [in] rot_seq Rotation sequence.
#     
# @return The direction cossine matrix.
# 
# @remarks This function returns the matrix R = A1*A2*A3, in which Ai is the DCM
# related with the i-th rotation.
# 
# Example:
# @code
#     dcm = angle2dcm(pi/2, pi, pi/4, "ZYX");
# @endcode
# 
#==#

function angle2dcm{T}(angle_r1::T,
                      angle_r2::T,
                      angle_r3::T,
                      rot_seq::String="ZYX")
    
    # Check if rot_seq has at least three characters.
    if (length(rot_seq) < 3)
        throw(ArgumentError)
    end

    matrix_r1 = create_rotation_matrix(angle_r1, rot_seq[1])
    matrix_r2 = create_rotation_matrix(angle_r2, rot_seq[2])
    matrix_r3 = create_rotation_matrix(angle_r3, rot_seq[3])

    matrix = matrix_r3*matrix_r2*matrix_r1
end

#==#
# 
# @brief Convert Euler angles to a direction cosine matrix.
# 
# @param [in] eulerang Euler angles (@see EulerAngle).
#     
# @return The direction cossine matrix.
# 
# @remarks This function returns the matrix R = A1*A2*A3, in which Ai is the DCM
# related with the i-th rotation.
# 
# Example:
# @code
#     dcm = angle2dcm(EulerAngle(pi/2, pi, pi/4, "ZYX"));
# @endcode
# 
#==#

function angle2dcm{T}(eulerang::EulerAngles{T})
    angle2dcm(eulerang.a1,
              eulerang.a2,
              eulerang.a3,
              eulerang.rot_seq)
end
