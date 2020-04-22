# :dancer:DiscoBERT: Discourse-Aware Neural Extractive Model for Text Summarization
Code repository for an ACL 2020 paper [Discourse-Aware Neural Extractive Model for Text Summarization](https://arxiv.org/abs/1910.14142). 

Authors: [Jiacheng Xu](http://www.cs.utexas.edu/~jcxu/) (University of Texas at Austin), [Zhe Gan](https://zhegan27.github.io), [Yu Cheng](https://sites.google.com/site/chengyu05/home), and [Jingjing Liu](https://www.linkedin.com/in/jingjing-liu-65703431/) (Microsoft Dynamics 365 AI Research).

Contact: jcxu at cs dot utexas dot edu

## Illustration
Click the GIF to see each slide build by build.
<a href="https://github.com/jiacheng-xu/DiscoBERT/tree/release/demo"><img src="http://www.cs.utexas.edu/~jcxu/material/ACL20/gif1.gif" width="600"></a>


## Prerequisites

The code is based on [`AllenNLP` (v0.9)](https://github.com/allenai/allennlp/tree/052353ed62e3a54fd7b39a660e65fc5dd2f91c7d), The code is developed with `python 3`, `allennlp` and `pytorch>=1.0`. For more requierments, please check `requirements.txt`.

## Preprocessed Dataset \& Model Archive
We maintain the preprocessed CNNDM, pre-trained CNNDM model w. discourse graph and coref graph, and pre-trained NYT model w. discourse graph and coref graph are provided in [https://utexas.box.com/v/DiscoBERT-ACL2020](https://utexas.box.com/v/DiscoBERT-ACL2020).  

## Training
The model framework (training, evaluation, etc.) is based on `AllenNLP` (v0.9).
The usage of most framework related hyper-parameters, like batch size, cuda device, num of samples per epoch, can be referred to AllenNLP document.     

Here are some model related hyper-parameters:

| Hyper-parameter        | Value         | Usage |
| :-------------: |:-------------:| :-----|
| `use_disco`      | bool | Using EDU as the selection unit or not. If not use sentence instead. |
| `trigram_block`      | bool | Using trigram blocking or not. |
| `min_pred_unit` & `max_pred_unit`     | int | The minimal and maximal number of units (either EDUs or sentences) to choose during inference. The typical value for selecting EDUs on CNNDM and NYT is [5,8) and [5,8).|
| `use_disco_graph`      | bool | Using discourse graph for graph encoding. |
| `use_coref`      | bool | Using coreference mention graph for graph encoding. |

Comments:
* The hyper-parameters for BERT encoder is almost same as the configuration from [PreSumm](https://github.com/nlpyang/PreSumm/blob/master/src/train.py).
* Inflating the number of units getting predicted for EDU-based models because EDUs are generally shorter than sentences. 
For CNNDM, we found that picking up 5 EDUs yields the best ROUGE F-1 score where for sentence-based model four sentences are picked.
* We hardcoded some of vector dimension size to be 768 because we use `bert-base-uncased` model. 
* We tried `roberta-base` rather than `bert-base-uncased` as we used in this code repo and paper, but empirically it didn't perform better.   
* The maxium document length is set to be 768 BPEs although we found `max_len=768` doesn't bring significant gain from `max_len=512`.

To train or modify a model, there are several files to start with.
* `model/disco_bert.py` is the model file. There are some unused conditions and hyper-parameters starting with "semantic_red" so you should ignore them.
* `configs/DiscoBERT.jsonnet` is the configuration file which will be read by AllenNLP framework. 
In the pre-trained model section of [https://utexas.box.com/v/DiscoBERT-ACL2020](https://utexas.box.com/v/DiscoBERT-ACL2020), we provided the configuration files for reference. 
Basically we adopted most of the hyper-parameters from [PreSumm](https://github.com/nlpyang/PreSumm/blob/master/src/train.py).

## Citing
```
@inproceedings{xu-etal-2020-discourse,
    title = {Discourse-Aware Neural Extractive Model for Text Summarization},
    author = {Xu, Jiacheng and Gan, Zhe and Cheng, Yu and Liu, Jingjing},
    booktitle = "Proceedings of the 58th Annual Meeting of the Association for Computational Linguistics",
    year = {2020},
    publisher = "Association for Computational Linguistics"
}
```

## Acknowledgements
* The data preprocessing (dataset handler, oracle creation, etc.) is partially based on [PreSumm](https://github.com/nlpyang/PreSumm) by Yang Liu and Mirella Lapata.
* Data preprocessing (tokenization, sentence split, coreference resolution etc.) used [CoreNLP](https://stanfordnlp.github.io/CoreNLP/). 
* RST Discourse Segmentation is generated from [NeuEDUSeg](https://github.com/PKU-TANGENT/NeuralEDUSeg). I slightly modified the code to run with GPU. Please check my modification [here](https://github.com/jiacheng-xu/NeuralEDUSeg).
* RST Discourse Parsing is generated from [DPLP](https://github.com/jiyfeng/DPLP). My customized version is [here](https://github.com/jiacheng-xu/DPLP) featuring batch implementation and remaining file detection. 
Empirically I found that `NeuEDUSeg` provided better segmentation output than `DPLP` so we use `NeuEDUSeg` for segmentation and `DPLP` for parsing.  
* The implementation of the graph module is based on [DGL](https://github.com/dmlc/dgl).