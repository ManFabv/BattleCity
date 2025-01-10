import json
import sys
import os

def convert_to_lcov(input_file, output_file):
    if not os.path.exists(input_file):
        print(f"Error: El archivo de entrada '{input_file}' no existe.")
        sys.exit(1)

    try:
        with open(input_file, 'r') as f:
            coverage_data = json.load(f)
    except json.JSONDecodeError as e:
        print(f"Error al leer el archivo JSON: {e}")
        sys.exit(1)

    try:
        with open(output_file, 'w') as f:
            for file_path, lines in coverage_data.items():
                f.write(f"TN:\n")  # Test Name (opcional, dejar en blanco)
                f.write(f"SF:{file_path}\n")  # Nombre del archivo fuente
                for line, hits in lines.items():
                    f.write(f"DA:{line},{hits}\n")  # Número de línea, número de ejecuciones
                f.write("end_of_record\n")
        print(f"Archivo LCOV generado exitosamente: {output_file}")
    except Exception as e:
        print(f"Error al escribir el archivo LCOV: {e}")
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Uso: python convert_to_lcov.py <archivo_entrada.json> <archivo_salida.lcov>")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]

    convert_to_lcov(input_file, output_file)