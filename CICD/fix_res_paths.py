import sys
import os
import re

def replace_res_paths(input_file, output_file, old_prefix, new_prefix):
    with open(input_file, 'r') as f:
        content = f.read()

    updated_content = re.sub(re.escape(old_prefix), new_prefix, content)

    with open(output_file, 'w') as f:
        f.write(updated_content)
    print(f"File saved in: {output_file}")

if __name__ == "__main__":
    if len(sys.argv) != 5:
        print("Usage: python fix_coverage_path.py <input_file> <output_file> <old_prefix> <new_prefix>")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]
    old_prefix = sys.argv[3]
    new_prefix = sys.argv[4]

    replace_res_paths(input_file, output_file, old_prefix, new_prefix)