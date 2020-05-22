  
require('sinatra')
require('sinatra/reloader')
require('./lib/project')
require('./lib/volunteer')
require('pry')
also_reload('lib/**/*.rb')
require("pg")

DB = PG.connect({:dbname => "volunteer_tracker"})

get('/') do
  @projects = Project.all
  erb(:homepage)
end

post('/projects') do
  title = params[:title]
  project = Project.new({:title => title, :id => nil})
  project.save()
  @projects = Project.all()
  erb(:homepage)
end

get('/project/:id') do
  @project = Project.find(params[:id].to_i())
  @volunteers = Volunteer.all()
  erb(:details)
end

get('/projects/:id/edit') do
  @project = Project.find(params[:id].to_i())
  erb(:edit_page)
end

patch('/project/:id') do
  @project = Project.find(params[:id].to_i())
  @project.update(params[:title])
  @volunteers = Volunteer.all()
  erb(:details)
end
