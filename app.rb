require('sinatra')
require('sinatra/reloader')
require('./lib/project')
require('./lib/volunteer')
require('pry')
also_reload('lib/**/*.rb')
require("pg")

DB = PG.connect({:dbname => "volunteer_tracker"})

get('/') do
  @projects = Project.all()
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
  @volunteers = @project.volunteers()
  erb(:details)
end

get('/projects/:id/edit') do
  @project = Project.find(params[:id].to_i())
  erb(:edit_page)
end

patch('/project/:id') do
  @project = Project.find(params[:id].to_i())
  @project.update(params[:title])
  @volunteers = @project.volunteers()
  erb(:details)
end

delete('/project/:id') do
  @project = Project.find(params[:id].to_i())
  @project.delete()
  @projects = Project.all()
  erb(:homepage)
end

# -------------- VOLUNTEERS -------------- 

post('/project/:id/volunteers') do
  @project = Project.find(params[:id].to_i())
  name = params[:name]
  volunteer = Volunteer.new({:name => name, :project_id => @project.id, :id => nil})
  volunteer.save()
  @volunteers = @project.volunteers()
  erb(:details)
end

get('/volunteers/:id') do
  @volunteer = Volunteer.find(params[:id].to_i())
  @projects = Project.all()
  erb(:volunteer_detail)
end

patch('/volunteer/:id') do
  @volunteer = Volunteer.find(params[:id].to_i())
  @project = @volunteer.project
  @volunteer.update(params[:name], @project.id)
  @volunteers = @project.volunteers()
  erb(:details)
end