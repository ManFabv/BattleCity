import json
import sys
import os

def convert_to_lcov(input_file, output_file):
    if not os.path.exists(input_file):
        print(f"Error: File '{input_file}' not found.")
        sys.exit(1)

    try:
        with open(input_file, 'r') as f:
            coverage_data = json.load(f)
    except json.JSONDecodeError as e:
        print(f"Error reading JSON: {e}")
        sys.exit(1)

    try:
        with open(output_file, 'w') as f:
            for file_path, lines in coverage_data.items():
                f.write(f"TN:\n")  # Test Name
                f.write(f"SF:{file_path}\n")  # File Name
                for line, hits in lines.items():
                    f.write(f"DA:{line},{hits}\n")  # Line number, execution number
                f.write("end_of_record\n")
        print(f"LCOV successfully generated: {output_file}")
    except Exception as e:
        print(f"Error writing LCOV: {e}")
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python convert_to_lcov.py <input.json> <output.lcov>")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]

    convert_to_lcov(input_file, output_file)