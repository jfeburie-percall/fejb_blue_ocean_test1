pipeline {
  agent any
  stages {
    stage('Initialize') {
      steps {
        tool(name: 'Ant1.10.1', type: 'Ant')
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