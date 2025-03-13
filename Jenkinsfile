pipeline {
    agent any

    environment {
       DOCKER_IMAGE = "your-dockerhub-username/angular-minikube:latest"
        SONARQUBE_URL = "http://20.9.136.192:9000" // Update with your SonarQube URL
        SONARQUBE_TOKEN = credentials('sonarqube-token') // Jenkins credentials for SonarQube

    }

    stages {
        stage('Clone Repository') {
            steps {
                echo "Cloning repository...."
                git credentialsId: 'github-token', url: 'https://github.com/abdulnafees68/project-mg1.git', branch: 'main'
            }
        }
             stage('Run SonarQube Analysis') {
            steps {
                script {
                    echo "Running SonarQube analysis..."
                    sh """
                        docker run --rm \
                            -v \$(pwd):/mnt \
                            -e SONAR_HOST_URL=$SONARQUBE_URL \
                            -e SONAR_LOGIN=$SONARQUBE_TOKEN \
                            sonarsource/sonar-scanner-cli
                    """
                }
            }
        }

        stage('Package as Docker Image') {
            steps {
                echo "Building Docker image..."
              sh "docker build -t nafees68/angular-minikube:latest ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([string(credentialsId: 'docker-hub-password', variable: 'DOCKER_HUB_PASSWORD')]) {
                    echo "Logging in to Docker Hub..."
                    sh """
                    echo "$DOCKER_HUB_PASSWORD" | docker login -u nafees68 --password-stdin
                    docker push nafees68/angular-minikube:latest
                    """
                }
            }


          
    post {
        always {
            echo 'Cleaning up...'
            // Clean up any intermediate Docker images if necessary
            sh 'docker system prune -f'
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed, investigate errors above.'
        }
    }
}
        }
    }
}
