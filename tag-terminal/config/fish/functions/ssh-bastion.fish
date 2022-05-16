function ssh-bastion

    if test (count $argv) -eq 1;
        set profile $argv[1]
    else if set -q AWS_PROFILE;
        set profile $AWS_PROFILE
    else
        echo "Couldn't tell what AWS profile to connect to: set AWS_PROFILE env var, or call 'bastion <profilename>'"
        return 1
    end

    set -l instanceId (aws ec2 --profile $profile describe-instances | jq --raw-output '.Reservations[].Instances[] | select(.Tags[]
    | contains( {"Key": "Name", "Value": "sherlockml-bastion"})) | .InstanceId')
    echo "Using \"$profile\" AWS profile to connect to EC2 instance ID: \"$instanceId\""

    mssh --profile $profile kops@$instanceId
end
