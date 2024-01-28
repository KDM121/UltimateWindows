Add-Type -AssemblyName System.Windows.Forms

$FormObject = [System.Windows.Forms.Form]
$LabelObject = [System.Windows.Forms.Label]
$ButtonObject = [System.Windows.Forms.Button]

$UltimateWinSetup=New-Object $FormObject
$UltimateWinSetup.ClientSize='800,600'
$UltimateWinSetup.Text='The Ultimate Windows Setup'
$UltimateWinSetup.BackColor="#001633"

$lbltitle=New-Object $LabelObject
$lbltitle.Text='Select what to run'
$lbltitle.AutoSize=$true
$lbltitle.Font='Consolas,24,style=Bold'
$lbltitle.ForeColor="#ffffff"
$lbltitle.Location=New-Object System.Drawing.Point(230,20)

$btnHello=New-Object $ButtonObject
$btnHello.Text='Run Debloat Script'
$btnHello.Autosize=$true
$btnHello.Location=New-Object System.Drawing.Point(300,100)
$btnHello.Font='Consolas,14'
$btnHello.ForeColor="#ffffff"
$btnHello.Add_Click({
    & "/Debloat/debloat1.ps1"
    $lbltitle.Text = "Debloat script executed!"
})

$UltimateWinSetup.Controls.AddRange(@($lbltitle,$btnHello))



# displays form
$UltimateWinSetup.ShowDialog()


## cleans up form
$UltimateWinSetup.Dispose()