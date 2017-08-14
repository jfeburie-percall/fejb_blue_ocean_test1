pipeline {
	environment {
		def antVersion = 'Ant1.10.1'
	}

	agent any
	stages {
		stage('Initialize') {
			steps {
				withEnv( ["ANT_HOME=${tool antVersion}"] ) {
					echo '${ANT_HOME}'
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
