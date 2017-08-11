pipeline {
  agent any
  stages {
    stage('Initialize') {
      steps {
        tool 'Ant1.10.1'
        echo 'ANT_HOME = ${ANT_HOME}'
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