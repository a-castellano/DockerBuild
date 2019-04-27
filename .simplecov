SimpleCov.add_group 'DockerBuild', 'lib/.+.sh$'
SimpleCov.add_filter '.git' # Don't include .git
SimpleCov.add_filter 'tests' # Don't include tests folder
SimpleCov.add_filter 'get_coverage' # Don't include get_coverage script
