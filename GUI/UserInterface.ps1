Add-Type -AssemblyName System.Windows.Forms

$FormObject = [System.Windows.Forms.Form]
$LabelObject = [System.Windows.Forms.Label]
$ButtonObject = [System.Windows.Forms.Button]

$HelloWorldForm=New-Object $FormObject
$HelloWorldForm.ClientSize='500,300'
$HelloWorldForm.Text='Hello World - Tutorial'
$HelloWorldForm.BackColor="#001633"

$lbltitle=New-Object $LabelObject
$lbltitle.Text='Hello World!'
$lbltitle.AutoSize=$true
$lbltitle.Font='Verdana,24,style=Bold'
$lbltitle.Location=New-Object System.Drawing.Point(120,110)

$btnHello=New-Object $ButtonObject
$btnHello.Text='Say Hello'
$btnHello.Autosize=$true
$btnHello.Location=New-Object System.Drawing.Point(175,180)

$HelloWorldForm.Controls.AddRange(@($lbltitle,$btnHello))


# displays form
$HelloWorldForm.ShowDialog()


## cleans up form
$HelloWorldForm.Dispose()