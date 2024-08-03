# Effi-MVS+ (TCSVT)
official source code of paper 'Efficient Multi-view Stereo by Dynamic Cost Volume and Cross-scale Propagation'
This work is an extended version of Effi-MVS(CVPR2022)

## Introduction
An efficient framework for high-resolution multi-view stereo. This work aims to improve the accuracy and reduce the consumption at the same time.  If you find this project useful for your research, please cite: 


## Installation
### Requirements
* python 3.8
* CUDA >= 11.1
```
pip install -r requirements.txt
```

## Reproducing Results
* Download pre-processed datasets (provided by PatchmatchNet): [DTU's evaluation set](https://drive.google.com/file/d/1jN8yEQX0a-S22XwUjISM8xSJD39pFLL_/view?usp=sharing), [Tanks & Temples](https://drive.google.com/file/d/1gAfmeoGNEFl9dL4QcAU4kF0BAyTd-r8Z/view?usp=sharing)
```
root_directory
├──scan1 (scene_name1)
├──scan2 (scene_name2) 
      ├── images                 
      │   ├── 00000000.jpg       
      │   ├── 00000001.jpg       
      │   └── ...                
      ├── cams_1                   
      │   ├── 00000000_cam.txt   
      │   ├── 00000001_cam.txt   
      │   └── ...                
      └── pair.txt  
```

Camera file ``cam.txt`` stores the camera parameters, which includes extrinsic, intrinsic, minimum depth and maximum depth:
```
extrinsic
E00 E01 E02 E03
E10 E11 E12 E13
E20 E21 E22 E23
E30 E31 E32 E33

intrinsic
K00 K01 K02
K10 K11 K12
K20 K21 K22

DEPTH_MIN DEPTH_MAX 
```
``pair.txt `` stores the view selection result. For each reference image, 10 best source views are stored in the file:
```
TOTAL_IMAGE_NUM
IMAGE_ID0                       # index of reference image 0 
10 ID0 SCORE0 ID1 SCORE1 ...    # 10 best source images for reference image 0 
IMAGE_ID1                       # index of reference image 1
10 ID0 SCORE0 ID1 SCORE1 ...    # 10 best source images for reference image 1 
...
``` 

* In ``test_dtu.sh`` and ``test_tank.sh``, set `DTU_TESTING`, or `TANK_TESTING` as the root directory of corresponding dataset, set `--OUT_DIR` as the directory to store the reconstructed point clouds, uncomment the evaluation command for corresponding dataset
* `CKPT_FILE` is the checkpoint file (our pretrained model is `checkpoints/Effi_MVS_plus/model_dtu.ckpt` and `checkpoints/model_tank.ckpt`), change it if you want to use your own model. 


* Test on GPU by running `sh test.sh`. The code includes depth map estimation and depth fusion. The outputs are the point clouds in `ply` format. 
* For quantitative evaluation on DTU dataset, download [SampleSet](http://roboimagedata.compute.dtu.dk/?page_id=36) and [Points](http://roboimagedata.compute.dtu.dk/?page_id=36). Unzip them and place `Points` folder in `SampleSet/MVS Data/`. The structure looks like:
```
SampleSet
├──MVS Data
      └──Points
```
In ``evaluations/dtu/BaseEvalMain_web.m``, set `dataPath` as path to `SampleSet/MVS Data/`, `plyPath` as directory that stores the reconstructed point clouds and `resultsPath` as directory to store the evaluation results. Then run ``evaluations/dtu/BaseEvalMain_web.m`` in matlab.



The performance on Tanks & Temples datasets will be better if the model is fine-tuned on BlendedMVS Datasets

* Download the BlendedMVS [dataset](https://1drv.ms/u/s!Ag8Dbz2Aqc81gVDgxb8MDGgoV74S?e=hJKlvV).

* For detailed quantitative results on Tanks & Temples, please check the leaderboards ([Tanks & Temples](https://www.tanksandtemples.org/details/1170/))

* In ``train.sh``, set `MVS_TRAINING` or `BLEND_TRAINING` as the root directory of dataset; set `--logdir` as the directory to store the checkpoints. 
* Train the model by running `sh train.sh`.

DTU Training dataset:  
Download the preprocessed [DTU training data](https://drive.google.com/file/d/1eDjh-_bxKKnEuz5h-HXS7EDJn59clx6V/view)
 and [Depths_raw](https://virutalbuy-public.oss-cn-hangzhou.aliyuncs.com/share/cascade-stereo/CasMVSNet/dtu_data/dtu_train_hr/Depths_raw.zip) 
 (both from [Original MVSNet](https://github.com/YoYo000/MVSNet)), and upzip it as the $MVS_TRANING  folder.

Thanks to Yao Yao for opening source of his excellent work [MVSNet](https://github.com/YoYo000/MVSNet). Thanks to Xiaoyang Guo for opening source of his PyTorch implementation of MVSNet [MVSNet-pytorch](https://github.com/xy-guo/MVSNet_pytorch). Thanks to Zachary Teed for his excellent work RAFT, which inspired us to this work. 

