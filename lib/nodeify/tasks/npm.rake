desc "Install npm packages specified in vendor/package.json"
namespace :npm do
  task :install do
    `(cd vendor/ && npm install)`
  end
end

