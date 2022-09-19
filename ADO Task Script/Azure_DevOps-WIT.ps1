############################################
# Make sure Azure CLI and Azure DevOps
# extension updated
############################################
# az upgrade

############################################
# Variables
############################################
$azPAT = "PLACEHOLDER FOR ACTUAL TOKEN"
$organizationName = "ORG NAME PLACEHOLDER"
$projectName = "PROJECT NAME PLACEHOLDER"
$orgURL = "https://dev.azure.com/$organizationName/"
$sprint = "Sprint 20"

############################################
# Connect to Azure DevOps Instance with PAT
############################################
Write-Output $azPAT | devops login --organization $orgURL
#az login

############################################
# Work Item Arrays
############################################
# New work items you want to create
$workItems = @(
   [pscustomobject]@{Type="Issue";Title="Test Issue 1";Description="<div>Test Issue description.</div>";Activity="";Area=$projectName;Iteration="$projectName\$sprint";AssignedTo="[Name Placeholder]";Parent="[Parent Number Placeholder]"}
   [pscustomobject]@{Type="Issue";Title="Test Issue 2";Description="<div>Test Issue description.</div>";Activity="";Area=$projectName;Iteration="$projectName\$sprint";AssignedTo="[Name Placeholder]";Parent="[Parent Number Placeholder]"}
   [pscustomobject]@{Type="Issue";Title="Test Issue 3";Description="<div>Test Issue description.</div>";Activity="";Area=$projectName;Iteration="$projectName\$sprint";AssignedTo="[Name Placeholder]";Parent="[Parent Number Placeholder]"}
   [pscustomobject]@{Type="Issue";Title="Test Issue 4";Description="<div>Test Issue description.</div>";Activity="";Area=$projectName;Iteration="$projectName\$sprint";AssignedTo="[Name Placeholder]";Parent="[Parent Number Placeholder]"}
   [pscustomobject]@{Type="Issue";Title="Test Issue 5";Description="<div>Test Issue description.</div>";Activity="";Area=$projectName;Iteration="$projectName\$sprint";AssignedTo="[Name Placeholder]";Parent="[Parent Number Placeholder]"}
   [pscustomobject]@{Type="Issue";Title="Test Issue 6";Description="<div>Test Issue description.</div>";Activity="";Area=$projectName;Iteration="$projectName\$sprint";AssignedTo="[Name Placeholder]";Parent="[Parent Number Placeholder]"}
   [pscustomobject]@{Type="Issue";Title="Test Issue 7";Description="<div>Test Issue description.</div>";Activity="";Area=$projectName;Iteration="$projectName\$sprint";AssignedTo="[Name Placeholder]";Parent="[Parent Number Placeholder]"}
   [pscustomobject]@{Type="Issue";Title="Test Issue 8";Description="<div>Test Issue description.</div>";Activity="";Area=$projectName;Iteration="$projectName\$sprint";AssignedTo="[Name Placeholder]";Parent="[Parent Number Placeholder]"}
   [pscustomobject]@{Type="Issue";Title="Test Issue 9";Description="<div>Test Issue description.</div>";Activity="";Area=$projectName;Iteration="$projectName\$sprint";AssignedTo="[Name Placeholder]";Parent="[Parent Number Placeholder]"}
)

# Blank array that we will use to create a list to print out later.
$newWorkItems=New-Object System.Collections.ArrayList

############################################
# Begin Work Item Creation and Relate to
# Parent Work Item
############################################
# TODO: Iterate through array of work items
$workItems | ForEach-Object {
    # Temporary variables
    $type =$_.Type 
    $title=$_.Title
    $description = $_.Description
    $activity=$_.Activity
    $area=$_.Area
    $iteration=$_.Iteration
    $assignedTo=$_.AssignedTo
    $parent=$_.Parent

    # TODO: Create the work item
    $resultJson = az boards work-item create --project $projectName --title $title --type $type --description $description --organization $orgURL --fields "Microsoft.VSTS.Common.Activity=$activity" "System.AreaPath=$area" "System.IterationPath=$iteration" "System.AssignedTo=$assignedTo"
    $callResult = $resultJson | ConvertFrom-Json
    $newWitID = $callResult.id

    # TODO: Assign it to its parent epic
    az boards work-item relation add --id $newWitID --relation-type parent --target-id $parent

   $resultJson | Out-File -FilePath "resultJson-$newWitID.json"
   $callResult | Out-File -FilePath "callResult-$newWitID.txt"

   $singleNewWIT = @(
      [pscustomobject]@{WorkItemID=$newWitID;Type=$type;Title=$title;Area=$area;Sprint=$sprint}
   )
   $newWorkItems.Add($singleNewWIT)
}

$itemCount = $newWorkItems.Count
$currentTime = get-date -f yyyy-MM-dd
$newWorkItems | Out-File -FilePath "New-Work-Items-$currentTime.txt"
Write-Output "The following $itemCount work items were created in the $organizationName Azure DevOps:"
$newWorkItems

Read-Host -Prompt "Press Enter to exit"