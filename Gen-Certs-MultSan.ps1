# 1. Configurações da Organização (Conforme seu padrão)
$Org = "EMPRESA XXX"
$OU  = "XXX"
$L   = "Cidade"
$S   = "SP"
$C   = "BR"

# 2. Lista de Common Names (CN) - Adicione os nomes aqui
$ListaNomes = @("SERV123", "SERV123")

# 3. Caminho de saída
$OutputPath = "C:\Certificados\CSRs"
if (!(Test-Path $OutputPath)) { New-Item -ItemType Directory -Path $OutputPath | Out-Null }

foreach ($CN_Prefix in $ListaNomes) {
    # Definindo os FQDNs para o CN e para as SANs
    $CN = "${CN_Prefix}.xy123.dominio.net"
    $SAN1 = "${CN_Prefix}.xy123.dominio.net"
    $SAN2 = "${CN_Prefix}.xy123.dominio2.net"

    $InfFile = "$OutputPath\${CN_Prefix}.inf"
    $CsrFile = "$OutputPath\${CN_Prefix}.csr"

    $InfContent = @"
[NewRequest]
Subject = "CN=$CN, OU=$OU, O=$Org, L=$L, S=$S, C=$C"
KeySpec = 1
KeyLength = 2048
Exportable = TRUE
MachineKeySet = TRUE
SMIME = False
PrivateKeyArchive = FALSE
UserProtected = FALSE
UseExistingKeySet = FALSE
ProviderName = "Microsoft Software Key Storage Provider"
ProviderType = 0
RequestType = PKCS10
HashAlgorithm = SHA256

[EnhancedKeyUsageExtension]
OID=1.3.6.1.5.5.7.3.1

[Extensions]
# Adicionando múltiplos nomes no SAN usando o caractere '&' como separador
2.5.29.17 = "{text}dns=$SAN1&dns=$SAN2"
"@

    $InfContent | Out-File -FilePath $InfFile -Encoding ASCII
    
    # Gera o CSR localmente (A chave privada fica no servidor onde rodar este script)
    certreq.exe -new $InfFile $CsrFile
    
    Write-Host "CSR gerado com Sucesso: ${CN_Prefix} (SAN: tbintra e corpintra)" -ForegroundColor Green
}

Write-Host "`nProcesso finalizado. Pressione qualquer tecla para fechar..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")