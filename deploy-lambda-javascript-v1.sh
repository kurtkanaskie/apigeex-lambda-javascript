#! /bin/bash

export TOKEN=$(gcloud auth print-access-token)

# Env 
apigeecli -t $TOKEN kvms create --org=$ORG --env=$ENV --name=lambda
apigeecli -t $TOKEN kvms entries create --org=$ORG --env=$ENV --map=lambda --key=key --value=$KEY
apigeecli -t $TOKEN kvms entries create --org=$ORG --env=$ENV --map=lambda --key=secret --value=$SECRET
apigeecli -t $TOKEN kvms entries create --org=$ORG --env=$ENV --map=lambda --key=host --value=$HOST
apigeecli -t $TOKEN kvms entries create --org=$ORG --env=$ENV --map=lambda --key=region --value=$REGION
apigeecli -t $TOKEN kvms entries create --org=$ORG --env=$ENV --map=lambda --key=service --value=$SERVICE
apigeecli -t $TOKEN kvms entries list --org=$ORG --env=$ENV --map=lambda 

apigeecli -t $TOKEN apis create bundle --org=$ORG --env=$ENV --name=lambda-javascript-v1 --proxy-folder=./apiproxy --wait=true
