Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ------------------------------
# Form principal
# ------------------------------
$form = New-Object System.Windows.Forms.Form
$form.Text = "Endpoint Radar"
$form.Size = New-Object System.Drawing.Size(1000,650)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(30,30,30)

# ------------------------------
# Painel lateral para botões
# ------------------------------
$panelButtons = New-Object System.Windows.Forms.Panel
$panelButtons.Location = New-Object System.Drawing.Point(10,10)
$panelButtons.Size = New-Object System.Drawing.Size(180,590)
$panelButtons.BorderStyle = 'FixedSingle'
$panelButtons.BackColor = [System.Drawing.Color]::FromArgb(45,45,48)
$form.Controls.Add($panelButtons)

# ------------------------------
# Painel principal para output
# ------------------------------
$panelMain = New-Object System.Windows.Forms.Panel
$panelMain.Location = New-Object System.Drawing.Point(200,10)
$panelMain.Size = New-Object System.Drawing.Size(780,590)
$panelMain.BorderStyle = 'FixedSingle'
$panelMain.BackColor = [System.Drawing.Color]::FromArgb(37,37,38)
$form.Controls.Add($panelMain)

# ------------------------------
# Labels e TextBox de entrada (Máquina / Usuário)
# ------------------------------
$lblMachine = New-Object System.Windows.Forms.Label
$lblMachine.Text = "Máquina:"
$lblMachine.Location = New-Object System.Drawing.Point(10,10)
$lblMachine.Size = New-Object System.Drawing.Size(60,20)
$lblMachine.ForeColor = [System.Drawing.Color]::White
$panelMain.Controls.Add($lblMachine)

$txtMachine = New-Object System.Windows.Forms.TextBox
$txtMachine.Location = New-Object System.Drawing.Point(80,10)
$txtMachine.Size = New-Object System.Drawing.Size(200,20)
$txtMachine.BackColor = [System.Drawing.Color]::FromArgb(50,50,50)
$txtMachine.ForeColor = [System.Drawing.Color]::White
$panelMain.Controls.Add($txtMachine)

$lblUser = New-Object System.Windows.Forms.Label
$lblUser.Text = "Utilizador:"
$lblUser.Location = New-Object System.Drawing.Point(300,10)
$lblUser.Size = New-Object System.Drawing.Size(80,20) # menor, para ficar perto da textbox
$lblUser.ForeColor = [System.Drawing.Color]::White
$panelMain.Controls.Add($lblUser)

$txtUser = New-Object System.Windows.Forms.TextBox
$txtUser.Location = New-Object System.Drawing.Point(390,10) # próximo da label
$txtUser.Size = New-Object System.Drawing.Size(150,20)
$txtUser.BackColor = [System.Drawing.Color]::FromArgb(30,30,30) # fundo escuro mas sem “retângulo”
$txtUser.ForeColor = [System.Drawing.Color]::White
$panelMain.Controls.Add($txtUser)

# Label com lupa ASCII
$lblLupaASCII = New-Object System.Windows.Forms.Label
$lblLupaASCII.Font = New-Object System.Drawing.Font("Consolas",10,[System.Drawing.FontStyle]::Bold)
$lblLupaASCII.ForeColor = [System.Drawing.Color]::White
$lblLupaASCII.BackColor = [System.Drawing.Color]::FromArgb(50,50,50)
$lblLupaASCII.AutoSize = $true
$lblLupaASCII.Text = "O)`r`n |"
$lblLupaASCII.Location = New-Object System.Drawing.Point(570,1)
$panelMain.Controls.Add($lblLupaASCII)

