#!/bin/bash
cd ../

# User input
echo
echo "* Please type the data-root."
read -r user_input
data_root="${user_input}"

# Execution
nohup python3 base/train-base.py \
  --gpu 0 \
  --data-root ${data_root} \
  --split-root cache/split \
  --out results \
  --dataset cifar100 \
  --lbl-percent 50 \
  --novel-percent 50 \
  --split-id split_1 \
  --ssl-indexes cache/split/cifar100_50_50_split_1.pkl \
  --arch resnet18 \
  >results/stdout-train-base.out

nohup python3 closed_world_ssl/train-mixmatch.py \
  --gpu 0 \
  --data-root ${data_root} \
  --split-root cache/split \
  --out results \
  --dataset cifar100 \
  --lbl-percent 50 \
  --novel-percent 50 \
  --ssl-indexes cache/split/cifar100_50_50_split_1.pkl \
  --arch resnet18 \
  >results/stdout-train-mixmatch.out &

nohup python3 closed_world_ssl/train-uda.py \
  --gpu 1 \
  --data-root ${data_root} \
  --split-root cache/split \
  --out results \
  --dataset cifar100 \
  --lbl-percent 50 \
  --novel-percent 50 \
  --ssl-indexes cache/split/cifar100_50_50_split_1.pkl \
  --arch resnet18 \
  >results/stdout-train-uda.out &
