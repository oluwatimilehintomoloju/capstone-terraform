## Terraform apply
```
terraform init
terraform apply
```

## Configure kubectl
```
terraform output kubeconfig # save output in ~/.kube/config
aws eks --region eu-west-2 update-kubeconfig --name capstone-eks-cluster
```


## Configure config-map-auth-aws
```
terraform output config-map-aws-auth # save output in config-map-aws-auth.yaml
kubectl apply -f config-map-aws-auth.yaml
```

## See nodes coming up
```
kubectl get nodes
```

## Apply config map if get nodes shows no resources found
```
kubectl apply -f config-map-aws-auth.yaml
```

## Watch nodes coming up
```
kubectl get nodes --watch
```

## See nodes coming up
```
kubectl get nodes
```

## Deploy capstone fronted app
```
kubectl run cmgt-ui --<AWS_ACT_ID>.dkr.ecr.<REGION>.amazonaws.com/cmgt-ui:latest --PORT 3000
```

## Deploy capstone backend app
```
kubectl run cmgt-backend --<AWS_ACT_ID>.dkr.ecr.<REGION>.amazonaws.com/cmgt-backend:latest --PORT 3000
```

## Confirm successful deployment
```
kubectl get deployments
```

## To see pods 
```
kubectl get pods
```

## To connect to it, we'll expose a loadbalancer
```
kubectl expose deployment cmgt-ui --type=LoadBalancer
```

## To see services
```
kubectl get services
```

## To describe services
```
kubectl describe service/cmgt-ui
```

## Destroy
Make sure all the resources created by Kubernetes are removed (LoadBalancers, Security groups), and issue:
```
terraform destroy
```

