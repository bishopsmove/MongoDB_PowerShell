<#
MongoDB helpfile html generator - 

This is just a quick and dirty way of transforming the help output provided by the MongoDB executables into a series of html files 
that should be easily queried.

I will probably expound upon this idea and provide something of a micro-site but this will do for now.
#>

$binPath = $null
$helpFile = $null
$startFile = $null
$newHelpFileName = $null
#set your path to the bin executables folder
$binPath = "C:\Program Files\MongoDB\Server\3.0\bin"

$helpPath = $binPath + "\help"

#Check for the output dir, create it if not exist
if((gci -path $binPath -filter "help") -eq $null){
mkdir ($helpPath)
}

#Iterate through the file list and run the help command, capturing the returning help text

gci -path $binPath -filter "*.exe" | %{

$startFile = & $_.FullName --help

#Some of the files have '<' and '>' symbols in the help detail. I could setup a call to HtmlEncode the string, but Regex seems a bit more straightforward here
$rxVariableName = New-Object System.Text.RegularExpressions.Regex "<|>"

$rxVariableName.Matches($startFile) | %{ 
    $startFile = $startFile -replace $_.Value, $_.Value.Replace("<","&lt;")
    $startFile = $startFile -replace $_.Value, $_.Value.Replace(">","&gt;")
    }
    
#Prepend the resulting html output with a preamble
$helpFile = @"
<html>
<body>
<pre>

"@

$helpFile += [string]::join([environment]::newline, $startFile)

#Bookend the preamble to complete the html file
$helpFile += @"

</pre>
</body>
</html>
"@

#Just taking the original executable name and setting the relative help file name accordingly
$newHelpFileName = $helpPath + "\" + $_.Name.Replace(".exe","") + ".help.html"
 set-content -en utf8 -Path $newHelpFileName -Value $helpFile -force
 }