# Clique na lupa
$lblLupaASCII.Add_Click({
    # Criar form modal de info
    $infoForm = New-Object System.Windows.Forms.Form
    $infoForm.Size = New-Object System.Drawing.Size(400,120)
    $infoForm.StartPosition = "CenterParent"
    $infoForm.FormBorderStyle = 'FixedDialog'
    $infoForm.BackColor = [System.Drawing.Color]::FromArgb(50,50,50)
    $infoForm.ForeColor = [System.Drawing.Color]::White
    $infoForm.Text = "Informação"

    # Label com mensagem
    $lblInfo = New-Object System.Windows.Forms.Label
    $lblInfo.Text = "Este script foi criado e desenvolvido por `r `n Vinícius Pimentel."
    $lblInfo.Font = New-Object System.Drawing.Font("Consolas",10)
    $lblInfo.ForeColor = [System.Drawing.Color]::White
    $lblInfo.BackColor = [System.Drawing.Color]::FromArgb(50,50,50)
    $lblInfo.AutoSize = $false
    $lblInfo.TextAlign = "MiddleCenter"
    $lblInfo.Dock = "Fill"
    $infoForm.Controls.Add($lblInfo)

    # Botão OK
    $btnOk = New-Object System.Windows.Forms.Button
    $btnOk.Text = "OK"
    $btnOk.Size = New-Object System.Drawing.Size(80,25)
    $btnOk.Location = New-Object System.Drawing.Point(($infoForm.ClientSize.Width - $btnOk.Width)/2, 70)
    $btnOk.BackColor = [System.Drawing.Color]::FromArgb(70,70,70)
    $btnOk.ForeColor = [System.Drawing.Color]::White
    $btnOk.Add_Click({ $infoForm.Close() })
    $infoForm.Controls.Add($btnOk)

    # Mostrar modal
    $infoForm.ShowDialog($form)
})

# ------------------------------
# TextBox de saída
# ------------------------------
$txtOutput = New-Object System.Windows.Forms.RichTextBox
$txtOutput.Location = New-Object System.Drawing.Point(10,40)
$txtOutput.Size = New-Object System.Drawing.Size(760,540)
$txtOutput.Multiline = $true
$txtOutput.ScrollBars = "Both"           # <--- barras vertical e horizontal
$txtOutput.WordWrap = $false             # <--- impede quebra automática de linhas
$txtOutput.Font = New-Object System.Drawing.Font("Consolas",10)
$txtOutput.BackColor = [System.Drawing.Color]::FromArgb(20,20,20)
$txtOutput.ForeColor = [System.Drawing.Color]::Lime
$txtOutput.ReadOnly = $true
$panelMain.Controls.Add($txtOutput)

# ------------------------------
# Funções de output
# ------------------------------
function Write-OutputBox {
    param($text)

    $color = [System.Drawing.Color]::Lime

    if ($text -match "PROIBIDO") {
        $color = [System.Drawing.Color]::Red
    }
    elseif ($text -match "Desconhecido") {
        $color = [System.Drawing.Color]::Yellow
    }

    $txtOutput.SelectionStart = $txtOutput.TextLength
    $txtOutput.SelectionLength = 0
    $txtOutput.SelectionColor = $color
    $txtOutput.AppendText($text + "`r`n")
    $txtOutput.SelectionColor = $txtOutput.ForeColor
}
function Clear-Output { $txtOutput.Clear() }

function Fix-Text($text, $max) {

    $text = "$text"

    if (-not $text) { return "".PadRight($max) }

    if ($text.Length -gt $max) {
        return ($text.Substring(0,$max-3) + "...")
    }

    return $text.PadRight($max)
}

# ------------------------------
# Botões com layout Cyber Sleuth
# ------------------------------
$buttons = @("Apps da Máquina","AppData / User","Processos","Verificar Extensões")
$y = 10

