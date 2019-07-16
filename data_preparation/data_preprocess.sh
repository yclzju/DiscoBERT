#!/usr/bin/env bash

#data_name='dailymail'
data_name='cnn'
data_name='nyt'

home_dir='/datadrive'
home_dir='/scratch/cluster/jcxu'
segs='segs'
tokenized='tokenized'
chunk='chunk'

#/scratch/cluster/jcxu/data/nyt

getsum='/datadrive/GETSum'
getsum='/scratch/cluster/jcxu/GETSum'
neueduseg='/datadrive/NeuralEDUSeg/src'


cd $getsum

PYTHONPATH=./ python3 data_preparation/run_nlpyang_prepo.py -mode split -data_dir "$home_dir/data/$data_name" -rel_split_doc_path raw_doc -rel_split_sum_path sum

sleep 30m
PYTHONPATH=./ python3 data_preparation/run_nlpyang_prepo.py -mode tokenize -data_dir "$home_dir/data/$data_name" -rel_split_doc_path raw_doc -rel_tok_path $tokenized -snlp_path  "$home_dir/stanford-corenlp-full-2018-10-05"


PYTHONPATH=./ python3 data_preparation/run_nlpyang_prepo.py -mode dplp -data_dir "$home_dir/data/$data_name"  -dplp_path "$home_dir/DPLP" -rel_rst_seg_path $segs -rel_tok_path $tokenized


cd $neueduseg
CUDA_VISIBLE_DEVICES=0  python run.py --segment --input_conll_path "$home_dir/data/$data_name/$tokenized"  --output_merge_conll_path "$home_dir/data/$data_name/$segs"  --gpu 0
CUDA_VISIBLE_DEVICES=1  python run.py --segment --input_conll_path "$home_dir/data/$data_name/$tokenized"  --output_merge_conll_path "$home_dir/data/$data_name/$segs"  --gpu 0
CUDA_VISIBLE_DEVICES=2  python run.py --segment --input_conll_path "$home_dir/data/$data_name/$tokenized"  --output_merge_conll_path "$home_dir/data/$data_name/$segs"  --gpu 0
CUDA_VISIBLE_DEVICES=3  python run.py --segment --input_conll_path "$home_dir/data/$data_name/$tokenized"  --output_merge_conll_path "$home_dir/data/$data_name/$segs"  --gpu 0
cd $getsum
# RUN DPLP for RST parse
PYTHONPATH=./  python3 "data_preparation/run_nlpyang_prepo.py" -mode rst -data_dir "$home_dir/data/$data_name"  -dplp_path "$home_dir/DPLP" -rel_rst_seg_path segs

# format to lines

cd $getsum
PYTHONPATH=./  python3 "data_preparation/run_nlpyang_prepo.py" \
-mode format_to_lines -data_dir "$home_dir/data/$data_name"  \
-rel_rst_seg_path $segs -rel_tok_path $tokenized -rel_save_path $chunk -rel_split_sum_path sum -data_name $data_name -map_path "/datadrive/GETSum/data_preparation/urls"

# format to bert

PYTHONPATH=./  python3 "data_preparation/run_nlpyang_prepo.py" \
-mode format_to_bert -data_dir "$home_dir/data/$data_name"  \
-rel_rst_seg_path $segs -rel_tok_path $tokenized -rel_save_path $chunk -rel_split_sum_path sum -data_name $data_name -map_path "/datadrive/GETSum/data_preparation/urls"