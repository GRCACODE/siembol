$CONFIG_MAP_NAME_GIT="github-details"
$GIT_SECRET_NAME="config-editor-rest-secrets"
$NAMESPACE="siembol"

function Git-Details {
    $GIT_USERNAME = Read-Host -Prompt 'Github username'
    $GIT_URL = Read-Host -Prompt 'Github URL'
    $GIT_REPO_NAME = Read-Host -Prompt 'Github repo name' 
    $GIT_TOKEN = Read-Host -Prompt 'Github personal token' 

    Write-Output "You entered these details: "
    Write-Output "Github username: $GIT_USERNAME"
    Write-Output "Github URL: $GIT_URL"
    Write-Output "Github repo name: $GIT_REPO_NAME"
    Write-Output "Github personal token: $GIT_TOKEN"

    $choice = Read-Host -Prompt "Are these details correct? (yes/no)" 
    Write-Output $choice
    if ($choice -eq 'yes') {
        Write-Output "creating configmap"
        kubectl create configmap $CONFIG_MAP_NAME_GIT -n $NAMESPACE --from-literal=GITHUB_USER=$GIT_USERNAME --from-literal=GITHUB_URL=$GIT_URL --from-literal=GITHUB_REPO_NAME=$GIT_REPO_NAME 
        sleep 3
        Write-Output "Creating github secret"
        kubectl create secret generic $GIT_SECRET_NAME -n $NAMESPACE --from-literal=git=$GIT_TOKEN
        sleep 3
    } else {
        Write-Output "Run script again"
        exit 1

    }
}

Write-Output "************** Install Script For Demo **************"
Write-Output "*****************************************************"

$zookeeper_status=$(kubectl get pods --namespace $NAMESPACE -l "app.kubernetes.io/component=zookeeper,app.kubernetes.io/instance=storm,app.kubernetes.io/name=zookeeper" -o jsonpath="{.items[0].status.containerStatuses[0].ready}")
if ($zookeeper_status -eq 'True')  {
    Git-Details
    Write-Output "************************************************************"
    Write-Output "******  You can now deploy siembol from helm charts   ******"
    Write-Output "************************************************************"
} else {
    Write-Output "Zookeeper pod is not running yet, please try again in a few seconds"
    exit 1
}
