# config valid only for current version of Capistrano
lock "3.8.1"

set :application, "report-agent"
set :repo_url, "git@git.vpn:agents/report-agent.git"
set :branch, "master"
set :deploy_to, "/home/creaxon/report-agent"
set :keep_releases, 5

set :linked_dirs, %w{ vol/log }

namespace :deploy do
  before :finished, :docker_compose_rebuild_restart do
    on roles(:app) do

      Dir.glob("../vol/config/deploy/#{fetch(:stage)}/{.[^.],}*").each do |f|
        upload! f, "#{current_path}/vol/config/", recursive: true
      end

      within("#{fetch(:deploy_to)}/current") do
        execute "bin/build"
        execute "bin/restart"
      end
    end
  end
end
