pipeline {  
  environment {
    registry = "localhost/scratch-ruby"
    //registryCredential = 'dockerhub'
  }
  agent any  stages {
    stage('Building image') {
      steps{
        script {
          docker.build registry + ":$BUILD_NUMBER"
        }
      }
    }
  }
}
