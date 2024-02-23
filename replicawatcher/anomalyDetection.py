import os
import sys
import json
import pickle
import numpy as np
from utils import preprocess_data, clean_directories, get_valid_filenames, get_valid_cwd, dissimilarity
from constants import ASPECTS
from scipy.spatial.distance import cdist

class AnomalyDetection:
    def __init__(self, folder_path):
        """Initialize the AnomalyDetection system with a folder path."""
        self.folder_path = folder_path
        self.json_files = [f for f in os.listdir(folder_path) if f.endswith('.json')]
        self.num_files_with_anomalies = {}

    def process_file(self, json_file, threshold):
        """Process a single JSON file to detect anomalies based on the given threshold."""
        file_path = os.path.join(self.folder_path, json_file)
        with open(file_path, 'r') as file:
            data = json.load(file)
        data = preprocess_data(data)
        replicas_vectors = self.calculate_replicas_vectors(data)
        return self.detect_anomalies(replicas_vectors, threshold)

    def calculate_replicas_sets(self, data, aspect):
        """Calculate sets of replica data for a given aspect."""
        aspect_function_map = {
            'list_distinct_directories': lambda x: set(clean_directories(x)),
            'list_distinct_filenames': lambda x: set(get_valid_filenames(x)),
            'list_distinct_cwds': lambda x: set(get_valid_cwd(x))
        }
        default_function = lambda x: set(x)
        return [aspect_function_map.get(aspect, default_function)(replica.get(aspect, [])) for replica in data]

    def calculate_replicas_vectors(self, data):
        """Calculate vectors for each replica based on the pre-defined aspects."""
        num_replicas = len(data)
        replicas_vectors = np.zeros((num_replicas, len(ASPECTS)))

        for i, aspect in enumerate(ASPECTS):
            replica_sets = self.calculate_replicas_sets(data, aspect)
            for j, current_set in enumerate(replica_sets):
                other_sets = replica_sets[:j] + replica_sets[j+1:]
                replicas_vectors[j, i] = dissimilarity(current_set, other_sets)

        return replicas_vectors

    def detect_anomalies(self, replicas_vectors, threshold):
        """Detect anomalies in the replicas vectors based on a threshold."""
        centroid = np.zeros((1, replicas_vectors.shape[1]))
        distances = cdist(replicas_vectors, centroid, 'euclidean').flatten()
        return np.any(distances > threshold)

    def run_detection(self):
        """Run the anomaly detection process for all JSON files in the folder."""
        print(f"Number of snapshots: {len(self.json_files)}")
        for threshold in np.arange(0.1, 1.1, 0.1):
            files_with_anomalies = sum(self.process_file(f, threshold) for f in self.json_files)
            self.num_files_with_anomalies[threshold] = files_with_anomalies
            print(f"Threshold {threshold:.1f}: {files_with_anomalies} snapshots with anomalies")