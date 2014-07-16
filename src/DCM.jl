# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                          Direction Cosine Matrices
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Functions that converts DCMs into Euler Angles.
# 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

function dcm2angle{T}(dcm::Array{T,2}, rot_seq::String="ZYX")
    # Check if the dcm is a 3x3 matrix.
    if (size(dcm,1) != 3) || (size(dcm,2) != 3)
        throw(ArgumentError)
    end
    
    # Check if rot_seq has at least three characters.
    if length(rot_seq) < 3
        throw(RotationSequenceError)
    end
    
    # For each rotation sequence, compute the euler angles.
    rot_seq = uppercase(rot_seq)

    if( beginswith(rot_seq, "ZYX") )

        EulerAngles(atan2(+dcm[1,2],+dcm[1,1]),
                     asin(-dcm[1,3]),
                    atan2(+dcm[2,3],+dcm[3,3]),
                    rot_seq)

    elseif( beginswith(rot_seq, "XYX") )

        EulerAngles(atan2(+dcm[1,2],-dcm[1,3]),
                     acos(+dcm[1,1]),
                    atan2(+dcm[2,1],+dcm[3,1]),
                    rot_seq)

    elseif( beginswith(rot_seq, "XYZ") )

        EulerAngles(atan2(-dcm[3,2],+dcm[3,3]),
                     asin(+dcm[3,1]),
                    atan2(-dcm[2,1],+dcm[1,1]),
                    rot_seq)

    elseif( beginswith(rot_seq, "XZX") )

        EulerAngles(atan2(+dcm[1,3],+dcm[1,2]),
                     acos(+dcm[1,1]),
                    atan2(+dcm[3,1],-dcm[2,1]),
                    rot_seq)

    elseif( beginswith(rot_seq, "XZY") )

        EulerAngles(atan2(+dcm[2,3],+dcm[2,2]),
                     asin(-dcm[2,1]),
                    atan2(+dcm[3,1],+dcm[1,1]),
                    rot_seq)

    elseif( beginswith(rot_seq, "YXY") )

        EulerAngles(atan2(+dcm[2,1],+dcm[2,3]),
                     acos(+dcm[2,2]),
                    atan2(+dcm[1,2],-dcm[3,2]),
                    rot_seq)

    elseif( beginswith(rot_seq, "YXZ") )

        EulerAngles(atan2(+dcm[3,1],+dcm[3,3]),
                     asin(-dcm[3,2]),
                    atan2(+dcm[1,2],+dcm[2,2]),
                    rot_seq)

    elseif( beginswith(rot_seq, "YZX") )

        EulerAngles(atan2(-dcm[1,3],+dcm[1,1]),
                     asin(+dcm[1,2]),
                    atan2(-dcm[3,2],+dcm[2,2]),
                    rot_seq)

    elseif( beginswith(rot_seq, "YZY") )

        EulerAngles(atan2(+dcm[2,3],-dcm[2,1]),
                     acos(+dcm[2,2]),
                    atan2(+dcm[3,2],+dcm[1,2]),
                    rot_seq)

    elseif( beginswith(rot_seq, "ZXY") )

        EulerAngles(atan2(-dcm[2,1],+dcm[2,2]),
                     asin(+dcm[2,3]),
                    atan2(-dcm[1,3],+dcm[3,3]),
                    rot_seq)

    elseif( beginswith(rot_seq, "ZXZ") )

        EulerAngles(atan2(+dcm[3,1],-dcm[3,2]),
                     acos(+dcm[3,3]),
                    atan2(+dcm[1,3],+dcm[2,3]),
                    rot_seq)

    elseif( beginswith(rot_seq, "ZYZ") )

        EulerAngles(atan2(+dcm[3,2],+dcm[3,1]),
                     acos(+dcm[3,3]),
                    atan2(+dcm[2,3],-dcm[1,3]),
                    rot_seq)

    else
        throw(RotationSequenceError)
    end
end