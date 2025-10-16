void setup() {
  Serial.begin(115200);
  
  // Dá um tempo para o Serial Monitor abrir
  delay(1000); 
  
  Serial.println("=== Relatório de Memória do ESP32 ===");
  Serial.println();

  // --- 1. Memória Flash ---
  Serial.println("--- Memória Flash ---");
  // Pega o tamanho do chip Flash em bytes
  uint32_t flashSize = ESP.getFlashChipSize();
  Serial.print("Tamanho Total: ");
  Serial.print(flashSize / 1024.0 / 1024.0); // Converte para MB
  Serial.println(" MB");
  Serial.println();

  // --- 2. Memória RAM Interna (Heap) ---
  // Esta é a memória principal do chip, não a PSRAM.
  Serial.println("--- Memória RAM Interna (Heap) ---");
  Serial.print("Total Disponível: ");
  Serial.print(ESP.getHeapSize() / 1024.0);
  Serial.println(" KB");
  Serial.print("Livre no Início: ");
  Serial.print(ESP.getFreeHeap() / 1024.0);
  Serial.println(" KB");
  Serial.println();

  // --- 3. Memória PSRAM (seu código original, com melhorias) ---
  Serial.println("--- Memória PSRAM ---");
  
  // A função principal que verifica se a PSRAM está disponível
  if (psramFound()) {
    Serial.println("PSRAM encontrada! :D");
    
    // Mostra o tamanho total da PSRAM
    uint32_t psramSize = ESP.getPsramSize();
    Serial.print("Tamanho Total: ");
    Serial.print(psramSize / 1024.0 / 1024.0); // Converte para MB
    Serial.println(" MB");

    // Mostra quanto de PSRAM está livre no início
    Serial.print("Livre no Início: ");
    Serial.print(ESP.getFreePsram() / 1024.0);
    Serial.println(" KB");
    
    // Testa se consegue alocar memória
    Serial.print("Testando alocação de 100KB na PSRAM... ");
    void* testAlloc = ps_malloc(100000); // Aloca ~100KB na PSRAM
    if (testAlloc) {
      Serial.println("SUCESSO!");
      // Mostra a memória livre após a alocação
      Serial.print("Livre após alocação: ");
      Serial.print(ESP.getFreePsram() / 1024.0);
      Serial.println(" KB");
      free(testAlloc); // Libera a memória alocada para o teste
    } else {
      Serial.println("FALHA!");
    }
    
  } else {
    Serial.println("Nenhuma PSRAM detectada. :(");
  }

  Serial.println("\n=== Fim do Relatório ===");
}

void loop() {
  // Nada aqui, o relatório é rodado apenas uma vez.
}