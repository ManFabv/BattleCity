import os
import subprocess
import sys

def run_linter(code_dir, lint_results, gd_script_toolkit):
    # Crear o sobrescribir el archivo de resultados
    with open(lint_results, "w", encoding="utf-8") as results_file:
        results_file.write("Linter Results:\n")

    # Recorrer recursivamente los archivos .gd en CODE_DIR
    for root, _, files in os.walk(code_dir):
        for file in files:
            if file.endswith(".gd"):
                file_path = os.path.join(root, file)
                print(f"Linting {file_path}...")
                
                # Ejecutar gdlint y capturar salida
                try:
                    process = subprocess.run(
                        [gd_script_toolkit, file_path],
                        stdout=subprocess.PIPE,
                        stderr=subprocess.STDOUT,
                        text=True
                    )
                    # Guardar resultados en el archivo
                    with open(lint_results, "a", encoding="utf-8") as results_file:
                        results_file.write(f"Linting {file_path}:\n")
                        results_file.write(process.stdout)
                        if process.returncode != 0:
                            results_file.write(f"Error while linting {file_path}\n")
                except FileNotFoundError:
                    print(f"Error: {gd_script_toolkit} no encontrado. Verifica la instalación.")
                    return
    print(f"Lint completed. Results saved to {lint_results}")

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Uso: python run_linter.py <CODE_DIR> <LINT_RESULTS> <GD_SCRIPT_TOOLKIT>")
        sys.exit(1)

    code_dir = sys.argv[1]
    lint_results = sys.argv[2]
    gd_script_toolkit = sys.argv[3]
    run_linter(code_dir, lint_results, gd_script_toolkit)

