namespace :swagger do
  desc "Generate Swagger documentation"
  task :generate do
    sh "rspec spec/requests --format Rswag::Specs::SwaggerFormatter"
  end
end


# rake swagger:generate