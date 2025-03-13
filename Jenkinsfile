pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "nafees68/angular-minikube:latest"
        SONARQUBE_URL = "http://20.9.136.192:9000"  // Update with your SonarQube URL
        SONARQUBE_TOKEN = credentials('sonarqube-token') // Jenkins credentials for SonarQubee
    }

    stages {
        stage('Clone Repository') {
            steps {
                echo "Cloning repository...."
                git credentialsId: 'github-cred', url: 'https://github.com/abdulnafees68/project-mg1.git', branch: 'main'
            }
        }

        stage('Run SonarQube Analysis') {
            steps {
                script {
                    echo "Running SonarQube analysis..."
                    sh """
                        docker run --rm \
                            -v \$(pwd):/usr/src \
                            -w /usr/src \
                            -e SONAR_HOST_URL=$SONARQUBE_URL \
                            -e SONAR_LOGIN=$SONARQUBE_TOKEN \
                            sonarsource/sonar-scanner-cli
                    """
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                sh "docker build -t $DOCKER_IMAGE ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-password', usernameVariable: 'DOCKER_HUB_USERNAME', passwordVariable: 'DOCKER_HUB_PASSWORD')]) {
                    echo "Logging in to Docker Hub..."
                    sh """
                        echo "$DOCKER_HUB_PASSWORD" | docker login -u "$DOCKER_HUB_USERNAME" --password-stdin
                        docker push $DOCKER_IMAGE
                    """
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
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
