pipeline {
  agent any
  environment {
    registryCredential = 'dockerhub'
  }
stages {
  stage('Build') {
    steps {
      sh 'docker build -t linuxserver/docker-nginx .'
    }
  }
stage('Test') {
  steps {
    sh 'docker container rm -f node'
    sh 'docker container run -p 8091:8080 --name node -d linuxserver/docker-nginx'
    sh 'curl -I http://localhost:8091'
  }
}
stage('Publish') {
    steps{
        script {
            docker.withRegistry( '', registryCredential ) {
              sh 'docker push qqqasim/docker-nginx:latest'
	    }
        }
     }
   }
  }
}
