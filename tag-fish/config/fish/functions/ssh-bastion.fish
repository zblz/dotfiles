function ssh-bastion
    set BASTION_IP (aws-vault exec $argv ~/src/bitbucket.org/theasi/infra-deploy-aws/scripts/get-bastion-ip.sh);
    ssh victor@$BASTION_IP
end
