# 🔐 Windows Server Certificate Automation

Este repositório contém scripts em PowerShell projetados para automatizar o ciclo de vida de certificados em ambientes de infraestrutura Windows, com foco em padronização, agilidade e suporte a múltiplos domínios (SAN).

## 📋 Conteúdo

- [Geração de CSR em Lote](#1-geração-de-csr-em-lote-generate-csrps1)
- [Importação de Certificados](#2-importação-de-certificados-import-certsps1)
- [Requisitos Técnicos](#-requisitos-técnicos)

---

## 🛠️ 1. Geração de CSR em Lote (`Generate-CSR.ps1`)

Este script automatiza a criação de arquivos `.inf` e `.csr` utilizando o utilitário nativo `certreq.exe`. Ele foi configurado para utilizar o provedor moderno **KSP (Key Storage Provider)**.

### Características principais:
* **Múltiplas SANs**: Adiciona automaticamente múltiplos domínios a definir no código ao campo *Subject Alternative Name*.
* **Inteligência de Naming**: O script isola o hostname caso seja inserido um FQDN, evitando duplicação de sufixos.
* **Segurança**: Chave RSA de 2048 bits com assinatura SHA-256.
* **Chave Exportável**: Habilita o bit de exportação (`Exportable = TRUE`) para permitir migrações futuras.

### Como usar:
1. Abra o arquivo e edite a variável `$ListaNomes` com os nomes dos servidores.
2. Edite as variáveis `$CN`, `$SAN1` e `$SAN2` com os nomes dos domínios específicos.
3. Execute o script com privilégios de **Administrador**.
4. Envie apenas o arquivo `.csr` gerado para a Autoridade Certificadora (CA).

---

## 📥 2. Importação de Certificados (`Import-Certs.ps1`)

Script para realizar a instalação massiva de arquivos `.crt` no repositório local do Windows.

### Características principais:
* **Feedback de Status**: Exibe no console o *Common Name* do certificado e se a importação teve sucesso ou falha.
* **Prevenção de Erros**: Utiliza blocos `try-catch` para garantir que o script continue rodando mesmo se um arquivo estiver inválido.
* **Auditoria Visual**: A janela do console permanece aberta após o término para conferência dos logs.

### Como usar:
1. Aponte a variável de caminho para a pasta que contém os arquivos `.crt`.
2. Execute o script como **Administrador**.
3. Clique em "Atualizar" no console `certlm.msc` para verificar o "casamento" da chave privada (ícone de chave dourada).

---

## ⚙️ Requisitos Técnicos

* **Sistema Operacional**: Windows Server 2012 ou superior.
* **Provedor**: Microsoft Software Key Storage Provider (KSP).
* **Escopo**: Repositório de Computador Local (`LocalMachine\My`).
* **Permissões**: Administrador local do servidor.

---

## ⚠️ Notas Importantes de Infraestrutura

1. **Localidade da Chave**: O .crt deve ser importado no mesmo servidor onde foi gerado o CSR. A chave privada reside no hardware/software do servidor onde o script de geração foi executado.
2. **Finalização do Pedido**: Ao receber o `.crt`, a instalação no servidor original vincula automaticamente a chave privada à pública.
3. **Caminhos de Rede**: Caso execute o script a partir de drives mapeados ou sessões RDP, certifique-se de que a `ExecutionPolicy` do PowerShell esteja configurada como `Bypass` ou `RemoteSigned`.

---
## ⚖️ Licença

Este projeto está sob a licença [MIT](LICENSE). Veja o arquivo para mais detalhes.
