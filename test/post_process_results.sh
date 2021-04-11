#===============================================================================
#
# Copyright (C) 2021 Istituto Italiano di Tecnologia (IIT)
#
# This software may be modified and distributed under the terms of the
# GPL-2+ license. See the accompanying LICENSE file for details.
#
#===============================================================================

CONVERSION_TOOL=?/synthetic_tracknet_poserbpf/Conversion/nvdu_poses_to_ycbv.py
YCBV_SYN_PATH=?

mkdir -p ./results/gt

for object_name in `cat config/classes.txt`
do
    OBJECT_ID=""
    if [ $object_name == "003_cracker_box" ]; then
        OBJECT_ID="2";
    elif [ $object_name == "004_sugar_box" ]; then
        OBJECT_ID="3"
    elif [ $object_name == "005_tomato_soup_can" ]; then
        OBJECT_ID="4"
    elif [ $object_name == "006_mustard_bottle" ]; then
        OBJECT_ID="5"
    elif [ $object_name == "009_gelatin_box" ]; then
        OBJECT_ID="8"
    elif [ $object_name == "010_potted_meat_can" ]; then
        OBJECT_ID="9"
    fi

    echo "Converting ground truth to YCB-Video format for object "$object_name
    GT_PATH=./results/gt/$object_name/
    mkdir -p $GT_PATH
    rm -f $GT_PATH/poses_ycb.txt
    python $CONVERSION_TOOL\
           --format gt\
           --obj_id $OBJECT_ID\
           --in_path $YCBV_SYN_PATH/$object_name/gt/poses.txt\
           --out_path $GT_PATH/poses_ycb.txt

    for folder in `ls ./results/ours`; do
        IN_FILE_PATH=./results/ours/$folder/$object_name/pose_estimate.txt
        OUT_FILE_PATH=./results/ours/$folder/$object_name/pose_estimate_ycb.txt
        echo "Processing  "$IN_FILE_PATH
        rm -f $OUT_FILE_PATH
        python $CONVERSION_TOOL\
               --format pred\
               --obj_id $OBJECT_ID\
               --in_path $IN_FILE_PATH\
               --out_path $OUT_FILE_PATH
    done
done