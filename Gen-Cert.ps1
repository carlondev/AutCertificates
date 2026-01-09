# 1. Configurações da Organização (Conforme seu padrão)
$Org = "EMPRESA XXX"
$OU  = "XXX"
$L   = "Cidade"
$S   = "SP"
$C   = "BR"

# 2. Lista de Common Names (CN) - Adicione os nomes aqui
$ListaNomes = @("SERV123", "SERV123")

# 3. Pasta de saída
$OutputPath = "C:\Certificados\CSRs"
if (!(Test-Path $OutputPath)) { New-Item -ItemType Directory -Path $OutputPath | Out-Null }

try {
    foreach ($CN in $ListaNomes) {
        $InfFile = "$OutputPath\$CN.inf"
        $CsrFile = "$OutputPath\$CN.csr"

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
2.5.29.17 = "{text}dns=$CN"
"@

        $InfContent | Out-File -FilePath $InfFile -Encoding ASCII
        
        # Gera o CSR
        certreq.exe -new $InfFile $CsrFile
        
        # LINHA CORRIGIDA ABAIXO
        Write-Host "CSR gerado para ${CN}: [ SUCESSO ]" -ForegroundColor Green
    }
}
catch {
    Write-Host "Ocorreu um erro fatal: $($_.Exception.Message)" -ForegroundColor Red
}
finally {
    Write-Host "`nProcesso finalizado." -ForegroundColor Cyan
    Write-Host "Pressione qualquer tecla para fechar..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}