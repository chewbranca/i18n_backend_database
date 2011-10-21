namespace :i18n do
  desc 'Clear cache'
  task :clear_cache => :environment do
    I18n.backend.cache_store.clear
  end
  
  namespace :populate do
    desc 'Populate the locales and translations tables from all Rails Locale YAML files. Can set LOCALE_YAML_FILES to comma separated list of files to overide'
    task :from_rails => :environment do
      yaml_files = ENV['LOCALE_YAML_FILES'] ? ENV['LOCALE_YAML_FILES'].split(',') : I18n.load_path
      yaml_files.each do |file|
        I18nUtil.load_from_yml file
      end
    end

    desc 'Populate the translation tables from translation calls within the application. This only works on basic text translations. Can set DIR to override starting directory.'
    task :from_application => :environment do
      dir = ENV['DIR'] ? ENV['DIR'] : "."
      I18nUtil.seed_application_translations(dir)
    end

    desc 'Create translation records from all default locale translations if none exists.'
    task :synchronize_translations => :environment do
      I18nUtil.synchronize_translations
    end

    desc 'Populate default locales'
    task :load_default_locales => :environment do
      I18nUtil.load_default_locales(ENV['LOCALE_FILE'])
    end

    desc 'Runs all populate methods in this order: load_default_locales, from_rails, from_application, synchronize_translations'
    task :all => ["load_default_locales", "from_rails", "from_application", "synchronize_translations"]
  end

  namespace :translate do
    desc 'Translate all untranslated values using Google Language Translation API.  Does not translate interpolated strings, date formats, or YAML'
    task :google => :environment do
      I18nUtil.google_translate
    end
  end
  
  desc "Sync extra files from blogify plugin"  
  task :sync do  
    system "rsync -ruv vendor/plugins/i18n_backend_database/public ."
  end  
end