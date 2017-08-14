pipeline {
  agent any
  stages {
    stage('Initialize') {
      steps {
		def antVersion = 'Ant1.10.1'
			withEnv( ["ANT_HOME=${tool antVersion}"] ) {
				echo 'ANT_HOME = 'ANT_HOME
			}
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
