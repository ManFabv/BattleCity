import re
import json
import os
import sys

def generate_sarif_report(lint_results_file, sarif_output_file):
    # Mapped severity
    severity_map = {
        "Error": "error",
        "Warning": "warning"
    }

    # Initialize SARIF structure
    sarif = {
        "version": "2.1.0",
        "runs": [{
            "tool": {
                "driver": {
                    "name": "godot-gdscript-toolkit",
                    "informationUri": "https://github.com/Scony/godot-gdscript-toolkit",
                    "rules": []
                }
            },
            "results": []
        }]
    }

    with open(lint_results_file, "r", encoding="utf-8") as file:
        lines = file.readlines()

    # Regex to catch problems
    lint_regex = re.compile(
        r"^(.*?):(\d+):\s+(Error|Warning):\s+(.*)\s+\((.*?)\)$"
    )

    rule_ids = set()

    # Parsing
    for line in lines:
        match = lint_regex.match(line.strip())
        if match:
            file_path, line_number, severity, message, rule_id = match.groups()

            relative_path = os.path.relpath(file_path, start=os.getcwd())
            rule_ids.add(rule_id)

            # Create SARIF result structure
            result = {
                "ruleId": rule_id,
                "level": severity_map.get(severity, "note"),
                "message": {"text": message},
                "locations": [{
                    "physicalLocation": {
                        "artifactLocation": {"uri": relative_path.replace("\\", "/")},
                        "region": {
                            "startLine": int(line_number),
                            "startColumn": 1
                        }
                    }
                }]
            }
            sarif["runs"][0]["results"].append(result)

    # Add unique rules to the SARIF structure
    for rule_id in rule_ids:
        sarif["runs"][0]["tool"]["driver"]["rules"].append({
            "id": rule_id,
            "name": rule_id,
            "shortDescription": {"text": f"Rule {rule_id}"}
        })

    # Write SARIF file
    with open(sarif_output_file, "w", encoding="utf-8") as json_file:
        json.dump(sarif, json_file, indent=2)

    print(f"SARIF report created: {sarif_output_file}")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python generate_sarif_report.py <LINT_RESULTS_FILE> <SARIF_OUTPUT_FILE>")
        sys.exit(1)

    lint_results_file = sys.argv[1]
    sarif_output_file = sys.argv[2]
    generate_sarif_report(lint_results_file, sarif_output_file)
