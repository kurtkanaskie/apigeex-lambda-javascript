#! /bin/bash

export ORG=apigeex-your-org
export PROXY=lambda
export ENV=dev

export TOKEN=$(gcloud auth print-access-token)
# My credentials in AWS
export KEY=AKIAY***
export SECRET=UXa***
export HOST=clqsmkwz26wtp***.lambda-url.us-east-2.on.aws
export REGION=us-east-2
export SERVICE=lambda


# apigeecli -t $TOKEN kvms create --org=$ORG --proxy=$PROXY --name=$PROXY
# apigeecli -t $TOKEN kvms entries create --org=$ORG --proxy=$PROXY --map=$PROXY --key=key --value=$KEY
# apigeecli -t $TOKEN kvms entries create --org=$ORG --proxy=$PROXY --map=$PROXY --key=secret --value=$SECRET
# apigeecli -t $TOKEN kvms entries create --org=$ORG --proxy=$PROXY --map=$PROXY --key=host --value=$HOST
# apigeecli -t $TOKEN kvms entries create --org=$ORG --proxy=$PROXY --map=$PROXY --key=region --value=$REGION
# apigeecli -t $TOKEN kvms entries create --org=$ORG --proxy=$PROXY --map=$PROXY --key=service --value=$SERVICE
# apigeecli -t $TOKEN kvms entries list --org=$ORG --proxy=$PROXY --map=$PROXY 

# # My stuff
# apigeeclix kvms entries update --org=$ORG --proxy=$PROXY --map=$PROXY --key=key --value=$KEY
# apigeeclix kvms entries update --org=$ORG --proxy=$PROXY --map=$PROXY --key=secret --value=$SECRET
# apigeeclix kvms entries update --org=$ORG --proxy=$PROXY --map=$PROXY --key=host --value=$HOST
# apigeeclix kvms entries update --org=$ORG --proxy=$PROXY --map=$PROXY --key=region --value=$REGION
# apigeeclix kvms entries list --org=$ORG --proxy=$PROXY --map=$PROXY 

# Env 
apigeecli -t $TOKEN kvms create --org=$ORG --env=$ENV --name=lambda
apigeecli -t $TOKEN kvms entries create --org=$ORG --env=$ENV --map=lambda --key=key --value=$KEY
apigeecli -t $TOKEN kvms entries create --org=$ORG --env=$ENV --map=lambda --key=secret --value=$SECRET
apigeecli -t $TOKEN kvms entries create --org=$ORG --env=$ENV --map=lambda --key=host --value=$HOST
apigeecli -t $TOKEN kvms entries create --org=$ORG --env=$ENV --map=lambda --key=region --value=$REGION
apigeecli -t $TOKEN kvms entries create --org=$ORG --env=$ENV --map=lambda --key=service --value=$SERVICE
apigeecli -t $TOKEN kvms entries list --org=$ORG --env=$ENV --map=lambda 

# For updates
apigeecli -t $TOKEN kvms entries update --org=$ORG --env=$ENV --map=lambda --key=key --value=$KEY
apigeecli -t $TOKEN kvms entries update --org=$ORG --env=$ENV --map=lambda --key=secret --value=$SECRET
apigeecli -t $TOKEN kvms entries update --org=$ORG --env=$ENV --map=lambda --key=host --value=$HOST
apigeecli -t $TOKEN kvms entries update --org=$ORG --env=$ENV --map=lambda --key=region --value=$REGION
apigeecli -t $TOKEN kvms entries update --org=$ORG --env=$ENV --map=lambda --key=service --value=$SERVICE
apigeecli -t $TOKEN kvms entries list --org=$ORG --env=$ENV --map=lambda 
