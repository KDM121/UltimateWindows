Add-Type -AssemblyName System.Windows.Forms

$FormObject = [System.Windows.Forms.Form]
$LabelObject = [System.Windows.Forms.Label]

$HelloWorldForm=New-Object $FormObject
$HelloWorldForm.ClientSize='500,300'
$HelloWorldForm.Text='Hello World - Tutorial'
$HelloWorldForm.BackColor="#001633"

# displays form
$HelloWorldForm.ShowDialog()


## cleans up form
$HelloWorldForm.Dispose()