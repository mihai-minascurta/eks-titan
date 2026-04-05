pipeline {
    agent any
    
    // 1. THE BRAIN: Asking you for the command
    parameters {
        choice(name: 'ACTION', choices: ['APPLY', 'DESTROY'], description: 'Do you want to build or burn the Matrix?')
    }
    
    stages {
        stage('1. Download Code') {
            steps {
                git branch: 'main', url: 'https://github.com/mihai-minascurta/YOUR_REPO_NAME.git' // <-- CHANGE TO YOUR REPO
            }
        }
        
        stage('2. Execute Terraform') {
            steps {
                dir('main') { // <-- Change 'main' to '.' if your .tf files are in the root folder
                    sh 'terraform init'
                    
                    // 2. THE LOGIC: Reading your choice
                    script {
                        if (params.ACTION == 'APPLY') {
                            echo "Executing Build Sequence..."
                            sh 'terraform apply -auto-approve'
                        } 
                        else if (params.ACTION == 'DESTROY') {
                            echo "Executing Demolition Sequence..."
                            sh 'terraform destroy -auto-approve'
                        }
                    }
                }
            }
        }
    }
}
