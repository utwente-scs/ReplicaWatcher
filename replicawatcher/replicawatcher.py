import sys
import logging
from anomalyDetection import AnomalyDetection

logging.basicConfig(level=logging.INFO, format='%(levelname)s - %(message)s')

def main(folder_snapshots_path):
    try:
        ad = AnomalyDetection(folder_snapshots_path)
        ad.run_detection()
    except Exception as e:
        logging.error(f"An error occurred during anomaly detection: {e}")
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        logging.error("Usage: python replicawatcher.py <folder_snapshots_path>")
        sys.exit(1)

    folder_snapshots_path = sys.argv[1]
    main(folder_snapshots_path)
