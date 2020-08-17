function New-BootstrapSinglePanel {
<#
.SYNOPSIS
Create a single panel for use in an IT Glue Flexible Asset
.DESCRIPTION
Takes a number of parameters and returns HTML that can be inserted in to IT Glue. Panel sizes correspond to BootStrap sizes, which are 12 wide.
.PARAMETER PanelShading
Valid options are 'active', 'success', 'info', 'warning', 'danger', 'blank' - these correspond to BootStrap 3 colours
.PARAMETER PanelTitle
Takes a title, can either be text or image. This is the title at the of the Panel
.PARAMETER PanelContent
The main content of the panel
.PARAMETER ContentAsBadge
Presents the content as a BootStrap Badge
.PARAMETER PanelAdditionalDetail
Used to add additional items underneath the main content
.OUTPUTS
BootStrap 3 compliant HTML which can be used inside an IT Glue Flexible Asset
.NOTES
Version:        1.0.0
Author:         Gavin Stone
Creation Date:  2020-08-17
Purpose/Change: Initial script development

.EXAMPLE
New-BootstrapSinglePanel -PanelShading "success" -PanelTitle "<img src='https://www.xyz.com/image.png'>" -ContentAsBadge -PanelSize 3 -PanelContent "<b>Active</b>" -PanelAdditionalDetail "$($YourVariable) Licenses"
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]  
        [ValidateSet('active', 'success', 'info', 'warning', 'danger', 'blank')]
        [string]$PanelShading,

        [Parameter(Mandatory)]
        [string]$PanelTitle,

        [Parameter(Mandatory)]
        [string]$PanelContent,

        [switch]$ContentAsBadge,

        [string]$PanelAdditionalDetail,

        [Parameter(Mandatory)]
        [int]$PanelSize = 3
    )

    if ($PanelShading -ne 'Blank') {
        $PanelStart = "<div class=`"col-sm-$PanelSize`"><div class=`"panel panel-$PanelShading`">"
    }
    else {
        $PanelStart = "<div class=`"col-sm-$PanelSize`"><div class=`"panel`">"
    }

    $PanelTitle = "<div class=`"panel-heading`"><h3 class=`"panel-title text-center`">$PanelTitle</h3></div>"


    if ($PSBoundParameters.ContainsKey('ContentAsBadge')) {
        $PanelContent = "<div class=`"panel-body text-center`"><h4><span class=`"label label-$PanelShading`">$PanelContent</span></h4>$PanelAdditionalDetail</div>"
    }
    else {
        $PanelContent = "<div class=`"panel-body text-center`"><h4>$PanelContent</h4>$PanelAdditionalDetail</div>"
    }
    $PanelEnd = "</div></div>"
    $FinalPanelHTML = "{0}{1}{2}{3}" -f $PanelStart, $PanelTitle, $PanelContent, $PanelEnd
    return $FinalPanelHTML
}

function New-BootstrapInfoPanel {
<#
.SYNOPSIS
Create an info panel for use in an IT Glue Flexible Asset, the info panel consists of BootStrap Alerts
.DESCRIPTION
Takes a number of parameters and returns HTML that can be inserted in to IT Glue. Panel sizes correspond to BootStrap sizes, which are 12 wide.
This is designed to take an array of objects so you can add multiple 
.PARAMETER PanelShading
Valid options are 'active', 'success', 'info', 'warning', 'danger', 'blank' - these correspond to BootStrap 3 colours
.PARAMETER PanelTitle
Takes a title, can either be text or image. This is the title at the of the Panel
.PARAMETER PanelContent
The main content of the panel. This should be an object that is built up as so:
$CustomInfoPanel = [PSCustomObject]@()
    $CustomInfoPanel += @{
        Shading = "success"
        AlertText = "There is no Server 2008 or SBS machines at this client"
    }
    $CustomInfoPanel += @{
        Shading = "danger"
        AlertText = "There are $Server2008Count Server 2008 or SBS insecure machines active"
    }
As many of these as needed can be added

.OUTPUTS
BootStrap 3 compliant HTML which can be used inside an IT Glue Flexible Asset
.NOTES
Version:        1.0.0
Author:         Gavin Stone
Creation Date:  2020-08-17
Purpose/Change: Initial script development

.EXAMPLE
New-BootstrapInfoPanel -PanelShading "info" -PanelContent $CustomInfoPanel -PanelSize 6 -PanelTitle "<img src='https://www.xyz.com/image.png'>"
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]  
        [ValidateSet('active', 'success', 'info', 'warning', 'danger', 'blank')]
        [string]$PanelShading,

        [Parameter(Mandatory)]
        [string]$PanelTitle,

        [Parameter(Mandatory)]
        [pscustomobject[]]$PanelContent,

        [Parameter(Mandatory)]
        [int]$PanelSize = 3
    )

    if ($PanelShading -ne 'Blank') {
        $PanelStart = "<div class=`"col-sm-$PanelSize`"><div class=`"panel panel-$PanelShading`">"
    }
    else {
        $PanelStart = "<div class=`"col-sm-$PanelSize`"><div class=`"panel`">"
    }

    if (-not([string]::IsNullOrEmpty($PanelTitle))) {
        $PanelTitle = "<div class=`"panel-heading`"><h3 class=`"panel-title text-center`">$PanelTitle</h3></div>"
    }
    else {
        $PanelTitle = ""
    }

    $FinalPanelContent = "<div class=`"panel-body text-center`">"
    foreach ($item in $PanelContent) {
        $FinalPanelContent = "$FinalPanelContent<div class=`"alert alert-$($item.shading)`" role=`"alert`">$($item.AlertText)</div>"
    }

    $FinalPanelEnd = "</div>"


    $PanelEnd = "</div></div>"
    $FinalPanelHTML = "{0}{1}{2}{3}{4}" -f $PanelStart, $PanelTitle, $FinalPanelContent, $FinalPanelEnd, $PanelEnd
    return $FinalPanelHTML
}

