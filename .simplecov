SimpleCov.add_group 'DockerBuild', 'lib/.+.sh$'
SimpleCov.add_filter '.git' # Don't include .git
SimpleCov.add_filter 'tests' # Don't include tests folder
