function aws_env
    set -gx AWS_ACCESS_KEY_ID (awk "{ if (\$1 == \"aws_access_key_id\") {print \$3}}" ~/.aws/credentials)
    set -gx AWS_SECRET_ACCESS_KEY (awk "{ if (\$1 == \"aws_secret_access_key\") {print \$3}}" ~/.aws/credentials)
end
