$: << File.dirname(__FILE__)+'/../../lib'

require 'rubygems'
require 'cucumber/rspec/doubles'
require 'basefile'

config = YAML.load_file("config/cle-it.yaml")
$admin_user = config['admin_user']
$admin_password = config['admin_password']
$server = config['server']

$role = config['role']
$role_user = config['role_user']
$role_password = config['role_password']

$test_job_name = config['test_job_name']
$test_job_type = config['test_job_type']
$site_id = config['site_id']
$user_id = config['user_id']
$files_load_time_in_seconds = config['files_load_time_in_seconds']

World Authenticate
World Webservices
