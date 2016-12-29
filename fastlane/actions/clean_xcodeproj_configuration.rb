module Fastlane
  module Actions
    module SharedValues
    end

    class CleanXcodeprojConfigurationAction < Action
      def self.run(params)
        xcodeproj = params[:xcodeproj]
        project_name = File.basename(xcodeproj, ".xcodeproj")
        schemes = Dir[File.join(xcodeproj, 'xcshareddata', 'xcschemes', '*.xcscheme')]
        project = Xcodeproj::Project.open(xcodeproj)
        all_targets_map = Hash[project.targets.map { |key| [key.name, key] }]
        all_schemes_map = Hash[schemes.map { |key| [File.basename(key, ".xcscheme"), key] }]
        if params[:ios_available] == false
          self.remove_platform(all_targets_map, all_schemes_map, project_name, "iOS")
        end
        if params[:watchos_available] == false
          self.remove_platform(all_targets_map, all_schemes_map, project_name, "watchOS")
        end
        if params[:tvos_available] == false
          self.remove_platform(all_targets_map, all_schemes_map, project_name, "tvOS")
        end
        if params[:osx_available] == false
          self.remove_platform(all_targets_map, all_schemes_map, project_name, "OSX")
        end
        project.save()
      end

      def self.remove_platform(all_targets_map, all_schemes_map, project_name, platform)
        if target = all_targets_map["#{project_name}Tests-#{platform}"]
          target.remove_from_project()
        end
        if target = all_targets_map["#{project_name}-#{platform}"]
          target.remove_from_project()
        end
        if scheme = all_schemes_map["#{project_name}-#{platform}"]
          File.delete(scheme)
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Removes unused targets, schemes from the Xcode project"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :xcodeproj,
                                       description: "The Xcode project path",
                                       env_name: "XCODEPROJ",
                                       optional: false,
                                       verify_block: proc do |value|
                                         UI.user_error!("Please pass the path to the project, not the workspace") if value.end_with? ".xcworkspace"
                                         UI.user_error!("Could not find Xcode project") if !File.exist?(value) and !Helper.is_test?
                                       end),
          FastlaneCore::ConfigItem.new(key: :ios_available,
                                       description: "iOS available if true, otherwise unavailable",
                                       env_name: "FRAMEWORK_IOS_AVAILABLE",
                                       is_string: false,
                                       default_value: true),
          FastlaneCore::ConfigItem.new(key: :watchos_available,
                                       description: "watchOS available if true, otherwise unavailable",
                                       env_name: "FRAMEWORK_WATCHOS_AVAILABLE",
                                       is_string: false,
                                       default_value: true),
          FastlaneCore::ConfigItem.new(key: :tvos_available,
                                       description: "tvOS available if true, otherwise unavailable",
                                       env_name: "FRAMEWORK_TVOS_AVAILABLE",
                                       is_string: false,
                                       default_value: true),
          FastlaneCore::ConfigItem.new(key: :osx_available,
                                       description: "OSX available if true, otherwise unavailable",
                                       env_name: "FRAMEWORK_OSX_AVAILABLE",
                                       is_string: false,
                                       default_value: true)
        ]
      end

      def self.authors
        ["bbriatte", "vbalasubramaniam"]
      end

      def self.is_supported?(platform)
        [:ios, :mac].include?(platform)
      end

      def self.category
        :project
      end
    end
  end
end
