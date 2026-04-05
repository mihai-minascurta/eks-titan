pipeline {
    agent any
    
    stages {
        stage('1. Download Code') {
            steps {
                // The Robot pulls your code from GitHub
                git branch: 'main', url: 'https://github.com/mihai-minascurta/eks-titan.git'
            }
        }
        
        stage('2. Build the Matrix (Terraform)') {
            steps {
                // The Robot goes into the folder with your .tf files
                // CHANGE 'main' to '.' if your tf files are in the root folder!
                dir('main') { 
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }
        
        stage('3. Connect to the Brain') {
            steps {
                // The Robot securely gets the keys to your EKS Cluster
                sh 'aws eks update-kubeconfig --region eu-central-1 --name titan-eks-cluster'
            }
        }
    }
}
