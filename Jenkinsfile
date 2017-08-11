pipeline {
  agent any
  stages {
    stage('Initialize') {
      steps {
        sh '''echo env.JAVA_HOME = ${env.JAVA_HOME}


echo env.ANT_HOME = ${env.ANT_HOME}'''
      }
    }
    stage('Build') {
      steps {
        echo 'Starting Build'
        echo 'Build Complete'
      }
    }
  }
}