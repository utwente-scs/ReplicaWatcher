import os
import json
import numpy as np
from scipy.spatial.distance import cdist
from constants import ASPECTS
import re

# Precompile regex for efficiency
hexadecimal_regex = re.compile(r'[a-fA-F0-9]+')

def jaccard_similarity(set1, set2):
    intersection = set1.intersection(set2)
    union = set1.union(set2)
    return len(intersection) / len(union)

def dissimilarity(current_replica_set, other_replica_sets):
    if not current_replica_set:
        return 0
    similarity_scores = [jaccard_similarity(current_replica_set, s) for s in other_replica_sets]
    avg_similarity_score = sum(similarity_scores) / len(similarity_scores)
    return 1 - avg_similarity_score

def clean_directories(replica_directories):
    return ['/'.join(directory.split('/')[:4]) if len(directory.split('/')) > 4 else directory for directory in replica_directories]

def get_valid_filenames(replicas_filenames):
    return [filename for filename in replicas_filenames if is_valid_filename(filename)]

def seems_random(file_name):
    app_prefixes = ['php', 'java', 'app', 'tmp', 'wgunicorn']
    return any(file_name.startswith(prefix) for prefix in app_prefixes) or (any(char.isupper() for char in file_name) and any(char.islower() for char in file_name))

def is_valid_filename(filename):
    basename, extension = os.path.splitext(filename)
    if 'random' in extension or 'cache' in extension:
        return False
    return not seems_random(basename) if not extension else True

def get_valid_cwd(cwds):
    return [reconstruct_path(split_path(cwd)) for cwd in cwds if cwd]

def split_path(path):
    return path.strip("/").split("/")

def is_random_component(component):
    # Check if the string is a valid hexadecimal (commonly used for container IDs)
    return bool(re.fullmatch(r'[a-fA-F0-9]+', component))


def reconstruct_path(components):
    valid_components = [component for component in components if not is_random_component(component)]
    valid_path = os.path.join(*valid_components) 
    return valid_path


def remove_numbers_from_string(input_string):
    return ''.join([i for i in input_string if not i.isdigit()])

def preprocess_data(data):
    aspects = set(["list_distinct_directories", "list_distinct_filenames", "list_distinct_procs", "list_distinct_commands", "list_distinct_args", "list_distinct_exe"])
    for replica in data:
        for key in aspects.intersection(replica.keys()):
            replica[key] = list({remove_numbers_from_string(value) for value in replica[key]})
    return data