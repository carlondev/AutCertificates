# 1. Insira o caminho completo da pasta em que se encontram os arquivos .crt
cd "C\Pasta\Certificados\Exemplo"

# 2. Processa os arquivos e gera o status da execução
Write-Host "`nProcessando importação...`n" -ForegroundColor Cyan

Get-ChildItem -Filter *.crt | ForEach-Object {
    try {
        # Tenta importar o certificado em Máquina Local > Personal
        $cert = Import-Certificate -FilePath $_.FullName -CertStoreLocation Cert:\LocalMachine\My -ErrorAction Stop
        
        # Extrai o Common Name (CN) do Subject
        $commonName = ($cert.Subject -split "CN=")[1] -split "," | Select-Object -First 1
        
        Write-Host "Certificado: $commonName " -NoNewline
        Write-Host "[ SUCESSO ]" -ForegroundColor Green
    }
    catch {
        Write-Host "Certificado: $($_.Name) " -NoNewline
        Write-Host "[ FALHA ]" -ForegroundColor Red
    }
}

Write-Host "`nProcesso concluído." -ForegroundColor Cyan

# 3. Mantém a janela aberta até que você pressione uma tecla
Write-Host "`nPressione qualquer tecla para fechar esta janela..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")