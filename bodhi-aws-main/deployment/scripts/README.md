# Bodhi Core Setup Guide
**https://pscode.lioncloud.net/enterprise-insights/bodhi-aws-stack.git**
Step by Step Guide for Bodhi Core Setup

iVGkLxYBpEc8Tf2P

https://confluence.belcorp.biz/display/TF/01+-+Prerequisite+for+Bodhi+Core+deployment+on+AWS
https://admin-doc.psbodhi.ai/bodhi-admin-doc/7zmhWeZSOgrBqfZJEEKd/

### Steps to Configure AWS Assume Role account

 - Switch Role with ACCOUNT_ID and ROLE_NAME
 - Configure with 
      ```
      aws configure
      cd ~/.aws/credentials
      vim  ~/.aws/credentials # add the below configuration


#### Prep Phase

- aws configure. set access ID, secret, default-region, format(json)

```bas
aws configure
```
## Make
check if **Make** command working on your machine

```bash
make --version
```
## Ensure images are available in your ECR for current region use the helper script

**STEP1**
```
make push-image-ecr
```

**STEP2**
## Deploy One click
```
make one-click-build
```


##  User Onboarding
```bash
#make user-onboarding FIRSTNAME_LASTNAME=rahul.roy EMAIL_ID=rahul@gmail.com
make connect-cluster
make user-onboarding FIRSTNAME_LASTNAME=<> EMAIL_ID=<>
make set-user
```
sed '/aniruddha-choudhury/,+1 d'
sed -i.bak '/- profiles/aniruddha-choudhury/,+1 d'  kustomization.yaml

sed '/aniruddha-choudhury/d' kustomization.yaml && mv changed.txt filename


make user-onboarding FIRSTNAME_LASTNAME=aniruddha-paul EMAIL_ID=aniruddha.paul@pubicissapient.com
make set-user

**TERMINAL1 (RIGHT)**
```
make argo-portforward 
```

**TERMINAL2 (LEFT)**
```
make connect-argo-local 
```



## Get Credentials
```
make credentials-application 
```

## Destroy
**Caution: Before destroying the infra and resources keep a back-up for the S3,EFS,RDS**

```bash
make one-click-destroy
```





