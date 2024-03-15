import sys
import pickle
from anomalyDetection import AnomalyDetection

def save_results(filename, results):
    try:
        with open(filename, 'wb') as file:
            pickle.dump(results, file)
        print("Results successfully saved.")
    except Exception as e:
        print(f"Error saving results: {e}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python replicawatcher.py <folder_path> <output_file>")
        sys.exit(1)

    folder_path = sys.argv[1]
    output_file = sys.argv[2]

    ad = AnomalyDetection(folder_path)
    ad.run_detection()
    save_results(output_file, ad.num_files_with_anomalies)

