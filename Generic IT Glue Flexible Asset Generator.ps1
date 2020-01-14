#Get appropriate credentials and token  
$ITGlueAPIKey = Get-ImpactCredentialsAzureKeyVault -ITGlue

# Configure IT Glue for the Session
Add-ITGlueBaseURI -data_center EU
Add-ITGlueAPIKey -Api_Key $ITGlueAPIKey


function New-ITGFlexibleAssetTypeFromObject {
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]
    $FlexAssetName,

    [Parameter()]
    [string]
    $FlexAssetDescription,

    [Parameter()]
    [string]
    $FlexAssetIcon,

    [Parameter(Mandatory=$true)]
    $TemplateObject,

    [Parameter()]
    $PropertyToUseForTitle
)
    # We need to select only one of the results from the object
    $TemplateObject = $TemplateObject | Select-Object -First 1

    $flexible_asset_type = @{
        type       = 'flexible-asset-types'
        attributes = @{
            name        = $FlexAssetName
            icon        = $FlexAssetIcon
            description = $FlexAssetDescription
        }
        relationships = @{
            "flexible-asset-fields" = @{
                data = @()
            }
        }
    }

    # Now we need to loop through the object that has come in...

    $ObjectNames = $TemplateObject | Get-Member -MemberType Properties | Select-Object *

    $Counter = 1
    foreach ($ObjectValue in $ObjectNames) {
        # Try to figure out the object type
        $Kind = "Textbox" # Set the default
        #Write-Host "$($ObjectValue.Name) is $($TemplateObject.$($ObjectValue.Name).GetType())"

        if ($TemplateObject.$($ObjectValue.Name) -is [Boolean]) {
            #Write-Host "$($ObjectValue.Name) is boolean"
            $Kind = "Checkbox"
        }

        if ($TemplateObject.$($ObjectValue.Name) -is [string]) {
            #Write-Host "$($ObjectValue.Name) is string"
            $Kind = "Text"
        }

        if (($TemplateObject.$($ObjectValue.Name) -is [int32]) -or ($TemplateObject.$($ObjectValue.Name) -is [int]) -or (($TemplateObject.$($ObjectValue.Name) -is [long]))) {
            #Write-Host "$($ObjectValue.Name) is a number, either int, int32 or long"
            $Kind = "Number"
        }
        
        if ($TemplateObject.$($ObjectValue.Name) -is [datetime]) {
            #Write-Host "$($ObjectValue.Name) is datetime"
            $Kind = "Date"
        }

        $flexible_asset_type.relationships.'flexible-asset-fields'.data +=
            @{
                type       = "flexible_asset_fields"
                attributes = @{
                    order           = $Counter
                    name            = $ObjectValue.Name.ToLower()
                    kind            = $Kind
                    required        = $false
                    "show-in-list"  = $true
                    "use-for-title" = $(If($ObjectValue.Name -eq $PropertyToUseForTitle){$true}Else{$false})
                }
            }

        $Counter++
    }


    return $flexible_asset_type
}

function New-ITGFlexibleAssetFromObject {
    param (
        $Object,
        $OrgID,
        [decimal]$FlexibleAssetID
    )

    #Generate the blank object
    $FinalArray = @()
    $ObjectProperties = $Object | Get-Member -MemberType Properties | Select-Object Name
    foreach ($Result in $Object) {
        $api_body_update = @{
            type       = "flexible_assets"
            attributes = @{
                "organization_id" = $OrgID
                "flexible_asset_type_id" = $FlexibleAssetID
                traits = @{
                }
            }
        }



        foreach ($Property in $ObjectProperties) {
            #Write-Host "$Result.$($Property.Name)"
            If ($($Result.$($Property.Name)) -is [datetime]) {
                $FinalValue = $($Result.$($Property.Name.ToLower()).ToString('yyyy-MM-dd HH:MM:SS'))        
            }
            else {
                $FinalValue = $($Result.$($Property.Name.ToLower()))
            }
            $api_body_update.attributes.traits.Add("$($Property.Name.ToLower())", "$FinalValue")
        }
        $FinalArray += $api_body_update
        $api_body_update = ""
    }
    
    return $FinalArray
}

# Variables to Set----------------------------------------------------
$FlexibleAssetTypeName = "Test Processes"
$FlexibleAssetDescription = "This is a test for get process to IT Glue"
$FlexibleAssetIcon = "sitemap"
$FlexibleAssetPropertyToUseForTitle = "processname"
$OrganizationID = 12345678912345

# Get the object/data you want to template for
$DataToProcess = Get-Process | Select-Object -First 10
#---------------------------------------------------------------------

# Generate the Flexible Asset type template
$FlexibleAssetTypeTemplate = New-ITGFlexibleAssetTypeFromObject -FlexAssetName $FlexibleAssetTypeName -FlexAssetDescription $FlexibleAssetDescription -FlexAssetIcon $FlexibleAssetIcon -TemplateObject $DataToProcess -PropertyToUseForTitle $FlexibleAssetPropertyToUseForTitle

# Create the Flexible Asset Type
New-ITGlueFlexibleAssetTypes -data $FlexibleAssetTypeTemplate

# Lookup the ID of the Flexible Asset Type just created
$FilterID = (Get-ITGlueFlexibleAssetTypes -filter_name $FlexibleAssetTypeName).data

# Create the flexible assets template using the newly created flexible asset type
$FlexibleAssetTemplate = New-ITGFlexibleAssetFromObject -Object $DataToProcess -OrgID $OrganizationID -FlexibleAssetID $FilterID.id

# Create the flexible assets
New-ITGlueFlexibleAssets -data $FlexibleAssetTemplate -organization_id $OrganizationID



