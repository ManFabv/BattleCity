import re
import json
import os
import sys

def generate_sarif_report(lint_results_file, sarif_output_file, revision_id, branch_name):
    # Mapped severity
    severity_map = {
        "Error": "error",
        "Warning": "warning"
    }

    # Initialize SARIF structure
    sarif = {
        "$schema": "https://json.schemastore.org/sarif-2.1.0.json",
        "version": "2.1.0",
        "runs": [{
            "tool": {
                "driver": {
                    "name": "GDScriptToolkit",
                    "fullName": "Godot GDScript Toolkit Linter",
                    "informationUri": "https://github.com/Scony/godot-gdscript-toolkit",
                    "version": "1.0.0",
                    "semanticVersion": "1.0.0",
                    "rules": []
                }
            },
            "versionControlProvenance": [{
                "repositoryUri": "https://github.com/ManFabv/UNL-Godot-PVJ3-Actividad-5-Final.git",
                "revisionId": revision_id,
                "branch": branch_name
            }],
            "results": [],
            "artifacts": []
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
            rule_id_formatted = f"GDS-{rule_id.replace('_', '-')}"

            rule_ids.add((rule_id_formatted, rule_id))

            # Create SARIF result structure
            result = {
                "ruleId": rule_id_formatted,
                "level": severity_map.get(severity, "note"),
                "message": {
                    "id": rule_id_formatted,
                    "arguments": [message]
                },
                "locations": [{
                    "physicalLocation": {
                        "artifactLocation": {
                            "uri": relative_path.replace("\\", "/"),
                            "uriBaseId": "%SRCROOT%"
                        },
                        "region": {
                            "startLine": int(line_number),
                            "startColumn": 1
                        }
                    }
                }]
            }
            sarif["runs"][0]["results"].append(result)
            sarif["runs"][0]["artifacts"].append({
                "location": {
                    "uri": relative_path.replace("\\", "/"),
                    "uriBaseId": "%SRCROOT%"
                }
            })

    # Add unique rules to the SARIF structure
    for rule_id_formatted, rule_id in rule_ids:
        sarif["runs"][0]["tool"]["driver"]["rules"].append({
            "id": rule_id_formatted,
            "name": rule_id_formatted,
            "shortDescription": {"text": f"Rule {rule_id_formatted}"},
            "helpUri": "https://github.com/Scony/godot-gdscript-toolkit/wiki"
        })

    # Write SARIF file
    with open(sarif_output_file, "w", encoding="utf-8") as json_file:
        json.dump(sarif, json_file, indent=2)

    print(f"SARIF report created: {sarif_output_file}")


if __name__ == "__main__":
    if len(sys.argv) != 5:
        print("Usage: python generate_sarif_report.py <LINT_RESULTS_FILE> <SARIF_OUTPUT_FILE> <REVISION_ID> <BRANCH_NAME>")
        sys.exit(1)

    lint_results_file = sys.argv[1]
    sarif_output_file = sys.argv[2]
    revision_id = sys.argv[3]
    branch_name = sys.argv[4]
    generate_sarif_report(lint_results_file, sarif_output_file, revision_id, branch_name)