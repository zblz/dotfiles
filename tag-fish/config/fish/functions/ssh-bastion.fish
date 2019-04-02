function ssh-bastion
	set-aws-creds $argv
	ssh victor@(~/src/bitbucket.org/theasi/infra-deploy-aws/scripts/get-bastion-ip.sh);
end
