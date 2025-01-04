import re
import json
import os
import sys

def generate_sonarqube_issues(lint_results_file, sonarqube_output_file):
    # Mapped severity
    severity_map = {
        "Error": "MAJOR",
        "Warning": "MINOR"
    }

    # Will be filled with issues
    issues = []

    with open(lint_results_file, "r", encoding="utf-8") as file:
        lines = file.readlines()

    # Regex to catch problems
    lint_regex = re.compile(
        r"^(.*?):(\d+):\s+(Error|Warning):\s+(.*)\s+\((.*?)\)$"
    )

    # Parsing
    for line in lines:
        match = lint_regex.match(line.strip())
        if match:
            file_path, line_number, severity, message, rule_id = match.groups()

            relative_path = os.path.relpath(file_path, start=os.getcwd())

            # Create SonarQube structure
            issue = {
                "engineId": "godot-gdscript-toolkit",
                "ruleId": rule_id,
                "severity": severity_map.get(severity, "INFO"),
                "type": "CODE_SMELL",
                "primaryLocation": {
                    "message": message,
                    "filePath": relative_path,
                    "textRange": {
                        "startLine": int(line_number),
                        "startColumn": 1
                    }
                }
            }
            issues.append(issue)

    # Write JSON file
    with open(sonarqube_output_file, "w", encoding="utf-8") as json_file:
        json.dump({"issues": issues}, json_file, indent=4)

    print(f"SonarQube issues file created: {sonarqube_output_file}")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python generate_sonarqube_issues.py <LINT_RESULTS_FILE> <SONARQUBE_OUTPUT_FILE>")
        sys.exit(1)

    lint_results_file = sys.argv[1]
    sonarqube_output_file = sys.argv[2]
    generate_sonarqube_issues(lint_results_file, sonarqube_output_file)
