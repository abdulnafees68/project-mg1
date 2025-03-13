pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/your-github-username/angular-minikube.git', branch: 'main'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Build Angular App') {
            steps {
                sh 'ng build --configuration production'
            }
        }

        stage('Package as Docker Image') {
            steps {
                sh '''
                docker build -t your-dockerhub-username/angular-minikube:latest .
                docker login -u your-dockerhub-username -p your-dockerhub-password
                docker push your-dockerhub-username/angular-minikube:latest
                '''
            }
        }
    }
}

