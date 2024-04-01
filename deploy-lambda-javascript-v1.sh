#! /bin/bash

export TOKEN=$(gcloud auth print-access-token)

# Env 
apigeecli -t $TOKEN kvms create --org=$ORG --env=$ENV --name=lambda
apigeecli -t $TOKEN kvms entries create --org=$ORG --env=$ENV --map=lambda --key=key --value=$AWS_KEY
apigeecli -t $TOKEN kvms entries create --org=$ORG --env=$ENV --map=lambda --key=secret --value=$AWS_SECRET
apigeecli -t $TOKEN kvms entries create --org=$ORG --env=$ENV --map=lambda --key=host --value=$AWS_HOST
apigeecli -t $TOKEN kvms entries create --org=$ORG --env=$ENV --map=lambda --key=region --value=$AWS_REGION
apigeecli -t $TOKEN kvms entries create --org=$ORG --env=$ENV --map=lambda --key=service --value=$AWS_SERVICE
apigeecli -t $TOKEN kvms entries list --org=$ORG --env=$ENV --map=lambda 

apigeecli -t $TOKEN apis create bundle --org=$ORG --env=$ENV --name=lambda-javascript-v1 --proxy-folder=./apiproxy --wait=true

