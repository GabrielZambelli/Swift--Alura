# 🍎 Unit Test - TDD - Mock

Projeto desenvolvido estudo de implementação de teste de unidade e TDD
<br>

## 📖 O que foi abordado neste projeto?

- [x] **XCTest:** Framework de teste de unidade no xcode.
- [x] **Mocks:** objetos que simulam o comportamento de objetos reais
- [x] **Cuckoo:** Framework para facilitar a criação de mocks: https://github.com/Brightify/Cuckoo
- [x] **TDD:** Desenvolvimento orientado a teste  
- [x] **Test Data Builder:** Classe criada para agilizar a criação de cenários de testes

### ⚙️ Instalação do Cuckoo:
---

Pré requisito: Cocoapod instalado!
Documentação cuckoo: https://github.com/Brightify/Cuckoo

- **Step 1:** Abra o Podfile do projeto
- **Step 2:** No Target de tests adicione: **pod "Cuckoo"**
- **Step 3:** Abra o terminal na pasta do projeto 
- **Step 4:** execute o comando: **pod install**

- **Step 5:** Adicione um novo: "Run Script Phase no build pahses do projeto
- **Step 6:** Cole o script abaixo:

```# Define output file. Change "${PROJECT_DIR}/${PROJECT_NAME}Tests" to your test's root source folder, if it's not the default name.
OUTPUT_FILE="${PROJECT_DIR}/${PROJECT_NAME}Tests/GeneratedMocks.swift"
echo "Generated Mocks File = ${OUTPUT_FILE}"

# Define input directory. Change "${PROJECT_DIR}/${PROJECT_NAME}" to your project's root source folder, if it's not the default name.
INPUT_DIR="${PROJECT_DIR}/${PROJECT_NAME}"
echo "Mocks Input Directory = ${INPUT_DIR}"

# Generate mock files, include as many input files as you'd like to create mocks for.
"${PODS_ROOT}/Cuckoo/run" generate --testable "${PROJECT_NAME}" \
--output "${OUTPUT_FILE}" \
***** INSIRA O CÓDIGO AQUI ******

# ... and so forth, the last line should never end with a backslash

# After running once, locate `GeneratedMocks.swift` and drag it into your Xcode test target group.
```

- **Step 6:** Substitua o código indicado no script ***** INSIRA O CÓDIGO AQUI ****** por:
```
"${INPUT_DIR}/CAMINHO_DO_DIRETORIO/NOME_DO_ARQUIVO.swift" \
```
Para cada arquivo que queira gerar um mock deve ser inserido uma linha.

- **Step 7:** Execute um teste para que o cuckoo possa gerar os mocks dos arquivos
- **Step 8:** Copie o arquivo **GeneratedMocks.swift** gerado no caminho abaixo para dentro do projeto mantendo o caminho: 
```
OUTPUT_FILE="${PROJECT_DIR}/${PROJECT_NAME}Tests/GeneratedMocks.swift" 
```

