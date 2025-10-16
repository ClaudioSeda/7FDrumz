# sanitize.py
import os
import re
import unicodedata

def sanitize_filename(filename: str) -> str:
    """
    Sanitiza o nome de um arquivo, preservando sua extensão.
    Converte caracteres acentuados para seus equivalentes sem acento
    e remove espaços e outros caracteres inválidos, substituindo-os
    por um único underscore.
    """
    # 1. Separar o nome da extensão
    name_part, extension = os.path.splitext(filename)

    # 2. Normalização Unicode: remove acentos
    nfkd_form = unicodedata.normalize('NFKD', name_part)
    ascii_name = "".join([c for c in nfkd_form if not unicodedata.combining(c)])

    # 3. Sanitizar apenas o nome base, agora sem acentos
    sanitized_name = re.sub(r'[^a-zA-Z0-9_]+', '_', ascii_name)
    sanitized_name = sanitized_name.strip('_')

    # 4. Juntar o nome sanitizado com a extensão original
    if sanitized_name:
        return f"{sanitized_name}{extension}"
    else:
        return f"arquivo_sem_nome{extension}"

# --- INÍCIO DO PROCESSAMENTO EM LOTE ---
if __name__ == "__main__":
    print("--- Iniciando Processamento de Arquivos .wav ---")
    
    # Pega o diretório atual onde o script está sendo executado
    current_dir = os.getcwd()
    print(f"Processando arquivos na pasta: {current_dir}\n")

    # Lista todos os arquivos e pastas no diretório atual
    all_items = os.listdir(current_dir)
    
    wav_files_found = False

    # PRIMEIRA ETAPA: Sanitização dos arquivos
    for item_name in all_items:
        original_path = os.path.join(current_dir, item_name)

        if os.path.isfile(original_path) and item_name.lower().endswith('.wav'):
            wav_files_found = True
            new_name = sanitize_filename(item_name)
            new_path = os.path.join(current_dir, new_name)

            if original_path != new_path:
                if os.path.exists(new_path):
                    print(f"[AVISO] Pulando '{item_name}' porque o novo nome '{new_name}' já existe.")
                else:
                    try:
                        os.rename(original_path, new_path)
                        print(f"[SUCESSO] '{item_name}'  ->  '{new_name}'")
                    except OSError as e:
                        print(f"[ERRO] Não foi possível renomear '{item_name}': {e}")
            else:
                print(f"[IGNORADO] '{item_name}' (nome já está válido)")

    if not wav_files_found:
        print("Nenhum arquivo .wav encontrado nesta pasta.")
        print("\n--- Processamento Concluído ---")
    else:
        # SEGUNDA ETAPA: Adicionar sufixo do kit
        print("\n--- Adicionando Sufixo do Kit ---")
        
        # Solicitar número do kit ao usuário
        while True:
            kit_number_str = input("Digite o numero do kit: ")
            try:
                kit_number = int(kit_number_str)
                if kit_number > 0:
                    break
                else:
                    print("Por favor, digite um número inteiro maior que 0.")
            except ValueError:
                print("Entrada inválida. Por favor, digite um número inteiro.")
        
        formatted_kit_number = f"kit{kit_number:03d}"  # Formata como kit001, kit002, etc.
        
        # Listar arquivos .wav novamente (após sanitização)
        wav_files = []
        for item in os.listdir(current_dir):
            if item.lower().endswith('.wav'):
                wav_files.append(item)
        
        if not wav_files:
            print("Nenhum arquivo .wav encontrado para adicionar sufixo do kit.")
        else:
            for filename in wav_files:
                # Verificar se já contém "_kit" para evitar duplicação
                if "_kit" in filename:
                    print(f"[IGNORADO] '{filename}' (já contém '_kit')")
                    continue
                
                base_name, extension = os.path.splitext(filename)
                new_filename = f"{base_name}_{formatted_kit_number}{extension}"
                new_path = os.path.join(current_dir, new_filename)
                
                # Verificar se o novo nome já existe
                if os.path.exists(new_path):
                    print(f"[AVISO] Pulando '{filename}' porque o novo nome já existe.")
                else:
                    try:
                        os.rename(os.path.join(current_dir, filename), new_path)
                        print(f"[SUCESSO] '{filename}'  ->  '{new_filename}'")
                    except OSError as e:
                        print(f"[ERRO] Não foi possível renomear '{filename}': {e}")
        
        print("\n--- Processamento Concluído ---")