foreach ($btnName in $buttons) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $btnName
    $btn.Size = New-Object System.Drawing.Size(160,40)
    $btn.Location = New-Object System.Drawing.Point(10,$y)
    $btn.FlatStyle = 'Flat'
    $btn.BackColor = [System.Drawing.Color]::FromArgb(63,63,70)
    $btn.ForeColor = [System.Drawing.Color]::White
    $btn.Cursor = [System.Windows.Forms.Cursors]::Hand
    $btn.FlatAppearance.BorderSize = 0
    $panelButtons.Controls.Add($btn)
    $y += 50

    switch ($btnName) {
    "Processos" {
    $btn.Add_Click({
        Clear-Output

        $computerName = $txtMachine.Text
        if ([string]::IsNullOrWhiteSpace($computerName)) { $computerName = $env:COMPUTERNAME }

        Write-OutputBox ""
        Write-OutputBox "=== PROCESSOS REMOTOS ==="
        Write-OutputBox ""

        # Testa conexão
        if (!(Test-Connection -ComputerName $computerName -Count 1 -Quiet)) {
            Write-OutputBox "❌ Não é possível contactar $computerName. Verifique conectividade ou DNS."
            return
        }

        try {
            $processes = Invoke-Command -ComputerName $computerName -ScriptBlock {
                Get-Process -IncludeUserName | Where-Object { $_.Path -ne $null } | ForEach-Object {
                    $Proc = $_
                    $SuspiciousPath = $false
                    if ($Proc.Path -match "AppData" -or $Proc.Path -match "Temp" -or $Proc.Path -match "Users\\Public") {
                        $SuspiciousPath = $true
                    }

                    [PSCustomObject]@{
                        UserName    = $Proc.UserName
                        ProcessName = $Proc.Name
                        Suspicious  = $SuspiciousPath
                        Path        = $Proc.Path
                        Id          = $Proc.Id
                        Company     = $Proc.Company
                        StartTime   = $Proc.StartTime
                    }
                } | Sort-Object UserName, Suspicious -Descending
            }

            # Header
            $header = "{0,-25} {1,-40} {2,-10} {3,-25} {4,-8} {5,-20}" -f `
                "ProcessName","Path","Suspicious","UserName","Id","StartTime"
            Write-OutputBox $header
            Write-OutputBox ("-" * 130)

            # Conteúdo
            foreach ($p in $processes) {
                $linha = "{0,-25} {1,-40} {2,-10} {3,-25} {4,-8} {5,-20}" -f `
                    (Fix-Text $p.ProcessName 25),
                    (Fix-Text $p.Path 40),
                    (Fix-Text $p.Suspicious 10),
                    (Fix-Text $p.UserName 25),
                    (Fix-Text $p.Id 8),
                    (Fix-Text ($p.StartTime.ToString("yyyy-MM-dd HH:mm")) 20)

                Write-OutputBox $linha
            }

            Write-OutputBox ""
            Write-OutputBox "[+] Análise concluída em $computerName."

        } catch {
            Write-OutputBox "Erro: $($_.Exception.Message)"
        }
    })
}

        "Verificar Extensões" {
            $btn.Add_Click({
                Clear-Output
                $machine = $txtMachine.Text
                if ([string]::IsNullOrWhiteSpace($machine)) { $machine = $env:COMPUTERNAME }
                $user = $txtUser.Text
                if ([string]::IsNullOrWhiteSpace($user)) {
                    [System.Windows.Forms.MessageBox]::Show("Por favor, insira o usuário para verificar extensões.","Aviso",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Warning)
                    return
                }

                if ($machine -eq $env:COMPUTERNAME) {
                    $basePath = "C:\Users\$user\AppData\Local\Google\Chrome\User Data\Default\Extensions"
                } else {
                    $basePath = "\\$machine\C$\Users\$user\AppData\Local\Google\Chrome\User Data\Default\Extensions"
                }

                if (!(Test-Path $basePath)) {
                    Write-OutputBox "❌ Caminho não encontrado em $machine. Verifique os dados."
                    return
                }

                $knownExtensions = @{
                    "ghbmnnjooekpmoecnnnilnnbdlolhkhi" = "Google Docs Offline"
                    "pjkljhegncpnkpknbcohdijeoejaedia" = "Google Mail"
                    "apdfllckaahabafndbhieahigkjlhalf" = "Google Drive"
                    "aohghmighlieiainnegkcijnfilokake" = "Google Docs"
                    "felcaaldnbdncclmgdcncolpebgiejap" = "Google Sheets"
                    "aapocclcgogkmnckokdopfmhonfmgoek" = "Google Slides"
                    "blpcfgokakmgnkcojhhkbfbldkacnbeo" = "YouTube"
                    "nmmhkkegccagdldgiimedpiccmgmieda" = "Antigo Google Wallet"
                    "maafgiompdekodanheihhgilkjchcakm" = "S-MIME"
                    "efaidnbmnnnibpcajpcglclefindmkaJ" = "Adobe Acrobat PDF Edit"
                    "jlhmfgmfgeifomenelglieieghnjghma" = "Webex Extension"
                    "aleggpabliehgbeagmfhnodcijcmbonb" = "Dr Web Link Checker"
                    "efbjojhplkelaegfbieplglfidafgoka" = "VTchromizer"
                    "gcbommkclmclpchllfjekcdonpmejbdp" = "HTTPS Everywhere"
                    "jeoacafpbcihiomhlakheieifhpjdfeo" = "Disconnect"
                    "pkehgijcmpdhfbdbbnkijodmdjhbjlgp" = "Privacy Badger"
                    "mlomiejdfkolichcflejclcbmpeaniij" = "Ghostery"
                    "cjpalhdlnbpafiamejdnhcphjbkeiagm" = "uBlock Origin"
                    "epcnnfbjfcgphgdmggkamkmgojdagdnn" = "uBlock"
                    "cfhdojbkjhnklbpkdaibdccddilifddb" = "AdBlock Plus"
                    "gighmmpiobklfepjocnamgkkbiglidom" = "AdBlock"
                    "ndmegdjihnhfmljjoaiimbipfhodnbgf" = "UiPath Studio"
                    "mhjfbmdgcfjbbpaeojofohoefgiehjai" = "Chrome PDF Viewer"
                    "pkedcjkdefgpdelpbcmbmeomcjbeemfm" = "Chrome Cast"
                    "ienfalfjdbdpebioblfackkekamfmbnh" = "Angular Dev Tools (PROIBIDO)"
                    "nngceckbapebfimnlniiiahkandclblb" = "BitWarden (PROIBIDO)"
                    "fonalplhodhnenmokepaijoemaednpjm" = "Directo - Ofertas de Viagem (PROIBIDO)"
                    "neebplgakaahbhdphmkckjjcegoiijjo" = "Keepa - Amazon Price Tracker (PROIBIDO)"
                    "lmjnegcaeklhafolokijcfjliaokphfk" = "Video DownloadHelper (PROIBIDO)"                   
                    "mciiogijehkdemklbdcbfkefimifhecn" = "Chrono Download Manager (PROIBIDO)"
                    "cldmemdnllncchfahbcnjijheaolemfk" = "Foxified Manager (PROIBIDO)"
                    "pcjlckhhhmlefmobnnoolakplfppdchi" = "AD SpeedUp (PROIBIDO)"
                    "fjoaledfpmneenckfbpdfhkmimnjocfa" = "NordVPN (PROIBIDO)"
                    "ghnomdcacenbmilgjigehppbamfndblo" = "Camelcamelcamel (PROIBIDO)"
                    "kgmeffmlnkfnjpgmdndccklfigfhajen" = "Emoji keyboard online (PROIBIDO)"
                    "dpdibkjjgbaadnnjhkmmnenkmbnhpobj" = "Free Weather Forecast (PROIBIDO)"
                    "gaiceihehajjahakcglkhmdbbdclbnlf" = "Video Speed Controller (PROIBIDO)"
                    "mlgbkfnjdmaoldgagamcnommbbnhfnhf" = "Unlock Discord VPN (PROIBIDO)"
                    "eckokfcjbjbgjifpcbdmengnabecdakp" = "Dark Theme (PROIBIDO)"
                    "mgbhdehiapbjamfgekfpebmhmnmcmemg" = "Volume Max (PROIBIDO)"
                    "cbajickflblmpjodnjoldpiicfmecmif" = "Unblock TikTok VPN (PROIBIDO)"
                    "pdbfcnhlobhoahcamoefbfodpmklgmjm" = "Unlock YouTube VPN (PROIBIDO)"
                    "eokjikchkppnkdipbiggnmlkahcdkikp" = "Color Picker (PROIBIDO)"
                    "ihbiedpeaicgipncdnnkikeehnjiddck" = "Weather (PROIBIDO)"
                    "glckmpfajbjppappjlnhhlofhdhlcgaj" = "Good Tab (PROIBIDO)"
                    "giecgobdmgdamgffeoankaipjkdjbfep" = "Children Protection (PROIBIDO)"
                    "bjoddpbfndnpeohkmpbjfhcppkhgobcg" = "DPS Websafe (PROIBIDO)"
                    "beifiidafjobphnbhbbgmgnndjolfcho" = "Stock Informer (PROIBIDO)"
                }

                Write-OutputBox "A processar extensões em ${machine}..."

                $result = Get-ChildItem -Path $basePath -Directory | ForEach-Object {
                    $extId = $_.Name
                    $extPath = $_.FullName
                    $knownName = if ($knownExtensions.ContainsKey($extId)) { $knownExtensions[$extId] } else { "Desconhecido" }
                    $size = (Get-ChildItem -Path $extPath -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
                    $sizeMB = [math]::Round($size / 1MB,2)
                    [PSCustomObject]@{
                        ID=$extId
                        Nome_Conhecido=$knownName
                        Data_Modificacao=$_.LastWriteTime
                        Tamanho_MB=$sizeMB
                    }
                }

                Write-OutputBox "ID                                   Nome                          Data                Tamanho(MB)"
Write-OutputBox "------------------------------------------------------------------------------------------------------"

$result | Sort-Object Data_Modificacao -Descending | ForEach-Object {

    $linha = "{0,-35} {1,-30} {2,-20} {3,8}" -f `
        $_.ID,
        $_.Nome_Conhecido,
        $_.Data_Modificacao.ToString("yyyy-MM-dd HH:mm"),
        $_.Tamanho_MB

    Write-OutputBox $linha
}
            })
        }

        "Apps da Máquina" {
            $btn.Add_Click({
                Clear-Output
                $computador = $txtMachine.Text
                if ([string]::IsNullOrWhiteSpace($computador)) { $computador = $env:COMPUTERNAME }

                Write-OutputBox "A recolher aplicações instaladas na máquina ${computador}..."
                Write-OutputBox ""

                $appsRaw = Invoke-Command -ComputerName $computador -ScriptBlock {
                    Get-ItemProperty `
                        HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*, `
                        HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
                    Where-Object {
                        $_.DisplayName -ne $null -and
                        -not $_.SystemComponent -and
                        -not $_.ParentKeyName -and
                        $_.DisplayName -notmatch "Update|Hotfix|Security"
                    } |
                    Select-Object DisplayName, DisplayVersion, Publisher, InstallDate
                }

                function Trim-Text($text, $max) {
                    if (-not $text) { return "" }
                    if ($text.Length -gt $max) {
                        return $text.Substring(0, $max-3) + "..."
                    }
                    return $text
                }

                $header = "{0,-40} {1,-12} {2,-25} {3,-12}" -f "Nome","Versão","Publisher","Data"
                Write-OutputBox $header
                Write-OutputBox ("-" * 95)

                foreach ($app in $appsRaw) {
                    $nome = Trim-Text $app.DisplayName 40
                    $versao = Trim-Text $app.DisplayVersion 12
                    $publisher = Trim-Text $app.Publisher 25
                    $data = if ($app.InstallDate) {
                        try { (Get-Date $app.InstallDate -Format "yyyy-MM-dd") } catch { "N/A" }
                    } else { "N/A" }

                    $linha = "{0,-40} {1,-12} {2,-25} {3,-12}" -f $nome, $versao, $publisher, $data
                    Write-OutputBox $linha
                }
            })
        }

        "AppData / User" {
            $btn.Add_Click({
                Clear-Output
                $computador = $txtMachine.Text
                $user = $txtUser.Text

                if ([string]::IsNullOrWhiteSpace($user)) {
                    [System.Windows.Forms.MessageBox]::Show("Por favor, insira o usuário para listar AppData.","Aviso",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Warning)
                    return
                }

                $basePath = "\\${computador}\c$\Users\$user"

                if (-not (Test-Path $basePath)) {
                    Write-OutputBox "Caminho não encontrado: ${basePath}"
                    return
                }

                $localPath = "$basePath\AppData\Local"
                $roamingPath = "$basePath\AppData\Roaming"

                $pastas = Get-ChildItem -Path $basePath -Directory | Select-Object -ExpandProperty Name
                $local = if (Test-Path $localPath) { Get-ChildItem -Path $localPath -Directory | Select-Object -ExpandProperty Name } else { @() }
                $roaming = if (Test-Path $roamingPath) { Get-ChildItem -Path $roamingPath -Directory | Select-Object -ExpandProperty Name } else { @() }

                $max = ($pastas.Count, $local.Count, $roaming.Count | Measure-Object -Maximum).Maximum

                $resultado = for ($i=0; $i -lt $max; $i++) {
                    [PSCustomObject]@{
                        "Pastas do Utilizador" = if ($i -lt $pastas.Count) { $pastas[$i] } else { "" }
                        "AppData Local" = if ($i -lt $local.Count) { $local[$i] } else { "" }
                        "AppData Roaming" = if ($i -lt $roaming.Count) { $roaming[$i] } else { "" }
                    }
                }

Write-OutputBox ""
Write-OutputBox "=== APPDATA / USER ==="
Write-OutputBox ""

# Header
$header = "{0,-25} {1,-25} {2,-25}" -f "Pastas User","Local","Roaming"
Write-OutputBox $header
Write-OutputBox "-----------------------------------------------------------------------"

foreach ($item in $resultado) {

    $pasta   = Fix-Text $item."Pastas do Utilizador" 25
    $local   = Fix-Text $item."AppData Local" 25
    $roaming = Fix-Text $item."AppData Roaming" 25

    $linha = "$pasta $local $roaming"

    Write-OutputBox $linha
}
            })
        }
    }
}

# ------------------------------
# Exibir Form
# ------------------------------
[void]$form.ShowDialog()