# Example code
# OVERVIEW ROW- Represents One Row in IT Glue, a width of 12.
$OverViewRowTop = "<div class = `"row`">"
$OverViewRowBottom = "</div>"

$Panel1HTML = New-BootstrapSinglePanel -PanelShading "success" -PanelTitle "<img src='https://i.imgur.com/fZPYPg3.png'" -PanelContent "There are 100% Users MFAed" -ContentAsBadge -PanelSize 3
$Panel2HTML = New-BootstrapSinglePanel -PanelShading "danger" -PanelTitle "<img src='https://i.imgur.com/fZPYPg3.png'" -PanelContent "3 Users are Unlicensed"   -ContentAsBadge -PanelSize 3
$Panel3HTML = New-BootstrapSinglePanel -PanelShading "danger" -PanelTitle "Exchange Rules" -PanelContent "12 Rules Inactive" -ContentAsBadge -PanelSize 3
$Panel4HTML = New-BootstrapSinglePanel -PanelShading "info" -PanelTitle "Licensing" -PanelContent "22 Users on 365 Business Premium" -ContentAsBadge -PanelSize 3

# Build the Final HTML for this Row
$FinalOverviewHTML = "{0}{1}{2}{3}{4}{5}" -f $OverViewRowTop, $Panel1HTML, $Panel2HTML, $Panel3HTML, $Panel4HTML, $OverViewRowBottom

# SECOND ROW
$SecondRowTop = "<div class = `"row`">"
$SecondRowBottom = "</div>"

$SRPanel1HTML = New-BootstrapSinglePanel -PanelShading "success" -PanelTitle "<img src='https://i.imgur.com/nTXOSNj.png'" -PanelContent "There are 100% Users MFAed" -ContentAsBadge -PanelSize 3
$SRPanel2HTML = New-BootstrapSinglePanel -PanelShading "danger" -PanelTitle "<img src='https://i.imgur.com/fZPYPg3.png'" -PanelContent "3 Users are Unlicensed"   -ContentAsBadge -PanelSize 6
$SRPanel3HTML = New-BootstrapSinglePanel -PanelShading "warning" -PanelTitle "Exchange Rules" -PanelContent "12 Rules Inactive" -ContentAsBadge -PanelSize 3

# Build the Final HTML for this Row
$SecondRowHTML = "{0}{1}{2}{3}{4}" -f $SecondRowTop, $SRPanel1HTML, $SRPanel2HTML, $SRPanel3HTML, $SecondRowBottom

# Third ROW
$ThirdRowTop = "<div class = `"row`">"
$ThirdRowBottom = "</div>"

$TRPanel1HTML = New-BootstrapSinglePanel -PanelShading "info" -PanelTitle "<img src='https://i.imgur.com/fZPYPg3.png'" -PanelContent "<b>This is bolded panel content</b>" -PanelSize 3 -PanelAdditionalDetail "This is additional detail in the panel"
$TRPanel2HTML = New-BootstrapSinglePanel -PanelShading "danger" -PanelTitle "<img src='https://i.imgur.com/fZPYPg3.png'" -PanelContent "3 Users are Unlicensed"   -ContentAsBadge -PanelSize 3

$CustomInfoPanel = [PSCustomObject]@()
$CustomInfoPanel += @{
    Shading = "success"
    AlertText = "There is no Server 2008 or SBS machines at this client"
}
$CustomInfoPanel += @{
    Shading = "danger"
    AlertText = "There are $Server2008Count Server 2008 or SBS insecure machines active"
}
$CustomInfoPanel += @{
    Shading = "info"
    AlertText = "SBS is bad enough, but if you still have 2003 Servers.... I feel sorry for you"
}

$TRPanel3HTML = New-BootstrapInfoPanel -PanelSize 6 -PanelContent $CustomInfoPanel -PanelTitle "Things you should have sorted long ago" -PanelShading "danger"

# Build the Final HTML for this Row
$ThirdRowHTML = "{0}{1}{2}{3}{4}" -f $ThirdRowTop, $TRPanel1HTML, $TRPanel2HTML, $TRPanel3HTML, $ThirdRowBottom

$HTMLString = @"
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">

<!-- Optional theme -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous">

<!-- Latest compiled and minified JavaScript -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
<div class="row">
<div class="col-md-2">IT GLUE NAV LEFT HAND BAR</div>
<div class="col-md-7">
$FinalOverViewHTML
$SecondRowHTML
$ThirdRowHTML
</div>
<div class="col-md-3">IT GLUE RIGHT HAND BAR</div>
</div>
"@

$HTMLString | Out-File "$($env:USERPROFILE)\Desktop\Temp.html"
