from __future__ import print_function
from __future__ import division
from __future__ import unicode_literals

import numpy as np
import deepchem as dc
from deepchem.molnet import load_delaney
from deepchem.models import GraphConvModel
import tensorflow as tf
# import time

print ("all environments loaded")

##input malaria file
delaney_tasks = ['Desired_property']
featurizer = dc.feat.ConvMolFeaturizer()

input_dataset = "/Users/KHatti001/OneDrive - University of Dundee/project1_data/Series4_firstSet_trimmed_subset.csv"

loader = dc.data.CSVLoader(tasks=delaney_tasks, smiles_field="smiles", featurizer=featurizer)

dataset = loader.featurize(input_dataset, shard_size=8192)

# Initialize transformers
transformers = [
  dc.trans.NormalizationTransformer(
      transform_y=True, dataset=dataset)
]

print("About to transform data")

for transformer in transformers:
    dataset = transformer.transform(dataset)

# splitters = {
#   'index': dc.splits.IndexSplitter(),
#   'random': dc.splits.RandomSplitter(),
#   'scaffold': dc.splits.ScaffoldSplitter()
# }
splitter = dc.splits.ScaffoldSplitter()
train_dataset, valid_dataset, test_dataset = splitter.train_valid_test_split(dataset)

train_dataset.load_metadata
print("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")

# Load Delaney dataset
# delaney_tasks, delaney_datasets, transformers = load_delaney(
#     featurizer='GraphConv', split='index')
# train_dataset, valid_dataset, test_dataset = dataset

# Fit models
metric = dc.metrics.Metric(dc.metrics.pearson_r2_score, np.mean)

# Do setup required for tf/keras models
# Number of features on conv-mols
n_feat = 250
# Batch size of models
batch_size = 128
model = GraphConvModel(
    len(delaney_tasks), batch_size=batch_size, mode='regression')

print("this is the end of the output")
