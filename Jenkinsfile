pipeline {  
  environment {
    registry = "localhost/scratch-ruby:3.0.0-build-"
    //registryCredential = 'dockerhub'
  }
  agent any  
  stages {
    stage('Building image') {
      steps{
        script {
          docker.build registry + "$BUILD_NUMBER"
        }
      }
    }
  }
}
