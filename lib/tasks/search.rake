namespace :search do
  task reindex: :environment do
    Event.import(force: true)
  end
end
