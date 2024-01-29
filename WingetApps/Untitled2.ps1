# Load assembly
Add-Type -AssemblyName System.Windows.Forms

# Define categories and applications
$categories = @{
    "Internet" = @("Ablaze.Floorp", "Alex313031.Thorium", "Waterfox.Waterfox", "Mozilla.Firefox", "LibreWolf.LibreWolf");
    "Tools" = @("Microsoft.VisualStudioCode", "Notepad++.Notepad++", "Yubico.Authenticator", "Yubico.YubikeyManager", "Yubico.YubiKeyPersonalizationTool", "ShareX.ShareX", "REALiX.HWiNFO");
    "Office" = @("BlenderFoundation.Blender", "FreeCAD.FreeCAD", "TheDocumentFoundation.LibreOffice");
    "Media" = @("Discord.Discord", "OBSProject.OBSStudio", "dotPDNLLC.paintdotnet", "Parsec.Parsec", "Telegram.TelegramDesktop");
    "Utilities" = @("7zip.7zip", "Famatech.AdvancedIPScanner", "Balena.Etcher", "AdrienAllard.FileConverter", "Rufus.Rufus", "OpenJS.NodeJS", "Yarn.Yarn");
    "Other" = @("GitHub.GitHubDesktop", "Iriun.IriunWebcam", "Google.NearbyShare", "Oracle.VirtualBox", "Ookla.Speedtest.Desktop", "Rils.TouchPortal")
    "Security" = @("Bitwarden.Bitwarden", "MudhookMarketing.IPVanish", "Insecure.Nmap",  "Microsoft.PowerToys", "ProtonTechnologies.ProtonVPN", "WireGuard.WireGuard")
    "Gaming" = @("EpicGames.EpicGamesLauncher", "Logitech.GHUB", "Valve.Steam", "SteelSeries.GG", "Moonsworth.LunarClient")
}

# Function to install applications
function Install-Applications {
    param(
        [Parameter(Mandatory=$true)]
        [string[]]$applications
    )

    foreach ($application in $applications) {
        winget install $application
    }
}

# Create form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Application Installer'
$form.Size = New-Object System.Drawing.Size(1500, 300)  # Adjust width for columns
$form.StartPosition = 'CenterScreen'

# Create GroupBoxes for each category
$columnX = 30
foreach ($category in $categories.Keys) {
    $groupBox = New-Object System.Windows.Forms.GroupBox
    $groupBox.Location = New-Object System.Drawing.Point($columnX, 30)
    $groupBox.Size = New-Object System.Drawing.Size(150, 150)
    $groupBox.Text = $category
    $form.Controls.Add($groupBox)

    # Create CheckedListBox inside the GroupBox
    $checkedListBox = New-Object System.Windows.Forms.CheckedListBox
    $checkedListBox.Location = New-Object System.Drawing.Point(10, 20)
    $checkedListBox.Size = New-Object System.Drawing.Size(130, 120)
    $checkedListBox.Items.AddRange($categories[$category])
    $checkedListBox.CheckOnClick = $true  # Enable single-click checking
    $groupBox.Controls.Add($checkedListBox)

    $columnX += 180  # Adjust spacing between columns
}

# Create button
$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(30, 190)
$button.Size = New-Object System.Drawing.Size(490, 30)  # Adjust width for columns
$button.Text = 'Install'
$button.Add_Click({
    $selectedApplications = @()
    foreach ($groupBox in $form.Controls) {
        if ($groupBox -is [System.Windows.Forms.GroupBox]) {
            $checkedListBox = $groupBox.Controls[0]
            $selectedApplications += $checkedListBox.CheckedItems
        }
    }
    Install-Applications -applications $selectedApplications
})
$form.Controls.Add($button)



$importConfigButton = New-Object System.Windows.Forms.Button
$importConfigButton.Location = New-Object System.Drawing.Point(720, 190)
$importConfigButton.Size = New-Object System.Drawing.Size(150, 30)
$importConfigButton.Text = 'Import Config'
$importConfigButton.Add_Click({
    $file = [System.Windows.Forms.OpenFileDialog]::new()
    $file.Filter = 'JSON (*.json)|*.json;XML (*.xml)|*.xml;Text (*.txt)|*.txt'
    if ($file.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $config = Get-Content $file.FileName -Raw | ConvertFrom-Json  # Assuming JSON format
        $predeterminedApps = $config.preselectedApps

        # Update UI with imported apps
        foreach ($groupBox in $form.Controls) {
            if ($groupBox -is [System.Windows.Forms.GroupBox]) {
                $checkedListBox = $groupBox.Controls[0]
                $checkedListBox.SetItemChecked(0, $false)  # Clear initial checks
                foreach ($app in $predeterminedApps) {
                    $index = $checkedListBox.Items.IndexOf($app)
                    if ($index -ge 0) {
                        $checkedListBox.SetItemChecked($index, $true)
                    }
                }
            }
        }
    }
})
$form.Controls.Add($importConfigButton)

# Export configuration button
$exportConfigButton = New-Object System.Windows.Forms.Button
$exportConfigButton.Location = New-Object System.Drawing.Point(890, 190)
$exportConfigButton.Size = New-Object System.Drawing.Size(150, 30)
$exportConfigButton.Text = 'Export Config'
$exportConfigButton.Add_Click({
    $file = [System.Windows.Forms.SaveFileDialog]::new()
    $file.Filter = 'JSON (*.json)|*.json;XML (*.xml)|*.xml;Text (*.txt)|*.txt'
    if ($file.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $selectedApps = @()
        foreach ($groupBox in $form.Controls) {
            if ($groupBox -is [System.Windows.Forms.GroupBox]) {
                $checkedListBox = $groupBox.Controls[0]
                $selectedApps += $checkedListBox.CheckedItems
            }
        }
        $config = @{ preselectedApps = $selectedApps }
        $config | ConvertTo-Json | Set-Content $file.FileName  # Export as JSON
    }
})
$form.Controls.Add($exportConfigButton)

# Show form
$form.ShowDialog()
