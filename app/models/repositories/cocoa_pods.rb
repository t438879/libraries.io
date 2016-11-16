module Repositories
  class CocoaPods < Base
    HAS_VERSIONS = true
    HAS_DEPENDENCIES = false
    LIBRARIAN_SUPPORT = true
    URL = 'http://cocoapods.org/'
    COLOR = '#438eff'

    def self.project_names
      @project_names ||= get_json("http://cocoapods.libraries.io/pods.json")
    end

    def self.project(name)
      versions = get_json("http://cocoapods.libraries.io/pods/#{name}.json")
      latest_version = versions.keys.sort_by{|version| version.split('.').map{|v| v.to_i}}.last
      versions[latest_version].merge('versions' => versions)
    end

    def self.mapping(project)
      {
        :name => project['name'],
        :description => project["summary"],
        :homepage => project["homepage"],
        :licenses => project['license']['type'],
        :repository_url => repo_fallback(project['source']['git'], '')
      }
    end

    def self.versions(project)
      project['versions'].keys.map do |v|
        {
          :number => v.to_s
        }
      end
    end
  end
end
