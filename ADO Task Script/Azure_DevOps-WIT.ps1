############################################
# Variables
############################################
$organizationName = "ORG NAME PLACEHOLDER"
$orgURL = "https://dev.azure.com/$organizationName/"
$sprint = "Sprint 20"
$projectName = "PROJECT NAME PLACEHOLDER"

############################################
# Connect to Azure DevOps Instance with PAT
############################################
az devops login --organization $orgURL

############################################
# Work Item Arrays
############################################
# New work items you want to create
$workItems = @(
   # Start of Work Items that will be created #
   [pscustomobject]@{Type="Issue";Title="Test Issue 1";Description="<div>Test Issue description.</div>";Activity="";Area=$projectName;Iteration="$projectName\$sprint";AssignedTo="[Name Placeholder]";Parent="[Parent Number Placeholder]"}
   [pscustomobject]@{Type="Issue";Title="Test Issue 2";Description="<div>Test Issue description.</div>";Activity="";Area=$projectName;Iteration="$projectName\$sprint";AssignedTo="[Name Placeholder]";Parent="[Parent Number Placeholder]"}
   [pscustomobject]@{Type="Issue";Title="Test Issue 3";Description="<div>Test Issue description.</div>";Activity="";Area=$projectName;Iteration="$projectName\$sprint";AssignedTo="[Name Placeholder]";Parent="[Parent Number Placeholder]"}
   [pscustomobject]@{Type="Issue";Title="Test Issue 4";Description="<div>Test Issue description.</div>";Activity="";Area=$projectName;Iteration="$projectName\$sprint";AssignedTo="[Name Placeholder]";Parent="[Parent Number Placeholder]"}
   [pscustomobject]@{Type="Issue";Title="Test Issue 5";Description="<div>Test Issue description.</div>";Activity="";Area=$projectName;Iteration="$projectName\$sprint";AssignedTo="[Name Placeholder]";Parent="[Parent Number Placeholder]"}
   [pscustomobject]@{Type="Issue";Title="Test Issue 6";Description="<div>Test Issue description.</div>";Activity="";Area=$projectName;Iteration="$projectName\$sprint";AssignedTo="[Name Placeholder]";Parent="[Parent Number Placeholder]"}
   [pscustomobject]@{Type="Issue";Title="Test Issue 7";Description="<div>Test Issue description.</div>";Activity="";Area=$projectName;Iteration="$projectName\$sprint";AssignedTo="[Name Placeholder]";Parent="[Parent Number Placeholder]"}
   [pscustomobject]@{Type="Issue";Title="Test Issue 8";Description="<div>Test Issue description.</div>";Activity="";Area=$projectName;Iteration="$projectName\$sprint";AssignedTo="[Name Placeholder]";Parent="[Parent Number Placeholder]"}
   [pscustomobject]@{Type="Issue";Title="Test Issue 9";Description="<div>Test Issue description.</div>";Activity="";Area=$projectName;Iteration="$projectName\$sprint";AssignedTo="[Name Placeholder]";Parent="[Parent Number Placeholder]"}
   # End of Work Items that will be created #
)

# Blank array that we will use to create a list to print out later.
$newWorkItems=New-Object System.Collections.ArrayList

############################################
# Begin Work Item Creation and Relate to
# Parent Work Item
############################################
# Iterate through array of work items
$workItems | ForEach-Object {
   # Temporary variables
   $type =$_.Type 
   $title=$_.Title
   $description = $_.Description
   $activity=$_.Activity
   $iteration=$_.Iteration
   $assignedTo=$_.AssignedTo
   $parent=$_.Parent
   $project = $_.Area

   # Create the work item
   $resultJson = az boards work-item create --project $project --title $title --type $type --description $description --organization $orgURL --fields "Microsoft.VSTS.Common.Activity=$activity" "System.AreaPath=$project" "System.IterationPath=$iteration" "System.AssignedTo=$assignedTo"
   
   # Capture info from creation
   $callResult = $resultJson | ConvertFrom-Json
   # Set the new work item ID to a variable I can use to assign the parent.
   $newWitID = $callResult.id

   # Associate the new work item to its parent epic
   az boards work-item relation add --id $newWitID --relation-type parent --target-id $parent

   # Create an object out of the info of the new Work Item
   $singleNewWIT = @(
      [pscustomobject]@{WorkItemID=$newWitID;Type=$type;Title=$title;Iteration=$iteration}
   )

   # Add the new work item object to the list
   $newWorkItems.Add($singleNewWIT)
}

$itemCount = $newWorkItems.Count

$currentTime = get-date -f "MM-dd-yyyy (HH-mm-ss)"

# Create text file with list of new work items created during this script run.
$newWorkItems | Out-File -FilePath ".\Reports\New-Work-Items-$currentTime.txt"

# Print info on how many work items were created and where the list of newly created work items can be found.
Write-Output "$itemCount work items were created in the $organizationName Azure DevOps."
Write-Output "List of new work items can be found in .\Reports\New-Work-Items-$currentTime.txt."

# Keeps script window from automatically closing upon finish in case you want to review the output.
Read-Host -Prompt "Press Enter to exit"