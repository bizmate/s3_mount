# AWS S3 MOUNT 
Example repository to show how to install S3FU - Fuse and configure a S3 mountpoint
Default can run on Vagrant but you can also spin it on AWS

## Required
   After signing up for AWS and setting up your S3 Bucket
   Set up these environment variables running the following on your host machine shell/command
   ```
   AWS_S3_ACCESS_KEY=myverylongkey
   AWS_S3_ACCESS_SECRET=myverylongsecret
   AWS_S3_BUCKET=myAwsS3BucketName
   export AWS_S3_ACCESS_KEY
   export AWS_S3_ACCESS_SECRET
   export AWS_S3_BUCKET
   ```
   
   You also need these environment variables if you would like to provision the machine on AWS EC2
   The below are not needed for local vagrant provisioning
   
   ```
   export AWS_SESSION_TOKEN=MyToken
   export AWS_KEYPAIR_NAME=MyKeypairname
   export AWS_AMI=MyFavouriteAmiType
   export AWS_SECURITY_GROUP=MyKSecurityGroup
   export AWS_SSH_PRIVATE_KEY_PATH=MyPrivateKeyPath
   ```
   
Notice

USE at your own peril, this instance is not hardened for production and is just a base example on how you could get 
started for a more structured VM providing an FTP server backed by S3 on EC2