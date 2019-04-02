function ssh-bastion
	set-aws-creds $argv
	ssh (~/src/bitbucket.org/theasi/infra-deploy-aws/scripts/get-bastion-ip.sh);
end
