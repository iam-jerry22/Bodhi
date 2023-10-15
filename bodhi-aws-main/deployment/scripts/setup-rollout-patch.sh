read -p 'Clustername (for Bodhi Core Cluster Name): ' CLUSTER_NAME
read -p 'Accountid (for Bodhi Core aws acount ID): ' AWS_ACCOUNTID
echo $CLUSTER_NAME, $AWS_ACCOUNTID


kubectl get nodes
kubectl annotate serviceaccount -n kube-system aws-node eks.amazonaws.com/role-arn=arn:aws:iam::$AWS_ACCOUNTID:role/$CLUSTER_NAME-eks-cni
kubectl rollout restart -n kube-system ds/aws-node
