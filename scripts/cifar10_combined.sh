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
  --dataset cifar10 \
  --lbl-percent 50 \
  --novel-percent 50 \
  --split-id split_1 \
  --ssl-indexes cache/split/cifar10_50_50_split_1.pkl \
  --arch resnet18 \
  >results/cifar10-train-base.out

nohup python3 closed_world_ssl/train-mixmatch.py \
  --gpu 0 \
  --data-root ${data_root} \
  --split-root cache/split \
  --out results \
  --dataset cifar10 \
  --lbl-percent 50 \
  --novel-percent 50 \
  --ssl-indexes cache/split/cifar10_50_50_split_1.pkl \
  --arch resnet18 \
  >results/cifar10-train-mixmatch.out &

nohup python3 closed_world_ssl/train-uda.py \
  --gpu 2 \
  --data-root ${data_root} \
  --split-root cache/split \
  --out results \
  --dataset cifar10 \
  --lbl-percent 50 \
  --novel-percent 50 \
  --ssl-indexes cache/split/cifar10_50_50_split_1.pkl \
  --arch resnet18 \
  >results/cifar10-train-uda.out &
