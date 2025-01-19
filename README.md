# mic_home_assignment
- clone the project 
- go to variables and put your account id 
- if you have aws sso configured grate else run aws configure and put your credentials
- create an ssh key using ssh-keygen and create a key named ec2_key for the ec2 key pair or call it the name you want but change it in the ec2 instance in the name of the key or the variable you call it 
- run terraform init 
- terraform validate
- terraform plan 
- enter the account id or create a file before called .auto.tfvars to automate this proccess and enter there the name of the variable = variable i'll add a image
-  ![screenshot](imageFolder/Screenshot%202025-01-19%20at%2016.05.04.png)
- after that you can run terraform apply
- enter yes
- when uploaded go to ec2 public ip and paste it in the browser (i hope i'll have time to put there a nice web)
- i allow ingress via port http as you can cee in the public security group 
- and via ssh 
- to show we have communication with the db you need to enter via ssh 
- go to your ssh key chose the public ec2 key 
- i love using ssh agent but you can also type in 
- ssh -i path/to/the/key ec2_user@<public ip>
- if you are using ssh agent use ssh-add and then just type ssh ec2_user@<public ip> and you will be entered
- then please enter all the next commands 

```sudo dnf update -y```

```sudo dnf install mariadb105```

```sudo dnf install mariadb105```

```mysql -h [rds endpoint from the outputs] -P 3306 -u [the user admin] -p [press enter ]```

```SHOW Databases;```

- for the ci cd i used github actions i have there also tflint for errors and tfsec for security issues, 
- but i disabled tfsec because of running out of time.
- there are terraform init, plan, and apply,
- end there is another config file that schedules it down at midnight every day,
- we can also add the commands to of the shutting down to the end of the apply file, and it will apply and destroy rite away.
- you will need to add to GitHub actions your aws secrets like access key id and the session 

- there is a cloudFormation.yaml attached to

- this answers on the home assignment without the bonus...
- i worked on the bonus eks with argoCD but didn't complete it yet so i didn't publish it
- if you would like to see it you can contact me and i'll show you... 
- thanks for this assignment it was written very good ! 


