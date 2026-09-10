terraform {
  backend "s3" {
    bucket         = "vshuleshko-tf-devops-13fp"
    key            = "eks/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    use_lockfile   = true
    # dynamo key LockID
    # Params tekan from -backend-config when terraform init
    #region = 
    #profile = 
  }
}


