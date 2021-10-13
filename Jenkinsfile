pipeline {
    agent any
    stages {
    stage('Initialise Terraform') {
        when {
                expression { 
                   return params.Choice == 'Init'
                }
            }
            steps {
                sh '/opt/homebrew/bin/terraform init'
            }
    }

    stage('Terraform plan') {
        when {
                expression { 
                   return params.Choice == 'Plan'
                }
            }
        
        steps {
            withAWS(credentials: 'tf_user_ec2') {
                sh '/opt/homebrew/bin/terraform plan'
            }
        }
      
    }

    stage('Create Kafka Broker EC2 instance') {
      when {
                expression { 
                   return params.Choice == 'Apply'
                }
            }
        
        steps {
            withAWS(credentials: 'tf_user_ec2') {
                sh 'bash terraform.sh'
            }
        }
    }

    stage('Install Kafka Broker') {
        when {
                expression { 
                   return params.Choice == 'Install Kafka Broker'
                }
            }
        steps {
            step{
            def userInput = input(
 id: 'userInput', message: 'Let\'s promote?', parameters: [
 [$class: 'TextParameterDefinition', defaultValue: 'uat', description: 'Environment', name: 'env']
])
echo ("Env: "+userInput)
                sh '/opt/homebrew/bin/ansible-playbook -i /Users/shashanksrivastava/ansible_hosts Ansible/install_kafka_broker.yaml'
            }
    }
    }

    stage('Destroy Kafka Broker EC2 instance') {
      when {
                expression { 
                   return params.Choice == 'Destroy'
                }
            }
        
        steps {
            withAWS(credentials: 'tf_user_ec2') {
                sh '/opt/homebrew/bin/terraform destroy -auto-approve'
            }
        }
    }
}
}
