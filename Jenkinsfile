pipeline {
	environment {
		def antVersion = 'Ant1.9.9'
	}

	agent any
	stages {
		stage('Initialize') {
			steps {
				withEnv( ["ANT_HOME=${tool antVersion}"] ) {
					echo 'ANT_HOME = ' + ANT_HOME
					bat(/"$ANT_HOME\bin\ant.bat" -version/)
				}
				echo 'env.WORKSPACE = ' + env.WORKSPACE
			}
		}
		stage('Build') {
			steps {
				echo 'Starting Build'
				withEnv( ["ANT_HOME=${tool antVersion}"] ) {
					echo 'ANT_HOME = ' + ANT_HOME
					bat(/"$ANT_HOME\bin\ant.bat" -version/)
				}
				echo 'Build Complete'
			}
		}
	}
}
