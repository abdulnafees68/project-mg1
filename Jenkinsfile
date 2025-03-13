pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "your-dockerhub-username/angular-minikube:latest"
    }

    stages {
        stage('Clone Repository') {
            steps {
                echo "Cloning repository...."
                git credentialsId: 'github-token', url: 'https://github.com/abdulnafees68/project-mg1.git', branch: 'main'
            }
        }

        stage('Install Dependencies') {
            steps {
                echo "Installing dependencies..."
                sh 'npm install'
            }
        }

        stage('Build Angular App') {
            steps {
                echo "Building Angular app..."
                sh 'ng build --configuration production'
            }
        }

        stage('Package as Docker Image') {
            steps {
                echo "Building Docker image..."
                sh "docker build -t $DOCKER_IMAGE ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([string(credentialsId: 'docker-hub-password', variable: 'DOCKER_HUB_PASSWORD')]) {
                    echo "Logging in to Docker Hub..."
                    sh """
                    echo "$DOCKER_HUB_PASSWORD" | docker login -u nafees68 --password-stdin
                    docker push $DOCKER_IMAGE
                    """
                }
            }
        }
    }
}
