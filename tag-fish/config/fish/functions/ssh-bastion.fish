function ssh-bastion
    ssh (env AWS_PROFILE=$argv AWS_REGION=eu-west-1 ~/src/bitbucket.org/theasi/infra-deploy-aws/scripts/get-bastion-ip.sh);
end
