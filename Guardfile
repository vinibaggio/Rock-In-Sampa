guard 'minitest' do
  watch(%r|^spec/(.*)_spec\.rb|)
  watch(%r|^scrapers/(.*)\.rb|)            { |m| "spec/scrapers/#{m[1]}_spec.rb" }
  watch(%r|^jobs/(.*)\.rb|)                { |m| "spec/jobs/#{m[1]}_spec.rb" }
  watch(%r|^models/(.*)\.rb|)              { |m| "spec/models/#{m[1]}_spec.rb" }
  watch(%r|^app/(.*)\.rb|)                 { |m| "spec/app/#{m[1]}_spec.rb" }
  watch(%r|^spec/spec_helper\.rb|)         { "spec" }
end
