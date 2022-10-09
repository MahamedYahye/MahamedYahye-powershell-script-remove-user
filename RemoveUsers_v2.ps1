# Import Active Directory module
Import-Module ActiveDirectory
 
# Open file dialog
# Load Windows Forms
[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
 
# Create and show open file dialog
$dialog = New-Object System.Windows.Forms.OpenFileDialog
$dialog.InitialDirectory = $StartDir
$dialog.Filter = "CSV (*.csv)| *.csv" 
$dialog.ShowDialog() | Out-Null
 
# Get file path
$CSVFile = $dialog.FileName
 
# Import file into variable
# Lets make sure the file path was valid
# If the file path is not valid, then exit the script
if ([System.IO.File]::Exists($CSVFile)) {
    Write-Host "Importing CSV..."
    $CSV = Import-Csv -LiteralPath "$CSVFile"
} else {
    Write-Host "File path specified was not valid"
    Exit
}
 
# Lets iterate over each line in the CSV file
foreach($user in $CSV) {
    $Username = $user.Username
    
    Try {
        Remove-ADUser -Identity $Username
    } Catch {
        Write-Host $_.Exception.Message
        continue
    }

    # Write to host that we removed the user
    Write-Host "Removed $Username"
}
 
Read-Host -Prompt "Script complete... Press enter to exit."