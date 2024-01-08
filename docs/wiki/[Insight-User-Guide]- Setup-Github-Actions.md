<!-- markdownlint-disable first-line-h1 -->

## GitHub Workflows

Inorder to deploy Archetypes and the basic Platform Azure Landing Zone, there are mainly 4 workflows defined:

1. `deploy-archetypes.yml`  - This deploys archetypes and core resources.
2. `deploy-connectivity.yml` - This deploys connectivity resources.
3. `deploy-identity.yml` - This deploys identity resources.
4. `deploy-management.yml` - This deploys management resources.

The existing workflows in this repository use Azure Service principal with secret for authentication.To achieve this :

1. [Create an Azure Service Principal programmatically](https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure?tabs=azure-portal%2Cwindows#create-a-service-principal)

    NOTE: You must have sufficient permissions to create Azure Service Principal (Application Administrator role in Azure Active Directory).
          Refer [User Guide - Module Permissions](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/blob/main/docs/wiki/%5BUser-Guide%5D-Module-Permissions.md) to identify the required azure permissions for the Service Principal for deployment.



2. Create GitHub secrets for storing Azure configuration such as CLIENT_ID, CLIENT_SECRET etc. See this [link](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions#creating-secrets-for-a-repository) to find how to add secrets to GitHub.


### OIDC Authentication (GitHub Recommended)

But GitHub recommends using OIDC based authentication for increased security. Check this [official documentation](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-azure) for more details.

To configure the OIDC identity provider in Azure, you will need to perform the following configuration. For instructions on making these changes, refer below sections.

1. [Create an Azure Active Directory application and a service principal](https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure?tabs=azure-portal%2Cwindows#create-a-microsoft-entra-application-and-service-principal).

    NOTE: You must have sufficient permissions to create Azure Service Principal (Application Administrator role in Azure Active Directory).
          Refer [User Guide - Module Permissions](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/blob/main/docs/wiki/%5BUser-Guide%5D-Module-Permissions.md) to identify the required azure permissions for the Service Principal for deployment.

2. [Add federated credentials for the Azure Active Directory application](https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure?tabs=azure-portal%2Cwindows#add-federated-credentials).

3. [Create GitHub secrets for storing Azure configuration](https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure?tabs=azure-portal%2Cwindows#create-github-secrets).

Refer below sample [workflow](###a-sample-workflow-using-OIDC) for terraform deployment using OIDC authentication.

#### A sample workflow using OIDC

```yml


name: Deploy Management Groups and Policies

on:
  workflow_dispatch:
    inputs:
      deploy:
        type: boolean
        description: 'Terraform Apply'

permissions:
  id-token: write
  contents: read

jobs:
  tf_fmt:
    name: Deploy Archetypes
    runs-on: ubuntu-latest
    environment: Production
    steps:

    - name: Checkout Repo
      uses: actions/checkout@v1

    - name: Log in to Azure using OIDC
      uses: azure/login@v1
      with:
        client-id: ${{ secrets.CLIENT_ID }}
        tenant-id: ${{ vars.TENANT_ID }}
        subscription-id: ${{ vars.CONN_SUB_ID }}

    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v2

    - name: Concat Vars
      run: cat env/terraform.global.tfvars env/terraform.archetypes.tfvars > temp.tfvars && cat temp.tfvars > terraform.archetypes.tfvars

    - name: Terraform init
      id: init
      run: terraform init
      env:
        ARM_CLIENT_ID: ${{ secrets.CLIENT_ID }}
        ARM_TENANT_ID:  ${{ vars.TENANT_ID }}
        ARM_SUBSCRIPTION_ID:  ${{ vars.CONN_SUB_ID }}
        ARM_USE_OIDC: true

    - name: Terraform validate
      id: validate
      run: terraform validate
      env:
        ARM_CLIENT_ID: ${{ secrets.CLIENT_ID }}
        ARM_TENANT_ID:  ${{ vars.TENANT_ID }}
        ARM_SUBSCRIPTION_ID:  ${{ vars.CONN_SUB_ID }}
        ARM_USE_OIDC: true

    - name: Terraform workspace
      id: workspace
      run: terraform workspace select archetypes
      env:
        ARM_CLIENT_ID: ${{ secrets.CLIENT_ID }}
        ARM_TENANT_ID:  ${{ vars.TENANT_ID }}
        ARM_SUBSCRIPTION_ID:  ${{ vars.CONN_SUB_ID }}
        ARM_USE_OIDC: true

    - name: Terraform plan
      id: plan
      run: terraform plan -parallelism=5 -var-file="terraform.archetypes.tfvars"
      env:
        ARM_CLIENT_ID: ${{ secrets.CLIENT_ID }}
        ARM_TENANT_ID:  ${{ vars.TENANT_ID }}
        ARM_SUBSCRIPTION_ID:  ${{ vars.CONN_SUB_ID }}
        ARM_USE_OIDC: true

    - name: Terraform apply
      if: ${{ inputs.deploy }}
      id: apply
      run: terraform apply -auto-approve -parallelism=5 -var-file="terraform.archetypes.tfvars"
      env:
        ARM_CLIENT_ID: ${{ secrets.CLIENT_ID }}
        ARM_TENANT_ID:  ${{ vars.TENANT_ID }}
        ARM_SUBSCRIPTION_ID:  ${{ vars.CONN_SUB_ID }}
        ARM_USE_OIDC: true
```

