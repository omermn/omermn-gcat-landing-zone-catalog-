COS_NAME=$1    # Name of the COS instance where objects will be uploaded
BUCKET_NAME=$2 # Name of the bucket to upload to
KEY=$3         # Name of the object as it will appear in the bucket
BODY=$4        # Path to the file that will be uploaded
WORKSPACE=$5   # (Optional) Schematics workspace
# Get CRN from the resource API
COS_CRN=$(ibmcloud resource service-instance $COS_NAME --output json | jq -r ".[0].id")
# Setup config to allow upload to COS from command line
ibmcloud cos config crn --crn $COS_CRN --force
# Upload object
ibmcloud cos object-put --bucket $BUCKET_NAME --key $KEY --body $BODY

# If workspace is provided
if [ "$WORKSPACE" != "" ]; then
    WORKSPACE_NAME=$WORKSPACE

    # Get list of schematics workspaces with only names and IDs. sed is used to remove improperly escaped chatacters
    WORKSPACE_LIST_RAW=$(
        ibmcloud schematics workspace list --output json | sed 's/\\\</</g' | sed 's/\\\>/>/g'| sed 's/\\\&/\&/g' | jq ".workspaces | .[] | {name: .name, id: .id}"
    )

    # Convert raw list into parsable JSON string
    WORKSPACE_LIST_JSON=$(
        echo "[$(echo $WORKSPACE_LIST_RAW | sed 's/} {/},{/g')]"
    )

    # Number of Workspaces 
    WORKSPACES_COUNT=$(echo $WORKSPACE_LIST_JSON | jq ". | length")
    # Get length of array
    WORKSPACES_LENGTH=$(($WORKSPACES_COUNT - 1))
    # Store ID if found
    WORKSPACE_ID=0

    # Look for WORKSPACE name and get id
    for i in $(seq 0 $WORKSPACES_LENGTH)
    do
        FOUND_NAME=$(echo $WORKSPACE_LIST_JSON | jq -r ".[$i].name")
        if [ "$FOUND_NAME" == "$WORKSPACE_NAME" ]; then
            WORKSPACE_ID=$(echo $WORKSPACE_LIST_JSON | jq -r ".[$i].id")
        fi
    done

    # Force schematics apply
    ibmcloud schematics apply --id $WORKSPACE_ID --force
fi